/**
 * =hurtigmoms
 * 
 * TODO: VAT amount is relative to selected account.
 * 
 */

hurtigmoms = {
	locale: 'da',
	locale_fix: 'dk',
	currency: 'DKK',
	customers_url: '/kunder/soeg',
	transactions: [],
	
	convertNumber: function(number, from, to) {
		// FIXME: do proper formatting
		
		if (to == 'en') {
			return number.replace(',', '.');
		}

		if (to == 'da') {
			return number.replace('.', ',');
		}
	},
	
	/**
	 * @param amount Amount as a String in English format, or as a Number
	 */
	formatNumberWithCurrency: function(amount) {
    var delimiter = ".";
    var commaDelimiter = ",";
    
    if (typeof(amount) == "number") {
      amount = amount.toString();
    }
	  
    x = amount.split('.', 2);
    t = x[0];
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(t)) {
      t = t.replace(rgx, '$1' + delimiter + '$2');
    }
    return hurtigmoms.currency + ' ' + t + ((x.length > 1) ? commaDelimiter + x[1] : '');
  },
	
	posting: {
		vat: function(amount) {
			try {
				amount = parseFloat(hurtigmoms.convertNumber(amount, hurtigmoms.locale, 'en')) * 0.2;
				if (isNaN(amount)) {
					amount = 0.0;
				}
			}
			catch (ex) {
				amount = 0.0;
			}

			return hurtigmoms.formatNumberWithCurrency(amount.toFixed(2));
		}
	}
}

;(function($) {
  
  /**
* Poll _callback_ with an interval of _ms_. When
* the retry function is called _callback_ will continue
* to be invoked while increasing the interval by 50%.
*
* The _ms_ argument defaults to 1000 and allows a function in
* its place like the example below.
*
* $.poll(function(retry){
* $.get('something', function(response, status){
* if (status == 'success')
* // Do something
* else
* retry()
* })
* })
*
* @param {int} ms
* @param {function} callback
* @api public
*/
  
  $.poll = function(ms, callback) {
    if ($.isFunction(ms)) {
      callback = ms
      ms = 1000
    }
    (function retry() {
      setTimeout(function() {
        callback(retry)
      }, ms)
      ms *= 1.5
    })()
  }
  
})(jQuery);

jQuery.fn.focusFirstFormElement = function() {
	$(this).find(":input:enabled:first").focus();
	return this;
};

$(function() {
	$(".editable-table .row").hover(function() { $(this).addClass("hover"); }, function() { $(this).removeClass("hover"); });
	$(".editable-table .row.hover").live("click", function() {
		$(this).find(".edit").trigger("click");
		return false;
	});
	
	$(".amount-no-vat").live("keyup", function() {
		$(this).closest("form").find(".amount-vat").text(hurtigmoms.posting.vat(this.value));
	});
	
	// bind all generic events
	$(".close").live("click", function() {
		$(this).closest("tr").remove();
		return false;
	});
	$(".show").live("click", function() { $.get(this.href, null, null, "script"); return false; });
	
	$(".edit").live("click", function() {
		$(this).closest("tr").toggleClass('row-loading');//.find("td").replaceWith("<td></td>");
		$.get(this.href, null, null, "script");
		return false;
	});
	
	$(".delete").live("click", function() {
	  if (confirm('Er du sikker på du ønsker at slette denne?')) {
	    $.ajax({ type: "DELETE", url: this.href, data: null, dataType: "script" });
    }
	  return false;
  });
});
