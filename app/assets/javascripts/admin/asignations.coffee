$(document).on "ajax:success", "form#asignations-form",(ev,data) ->
	console.log data
	$(this).find("textarea").val(""); ##esta linea es para limpiar el text
	$("#asignations-box").append("<li>#{data.state}-#{data.user_id}</li>");

$(document).on "ajax:error", "form#asignations-form",(ev,data) ->
	console.log data