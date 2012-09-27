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

// When the document is ready, initialize the link so
// that when it is clicked, the printable area of the
// page will print.
$(document).ready(function(){
 
// Hook up the print link.
$( ".print" )
.attr( "href", "javascript:void( 0 )" )
.click(
function(){
// Print the DIV.
$( ".printable" ).print();
 
// Cancel click event.
return( false );
}
)
;
 
}
);