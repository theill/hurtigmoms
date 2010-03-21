/**
 * =hurtigmoms
 * 
 * TODO: VAT amount is relative to selected account.
 * 
 */

var hurtigmoms = {
	locale: 'da',
	locale_fix: 'dk',
	currency: 'DKK',
	search_customers_url: '/kunder/find',
	search_transactions_url: '/transaktioner/find',
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

/*	posting: {
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
*/	
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

/*
 jQuery delayed observer - 0.8
 http://code.google.com/p/jquery-utils/

 (c) Maxime Haineault <haineault@gmail.com>
 http://haineault.com
 
 MIT License (http://www.opensource.org/licenses/mit-license.php)
 
*/

$.fn.delayedObserver = function(callback, delay, options){
	return this.each(function() {
		var el = $(this);
		var op = options || {};
		el.data('oldval', el.val())
			.data('delay', delay || 0.5)
			.data('condition', op.condition || function() { return ($(this).data('oldval') == $(this).val()); })
			.data('callback', callback)
		[(op.event||'keyup')](function(){
			if (el.data('condition').apply(el)) {
				return;
			}
			else {
				if (el.data('timer')) {
					clearTimeout(el.data('timer'));
				}
				el.data('timer', setTimeout(function() {
					el.data('callback').apply(el);
				}, el.data('delay') * 1000));
				el.data('oldval', el.val());
			}
		});
	});
};

jQuery.fn.focusFirstFormElement = function() {
	$(this).find(":input:enabled:first").focus();
	return this;
};

$.fn.toggleable = function() {
	var p = $(this);
	p.find(".pane a.toggle").live("click", function() {
		p.find(".pane").toggle();
		return false;
	});
	return this;
};

$(document).ready(function() {
	$(".editable-table .row").hover(function() { $(this).addClass("hover"); }, function() { $(this).removeClass("hover"); });
	$(".editable-table .row.hover").live("click", function() {
		$(this).find(".edit").trigger("click");
		return false;
	});
	
	$("#h .account > a").bind("click", function() {
		var li = $(this).parent();
		li.addClass("selected").find("ul").toggle();
		return false;
	});
	
	// bind all generic events
	$(".close").live("click", function() {
		$(this).closest("tr").remove();
		return false;
	});
	
	$(".show").live("click", function() {
		$.get(this.href, null, null, "script");
		return false;
	});
	
	$(".edit").live("click", function() {
		$(this).closest("tr").toggleClass('row-loading');//.find("td").replaceWith("<td></td>");
		$.get(this.href, null, null, "script");
		return false;
	});
	
	$(".delete").live("click", function() {
		$(this).parent().hide();
		$(this).parent().parent().find(".delete-confirmation").html('Er du sikker? <a class="delete-confirmed delete-yes" href="' + this.href + '">Ja</a><a class="delete-cancelled delete-no" href="#">Nej</a>').effect('highlight', 'slow');
		return false;
  });

	$(".delete-confirmed").live("click", function() {
		$.ajax({ type: "DELETE", url: this.href, data: null, dataType: "script" });
		return false;
	});
	
	$(".delete-cancelled").live("click", function() {
		$(this).parent().hide();
		$(this).parent().parent().find(".delete-question").show();
		return false;
	});
	
});