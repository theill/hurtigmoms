// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
	
	$("#new_posting").ajaxForm({
		dataType: "script"
	});

/*	$("#tasks .task .name a.edit").live("click", function() {
		$.get($(this).attr('href'), null, null, "script");
		return false;
	});
*/	
	$(".edit").live("click", function() { $.get(this.href, null, null, "script"); return false; });
	$(".delete").live("click", function() {
		jQuery.ajax({
			type: "DELETE",
			url: this.href,
			data: null,
			dataType: "script"
		});
		return false;
	});
	
/*	$('#new_posting').submit(function() {
		$(this).ajaxSubmit({
			target: '#bookmarks-list',
			clearForm: true,
			success: alert('godt'),
			error: alert('skidt')
		});
		return false;
	})
*/

})