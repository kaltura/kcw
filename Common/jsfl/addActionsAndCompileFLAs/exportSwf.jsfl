mainRun ();
function mainRun ()
{
	// first, ask for the actionscript file.
	var schemaURI = fl.browseForFileURL("open", "Please select your actionscript file", false);
	if (schemaURI == null) {
		return;
	}
	// pre-parse the as file, so that we can opt out if the as is broken.
	if (schemaURI.substr(schemaURI.length-3) != ".as") { alert(">> ERROR: Selected schema is not a .as file."); return; }
	var schemaStr = FLfile.read(schemaURI);
	if (schemaStr == null) { alert(">> ERROR: Could not read the actions file."); return; }

	var folder = fl.browseForFolderURL('Select folder containing files to batch export as *.SWF');
	if (!null) 
	{
		var list = FLfile.listFolder(folder+'/*.fla', 'files');
		//Create folder to hold exported SWFs
		FLfile.createFolder(folder+'/Exported SWFS');
		var flaName;
		var swfName;
		// Clear the output panel
		fl.outputPanel.clear();
		fl.outputPanel.trace('Batch Export SWF.jsfl LOG');
		fl.outputPanel.trace('-------------------------');
		fl.outputPanel.trace('Exporting all *.fla files in "'+folder+'" as *.swf\'s to "'+folder+'/Exported SWFS/"\n');
		for (var i = 0; i < list.length; ++i) 
		{
			flaName = list[i];
			swfName = list[i].split('.')[0]+'.swf';
			fl.outputPanel.trace(flaName+' exported as '+swfName);
			// open the document, publish to SWF, and close.
			fl.openDocument(folder+'/'+flaName);
			// write the actionscript
			var lastAS = fl.getDocumentDOM().getTimeline().layers[0].frames[0].actionScript;
			fl.getDocumentDOM().getTimeline().layers[0].frames[0].actionScript = schemaStr + '\n' + lastAS;
			fl.getDocumentDOM().exportSWF(folder+'/Exported SWFS/'+swfName, true);
			fl.getDocumentDOM().save();
			fl.closeDocument(fl.getDocumentDOM(), false);
		}
		// Save log
		fl.outputPanel.save(folder+'/Exported SWFS/log.txt', false);
	}
}