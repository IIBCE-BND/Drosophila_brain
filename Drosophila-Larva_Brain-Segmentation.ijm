macro "Drosophila Larva Brain Segmentation" {

	// Available autothreshold methods
	methods = newArray("Default", "Huang", "Intermodes", "IsoData", "Li", "MaxEntropy", "Mean", "MinError(I)", "Minimum","Moments","Otsu","Percentile","RenyiEntropy","Shanbhag","Triangle","Yen");

	// Default size for the rolling ball
	rbs = 40;

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
	Dialog.addNumber("Background Subtraction (Rolling Ball Size):", rbs);
	Dialog.addChoice("Auto Threshold Method", methods, methods[0]);
	Dialog.show();
	selection = Dialog.getChoice();
	rbs = Dialog.getNumber();
	method = Dialog.getChoice();

	// apply the user selection and duplicate the image for mask creation
	selectImage(selection);
	run("Duplicate...", "duplicate title=mask");

	// background subtraction
	run("Subtract Background...", "rolling=" + rbs + " stack"); 
	// smoothening
	run("Smooth", "stack"); 
	// autothreshold segmentation
	run("Auto Threshold", "method=" + method + " stack white"); 
	// makes a binary stack or image
	run("Make Binary", "stack");  
	// watershed object separation
	run("Watershed", "stack");

	// run the plugin for ratiometric analysis
	run("Blob Ratiometrics (2D)");
	
}

/* 
Notes:
A window opens and the user should choose the GFP channel in the first line, and the RFP channel in the second line. 
For the mask use the result picture from the macro (it has the same name as the RFP channel stack but it appears always first on the list). 
We usually don't use background substraction and use a particle minimum size of 3.
*/
