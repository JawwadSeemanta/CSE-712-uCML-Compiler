#include <iostream>
#include "codegen.h"
#include "node.h"

using namespace std;

extern int yyparse();
extern NBlock* programBlock;

void createCoreFunctions(CodeGenContext& context);

int main(int argc, char **argv)
{
    cout << "Parsing Started" << endl;
	yyparse();
    cout << "Parsing Ended" << endl;
	
    cout << programBlock << endl;
    
    cout << "Checkpoint 01" << endl;
	InitializeNativeTarget();
    cout << "Checkpoint 02" << endl;
	InitializeNativeTargetAsmPrinter();
    cout << "Checkpoint 03" << endl;
	InitializeNativeTargetAsmParser();
    cout << "Checkpoint 04" << endl;
	CodeGenContext context;
    cout << "Checkpoint 05" << endl;
	createCoreFunctions(context);
    cout << "Checkpoint 06" << endl;
	context.generateCode(*programBlock);
    cout << "Checkpoint 07" << endl;
	context.runCode();
	
	return 0;
}

