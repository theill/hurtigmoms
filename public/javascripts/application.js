/**
 * =hurtigmoms
 * 
 * TODO: VAT amount is relative to selected account.
 * 
 */

hurtigmoms = {
	locale: 'da',
	
	convertNumber: function(number, from, to) {
		// FIXME: do proper formatting
		
		if (to == 'en') {
			return number.replace(',', '.');
		}

		if (to == 'da') {
			return number.replace('.', ',');
		}
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

			return hurtigmoms.convertNumber(amount.toFixed(2), 'en', hurtigmoms.locale);
		}
	}
}

jQuery.fn.focusFirstFormElement = function() {
	$(this).find("input[type=text]:first").focus();
	return this;
};

$(function() {
	// postings
	$("#postings .posting").hover(function() { $(this).addClass("hover"); }, function() { $(this).removeClass("hover"); });
	
	$(".amount-no-vat").live("keyup", function() {
    $(this).closest("form").find(".amount-vat").text(hurtigmoms.posting.vat(this.value));
  });
	
	// bind all generic events
	$(".close").live("click", function() { $.fn.colorbox.close(); return false; });
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
