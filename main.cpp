#include <iostream>
#include "codegen.h"
#include "node.h"

using namespace std;

extern int yyparse();
extern FILE* yyin;
extern NBlock* programBlock;

void createCoreFunctions(CodeGenContext& context);

int main(int argc, char **argv)
{
	yyin = fopen(argv[1],"r");
    cout << "Parsing Started" << endl;
	yyparse();
    cout << "Parsing Ended" << endl;
	
    cout << programBlock << endl;
    
    cout << "\nCheckpoint 01" << endl;
	InitializeNativeTarget();
    cout << "\nCheckpoint 02" << endl;
	InitializeNativeTargetAsmPrinter();
    cout << "\nCheckpoint 03" << endl;
	InitializeNativeTargetAsmParser();
    cout << "\nCheckpoint 04" << endl;
	CodeGenContext context;
    cout << "\nCheckpoint 05" << endl;
	createCoreFunctions(context);
    cout << "\nCheckpoint 06" << endl;
	context.generateCode(*programBlock);
    cout << "\nCheckpoint 07" << endl;
	context.runCode();
	
	fclose(yyin);
	
	return 0;
}

