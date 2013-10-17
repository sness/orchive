function visualizationChange() {
 	var flash = window.movie || document.movie; // Get Flash object
	var val = flash.visualizationChange(document.visualizationForm.visualization.value); // Invoke a function on it
	return;
}

function predictionChange() {
 	var flash = window.movie || document.movie; // Get Flash object
 	var val = flash.predictionChange(document.predictionForm.prediction.value); // Invoke a function on it
	return;
}

function userAnnotationChange() {
 	var flash = window.movie || document.movie; // Get Flash object
 	var val = flash.userAnnotationChange(document.userAnnotationForm.userAnnotation.value); // Invoke a function on it
	return;
}

function enterAnnotation() {
 	var flash = window.movie || document.movie; // Get Flash object
 	var val = flash.enterAnnotation("test"); // Invoke a function on it
	return;
}
