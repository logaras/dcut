import std.stdio;
import std.getopt;
import std.file;
import std.string;
import std.conv;
 
void main(string[] args)

{
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
   
   string filename;
   
   filename = args[args.length - 1];
   
   // For each argument in the command line 
   foreach(string arg; args)
   {
   	
   	// Check for "b"
   	int bIndex = arg.indexOf("-b");
   	if(bIndex == 0)
   	{
   		bOperation = true;
   		string bArg = arg["-b".length .. arg.length];
   		
   		// This is a single byte, not from-to
   		if(bArg.indexOf("-")==-1){
   			cutByteStart = to!int(bArg);
   			cutByteStop = cutByteStart;
   			
   			}
   		else{
   			cutByteStart = to!int(bArg.split("-")[0]);
   			cutByteStop = to!int(bArg.split("-")[1]);
   		}
   		}
   	
   	int fIndex = arg.indexOf("-f");
   	if(fIndex == 0 ){
   		
   		fOperation = true;
   		string fArg = arg["-b".length .. arg.length];
   		
   		// This is a single byte, not from-to
   		if(fArg.indexOf("-")==-1){
   			cutFieldStart = to!int(fArg);
   			cutFieldStop = cutFieldStart;
   			
   			}
   		else{
   			cutFieldStart = to!int(fArg.split("-")[0]);
   			cutFieldStop = to!int(fArg.split("-")[1]);
   		}
   		
   		}
   	
   	
   	if(cutByteStart>cutByteStop){
   		writefln("Error!");
   		return;
   		}
   	
   	if(cutFieldStart>cutFieldStop){
   		writefln("Error!");
   		return;
   		}		
   	
   	}
   writefln("b: %s %s %s",bOperation,cutByteStart,cutByteStop);
   writefln("f: %s %s %s",fOperation,cutFieldStart,cutFieldStop);

	
	foreach( line; File(filename).byLine())
	{
		if(bOperation){
		int lineByteStart = cutByteStart;
		int lineByteStop = cutByteStop;

		if(lineByteStop > line.length){
			writefln("1");
			lineByteStop = line.length;
			}
		if(lineByteStart >line.length){
			writefln("2");
			lineByteStart = line.length;
			}
		
		writeln(line[lineByteStart-1 ..  lineByteStop]);
		}
		
		
		if(fOperation){
			int fieldsRange = cutFieldStop - cutFieldStop; 
			for(int fieldInd = cutFieldStart-1; fieldInd<cutFieldStop;fieldInd++){
				writef(line.split(delimiter)[fieldInd]);
				writef("\t");		
				}
			 
			}
		writefln("");
	}
	

}