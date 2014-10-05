import std.stdio;
import std.getopt;
import std.file;
import std.string;
import std.conv;
 
 struct options{
 		// Should perform the byte operation
 		bool bOperation = false;
	   int cutByteStart = 0;
	   int cutByteStop = 0; 
	   
	   // Should perform the field operation
	   bool fOperation = false;
	   int cutFieldStart = 0;
	   int cutFieldStop = 0;
	   char delimiter = '\t';
	   
	   // Should perform the delimiter-based field operation
	   bool dOperation = false;
	   
	   // Should apply inversion
	   bool cOperation = false;
	   
	   // The path of the file to be processed
	   string filename;
	   
	   // Argument parsing was succeful
	   bool parsedSucceful = true;
}
   
void main(string[] args)

{
	// Extract the options of the current execution
	options currentOptions = processArguments(args);
	
	// In case of unsucceful parsing, do not process with any processing.
	if(!currentOptions.parsedSucceful){
		return; 
			}
	
	// Perform the byte operation
	if(currentOptions.bOperation){
		performByteOperation(currentOptions);
		}
	
	// Perform the field operation
	else if(currentOptions.fOperation){
		performFieldOperation(currentOptions);
		}
	}

// Prints an error message when parsing of the arguments goes wrong.
private void printError(string errormsg){
	writefln("Error while executing dcut command. %s.",errormsg);
	writefln("Execution examples");
	writefln("dcut -b1 FILENAME");
	writefln("dcut -b2-3 FILENAME");
	writefln("dcut -b2-3 --complement FILENAME");
	writefln("dcut -f2-3 FILENAME");
	writefln("dcut -f2-5 -d\":\" FILENAME");
	writefln("dcut -f2-5 -d\":\" --complement FILENAME");
	}


// Does the processing of the command line arguments and fill in a struct containing all the extracted options.
private options processArguments(string[] args){
	
	options currentOptions;
	
	// The last argument should always be the filename
   currentOptions.filename = args[args.length - 1];
	try{
		File(currentOptions.filename);
	} catch(Exception ex){
		printError("No such file name");
		currentOptions.parsedSucceful = false;
		return currentOptions;
   				
		}
	
	// Process each different arguments
	foreach(string arg; args)
	{
   	
   	// Check for "-b", the byte operation identifier.
   	int bIndex = arg.indexOf("-b");
   	if(bIndex == 0)
   	{
   		currentOptions.bOperation = true;
   		
   		// Remove "-b" from the argument
   		string bArg = arg["-b".length .. arg.length];
   		
   		// No dash is contained. This is about a single byte, not a range of bytes.
   		if(bArg.indexOf("-")==-1){
   			// Starting and ending point is the same
   			try{ 
   			currentOptions.cutByteStart = to!int(bArg);
   			currentOptions.cutByteStop = currentOptions.cutByteStart;
   			} catch (Exception ex){
   				printError("Could not parse byte selection");
   				currentOptions.parsedSucceful = false;
   				return currentOptions;
   				}
   			
   			}
   		// This is about a range of bytes.
   		else{
   			
   			// Extract the integers left and right of the dash
   			try{ 
   			currentOptions.cutByteStart = to!int(bArg.split("-")[0]);
   			currentOptions.cutByteStop = to!int(bArg.split("-")[1]);
   			}catch(Exception ex){
   				printError("Could not parse byte range");
   				currentOptions.parsedSucceful = false;
   				return currentOptions;
   				}
   		}
   		}
   	
   	// Check for "-f", the field operation identifier 
   	int fIndex = arg.indexOf("-f");
   	if(fIndex == 0 ){
   		
   		currentOptions.fOperation = true;
   		string fArg = arg["-f".length .. arg.length];
   		
   		// No dash is contained. This is about a single field.
   		if(fArg.indexOf("-")==-1){
   			try{ 
   			currentOptions.cutFieldStart = to!int(fArg);
   			currentOptions.cutFieldStop = currentOptions.cutFieldStart;
   			} catch (Exception ex){
   			printError("Could not parse field selection");
   				currentOptions.parsedSucceful = false;
   				return currentOptions;	
   				}
   			}
   		else{
   			try { 
   			currentOptions.cutFieldStart = to!int(fArg.split("-")[0]);
   			currentOptions.cutFieldStop = to!int(fArg.split("-")[1]);
   			} catch (Exception ex){
   				printError("Could not parse field range");
   				currentOptions.parsedSucceful = false;
   				return currentOptions;
   				} 
   		}
   		
   		}
   	
   	// Check for "-d". A delimiter other than tab is defined.
   	int dIndex = arg.indexOf("-d");
   	if(dIndex == 0){
   		
   		try{
   		currentOptions.delimiter = to!char(arg["-d".length .. arg.length]);   		
   		} catch(Exception ex){
   			printError("Could not find a single character delimiter");
   				currentOptions.parsedSucceful = false;
   				return currentOptions;
   			}	
   		}
   	
   	// Check for "--complement".
   	int cIndex = arg.indexOf("--complement");
   	
   	if(cIndex == 0){
   		currentOptions.cOperation = true;
   		}

   		
   		// Error cases
   		
	   	// Starting byte greater than finishing field
	   	if(currentOptions.cutByteStart>currentOptions.cutByteStop){
	   		printError("Invalid range");
	   		currentOptions.parsedSucceful = false;
	   		return currentOptions;
	   		}
	   	
	   	// Starting field greater than finishing field
	   	if(currentOptions.cutFieldStart>currentOptions.cutFieldStop){
	   		printError("Invalid range");
	   		currentOptions.parsedSucceful = false;
	   		return currentOptions;
	   		}
	   	
	   	
	   	// Byte and field operations
	   	if(currentOptions.bOperation && currentOptions.fOperation){
	   		printError("Could not apply to different operations");
	   		currentOptions.parsedSucceful = false;
	   		return currentOptions;
	   		}
	   	
	   	// Byte and special delimiter operations
	   if(currentOptions.bOperation && currentOptions.delimiter!='\t'){
	   		printError("Could not apply delimiter to byte operation");
	   		currentOptions.parsedSucceful = false;
	   		return currentOptions;
	   		}		
   	
   	}
	return currentOptions;
	}

private void performByteOperation(options currentOptions){
	
		int lineByteStart = currentOptions.cutByteStart;
		int lineByteStop = currentOptions.cutByteStop;
foreach(line; File(currentOptions.filename).byLine())
		{	
		if(lineByteStop > line.length){
			lineByteStop = line.length;
			}
		if(lineByteStart >line.length){
			lineByteStart = line.length;
			}
		
		
		if(!currentOptions.cOperation){
			writeln(line[lineByteStart-1 ..  lineByteStop]);
			}
		 else{
		 	
			write(line[0 .. lineByteStart-1]);
			write(line[lineByteStop .. $]);
			write("\n");
			}
		 }
	}

private void performFieldOperation(options currentOptions){
	foreach(line; File(currentOptions.filename).byLine())
			{
	if(!currentOptions.cOperation){
			int fieldsRange = currentOptions.cutFieldStop - currentOptions.cutFieldStart; 
			for(int fieldInd = currentOptions.cutFieldStart-1; fieldInd<currentOptions.cutFieldStop;fieldInd++){
				writef(line.split(currentOptions.delimiter)[fieldInd]);
				writef("\t");		
				}
			writefln("");			
		}
			
		if(currentOptions.cOperation){
			for (int fieldInd = 0; fieldInd<currentOptions.cutFieldStart-1;fieldInd++){
				writef(line.split(currentOptions.delimiter)[fieldInd]);
				writef("\t");
				}
			
			//total number of fields
			int maxFields = line.split(currentOptions.delimiter).length;
			
			for (int fieldInd = currentOptions.cutFieldStop; fieldInd<maxFields;fieldInd++){
				writef(line.split(currentOptions.delimiter)[fieldInd]);
				writef("\t");
				}
			writefln("");	
			}
		}
			}















