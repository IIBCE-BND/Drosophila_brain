macro "Drosophila Larva Brain Segmentation" {

	// opens directory to choose a stack or image
	open();

	// split into single the channels
	run("Split Channels");

	// iterate over the images and get their titles
	images = newArray(nImages)
	n = 0;
	for (i = 1; i <= nImages; i++) {
		selectImage(i);
		images[n++] = getTitle();
	}

	// create a dialod for the user to select the channel for segmentation
	Dialog.create("Plant Stem Analysis");
	Dialog.addChoice("Input image:", images, images[0]);
	Dialog.show();
	selection = Dialog.getChoice();

	// apply the user selection and duplicate the image for mask creation
	selectImage(selection);
	run("Duplicate...", "duplicate title=mask");

	// background subtraction
	run("Subtract Background...", "rolling=40 stack"); 
	// smoothening
	run("Smooth", "stack"); 
	// autothreshold segmentation
	run("Auto Threshold", "method=Default stack"); 
	// makes a binary stack or image
	run("Make Binary", "stack");  
	// watershed object separation
	run("Watershed", "stack");

	// run the plugin for ratiometric analysis
	run("Blob Ratiometrics (2D)");
	
}
