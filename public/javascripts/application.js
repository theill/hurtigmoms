// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {

	function processJson(data) { 
	    // 'data' is the json object returned from the server 
	    alert(data.message); 
	}

	$('#new_posting').ajaxForm({
		dataType: 'json',
		success: processJson
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