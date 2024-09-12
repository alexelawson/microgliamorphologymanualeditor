/*
 * Function for the manual comparison between a green/blue image and a binary image, to make side-by-side tracking more straight forward
 * Prompts the user to open two images
 * Creates an ROI around each cell of interest based upon the binary image 
 * Then goes through and zooms into the ROI's one by one, asking for user input
 */
 
//MAIN PROGRAM
//use file browser to open green/blue image
		Dialog.create("ImageOpener");
		Dialog.addMessage("Open your original test image (blue/green)");
		Dialog.show();
		originalImage = File.openDialog("Open your original test image");
		open(originalImage);
		originalImageID = getImageID();
		binaryDataArray = openBinary();
		number = binaryDataArray[0];
		binaryImageID = binaryDataArray[1];
		binaryImage = binaryDataArray[2];
		selectedArray = newArray(number);
	    //selects each ROI in the binary image, iterating through 
		for(i=0; i < number; i++) {
			roiManager("select", i);
			zoom(binaryImageID, originalImageID, i);
			Dialog.createNonBlocking("Manual Editor");
			Dialog.addMessage("Make manual edits desired. Press enter to move onto next ROI");
			Dialog.addMessage("Current ROI: " + i+1);
			Dialog.addString("Enter a specific roi if desired:", "ROI");
			Dialog.addCheckbox("Mark Microglia", false);
			Dialog.show();
			numberString = Dialog.getString();
			markedOrNot = Dialog.getCheckbox();
			if (markedOrNot == true) {
				Dialog.createNonBlocking("Comments about marking");
				Dialog.addMessage("Please enter any comments about the marking, if left blank the program will default to saving only the index/name of the ROI");
				Dialog.addString("Comment: ", "Blank");
				Dialog.show();
				commentROI = Dialog.getString();
				if (commentROI == "Blank"){
					selectedArray[i] = i+1;
				}
				else{
					selectedArray[i] = toString(i+1) + " - " + commentROI;
				}
				Array.print(selectedArray);
			//	Array.print(selectedArray);
			}
			if (numberString != "ROI"){
				i = parseFloat(numberString)-2; }
		}
		arrayString = "Index:    Comment:   \n";
		for (i=0; i < number; i++) {
			if (selectedArray[i]!=0){
				arrayString = arrayString + selectedArray[i] + "\n";
			}
		}
		Dialog.createNonBlocking("End of Program");
		Dialog.addMessage("You've hit the end of the program. Save the final edited binary image.");
		Dialog.addMessage("The following microglia ROI's were marked:");
		Dialog.addMessage(arrayString);
		Dialog.show();
		
/*HELPER FUNCTIONS
 * openBinary() 
 * zoom(imageNameBinary, imageNameGB, imageIDBinary, imageIDGB, index)
 */

function openBinary(){
/* Function that opens a user input binary image 
 * Returns an array of data from the binary image for use: 
 * [the number of ROI's in the array, the unique ID of the binary Image, the binaryImage]
 */
	//use file browser to open binary image
		Dialog.create("BinaryOpener");
		Dialog.addMessage("Open your binary image");
		Dialog.show();
		binaryImage = File.openDialog("Open your binary test image");
		open(binaryImage);
		binaryImageID = getImageID();
		Dialog.create("ROI Manager");
		Dialog.addCheckbox("Do you have pre-saved ROI's?", false);
		Dialog.show();
		decision = Dialog.getCheckbox();
		if (decision == true) {
			Dialog.create("ROI opener");
			File.openDialog("Open your binary test image");
			Dialog.show();
			number = roiManager("count");		
			run("Synchronize Windows"); //opens synchronize windows for ease of analysis
		}else {
//create an ROI around each defined area in the binary image (i.e. white sections)
			selectImage(binaryImageID);
			run("Analyze Particles...", "size=600-Infinity show=Nothing pixel include add include");
			number = roiManager("count");		
		    run("Synchronize Windows"); //opens synchronize windows for ease of analysis
	}
	resultArray = newArray(3);
	resultArray[0] = number;
	resultArray[1] = binaryImageID;
	resultArray[2] = binaryImage;
	return resultArray;
}

/*ImageJ macro to zoom to the selected ROI, takes 4 arguments
 * imageIDBinary: the unique id of the binary image
 * imageIDGB: the unique id of the original image
 * index: the index of the ROI that you want to zoom to 
 */
function zoom(imageIDBinary, imageIDGB, index) {
// Check if there's an ROI selected
	if (roiManager("count") == 0) {
		showMessage("No ROI selected", "Please select an ROI before running this script.");
  	  	exit();
	}
// Get the selected ROI
	selectImage(imageIDBinary);
	roiManager("Select", index); // Select the first ROI (index 0)
	run("To Selection");
	selectImage(imageIDGB);
	roiManager("Select", index);
	run("To Selection");
}










	/*Get the bounds of the selected ROI
	roiManager("measure");
	x = getResult("X", index);
	y = getResult("Y", index);
	width = getResult("XM", index);
	height = getResult("XM", index);
	centerX = x + (width/2);
	centerY = y + (height/2);
	zoomFactor = getZoom();
	print("X-coord: " + x + "Y-coord:" + y + "Width: " + width + "Height: " + height);
	//Zooming to the binary image selection

//selectImage(imageIDGB);
//run("Set...", "zoom=zoomFactor Y=x Y=y");
// Dialog.create("zooming");
//		Dialog.addMessage("checking to see if we've zoomed on the binary");
//		Dialog.show();
*/
		/*
//use file browser to open binary image
		Dialog.create("BinaryOpener");
		Dialog.addMessage("Open your binary image");
		Dialog.show();
		binaryImage = File.openDialog("Open your binary test image");
		open(binaryImage);
		binaryImageID = getImageID();
		Dialog.create("ROI Manager");
		Dialog.addCheckbox("Does your test image have ROIs traced?", false);
		Dialog.show();
		decision = Dialog.getCheckbox();
		if (decision == true) {
			print("Worked as true");
			number = roiManager("count");		
			run("Synchronize Windows"); //opens synchronize windows for ease of analysis
		}else {
//create an ROI around each defined area in the binary image (i.e. white sections)
			print("worked as false");
			selectImage(binaryImageID);
			run("Analyze Particles...", "size=600-Infinity show=Nothing pixel include add include");
			number = roiManager("count");		
		    run("Synchronize Windows"); //opens synchronize windows for ease of analysis
	}
	
	*/
		/*	selectImage(binaryImageID);
		Dialog.create("Save Image");
		Dialog.addMessage("Choose a location to save the edited binary.");
		Dialog.show();
		pathToSave = File.openDialog("Location to save the edited binary");
		saveAs("tiff",pathToSave + binaryImage + "_edited");*/
