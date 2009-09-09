// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
	
	$('#new_posting').ajaxForm({
		dataType: 'script'
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