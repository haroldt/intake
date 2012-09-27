$(document).ready(function() {

	// Open external links in a new window
	hostname = window.location.hostname
	$("a[href^=http]")
	  .not("a[href*='" + hostname + "']")
	  .addClass('link external')
	  .attr('target', '_blank');
});

$('#sendall').click(function() {
    $('form').each(function() {
        $.post(this.action, $form.serialize());
    });
});