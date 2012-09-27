$(document).ready(function() {

	// Open external links in a new window
	hostname = window.location.hostname
	$("a[href^=http]")
	  .not("a[href*='" + hostname + "']")
	  .addClass('link external')
	  .attr('target', '_blank');
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

$("input[name=showTable]").click(function () {
$("#checklist").show("slow");
});

$("input[name=hideTable]").click(function () {
$("#checklist").hide("slow");
});

$(document).ready(function() {

	$("#submit").click(function(){
		$("#form1").submit();
		$("#form2").submit();
		$("#form3").submit();
		$("#form4").submit();
		$("#form5").submit();
		$("#form6").submit();
		$("#form7").submit();
		$("#form8").submit();
		$("#form9").submit();
	});
});