/*
 * Function for the manual comparison between a green/blue image and a binary image, to make side-by-side tracking more straight forward
 * Prompts the user to open two images
 * Creates an ROI around each cell of interest based upon the binary image 
 * Then goes through and zooms into the ROI's one by one, asking for user input
 */

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
			zoom(binaryImage, originalImage, binaryImageID, originalImageID, i);
			Dialog.createNonBlocking("Manual Editor");
			Dialog.addMessage("Make manual edits desired. Press enter to move onto next ROI");
			Dialog.addMessage("Current ROI: " + i+1);
			Dialog.addString("Enter a specific roi if desired:", "ROI");
			Dialog.addCheckbox("Mark Microglia", false);
			Dialog.show();
			numberString = Dialog.getString();
			markedOrNot = Dialog.getCheckbox();
			if (markedOrNot == true) {
				selectedArray[i] = i+1;
			//	Array.print(selectedArray);
			}
			if (numberString != "ROI"){
				i = parseFloat(numberString)-2; }
		}
		arrayString = " ";
		for (i=0; i < number; i++) {
			if (selectedArray[i]!=0){
				arrayString = arrayString + selectedArray[i] + ", ";
			}
		}
		Dialog.createNonBlocking("End of Program");
		Dialog.addMessage("You've hit the end of the program. Save the final edited binary image.");
		Dialog.addMessage("The following microglia ROI's were marked:");
		Dialog.addMessage(arrayString);
		Dialog.show();
		
/*
 * Function that opens a user input binary image 
 * Returns an array of data [the number of ROI's in the array, the unique ID of the binary Image, the binaryImage]
 */
function openBinary(){
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

// ImageJ macro to zoom to the selected ROI
function zoom(imageNameBinary, imageNameGB, imageIDBinary, imageIDGB, index) {
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
