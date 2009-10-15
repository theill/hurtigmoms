/**
 * =hurtigmoms
 * 
 * TODO: VAT amount is relative to selected account.
 * 
 */

hurtigmoms = {
	locale: 'da',
	currency: 'DKK',
	customers_url: '/kunder/search',
	
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
	 * @param amount Number in English format
	 */
	formatNumberWithCurrency: function(amount) {
    var delimiter = "."; // replace dot if desired
    var commaDelimiter = ",";
    
    var a = amount.split('.', 2)
    var d = a[1];
    var i = parseInt(a[0]);
    if(isNaN(i)) { return ''; }
    var minus = '';
    if(i < 0) { minus = '-'; }
    i = Math.abs(i);
    var n = new String(i);
    var a = [];
    while(n.length > 3) {
      var nn = n.substr(n.length-3);
      a.unshift(nn);
      n = n.substr(0,n.length-3);
    }
    if(n.length > 0) { a.unshift(n); }
    n = a.join(delimiter);
    if(d.length < 1) { amount = n; }
    else { amount = n + commaDelimiter + d; }
    amount = minus + amount;
    return hurtigmoms.currency + ' ' + amount;
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

jQuery.fn.focusFirstFormElement = function() {
	$(this).find("input[type=text]:first").focus();
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
