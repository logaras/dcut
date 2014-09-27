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
   	
   	if(cutByteStart>cutByteStop){
   		writefln("Error!");
   		return;
   		}	
   	
   	}
   writefln("b: %s %s %s",bOperation,cutByteStart,cutByteStop);
   

   
   writefln("********** %s ********** \n",filename);
	
	foreach( line; File(filename).byLine())
	{
		int lineByteStart = cutByteStart;
		int lineByteStop = cutByteStop;

		if(lineByteStop > line.length){
			lineByteStop = line.length;
			}
		if(lineByteStart >line.length){
			lineByteStart = line.length;
			}
		
		writeln(line[lineByteStart ..  lineByteStop]);
	}
	writeln("stop");

}