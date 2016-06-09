$(document).ready(function(){

	$('.i').click(function(){
		$('#body2').show();
		$('#body1').hide();
	});
	$('.p').click(function(){
		$('#body1').show();
		$('#body2').hide();
	});

});