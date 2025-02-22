#include <iostream>
#include "CodeGeneration.h"
#include "SyntaxTreeNodes.h"

using namespace std;

extern int yyparse();
extern FILE* yyin;
extern NBlock* programBlock;
extern int error_count;

void createCoreFunctions(CodeGenContext& context);

int main(int argc, char **argv)
{
	if(argc>1)
        {
        yyin = fopen(argv[1],"r");
        if(yyin == 0)
            yyin = stdin;
        }
    else
        {yyin = stdin;}

    cout << "Parsing Started" << endl;
	int flag = yyparse();
    cout << "Parsing Ended" << endl;
    cout << "\nCheckpoint 01\n" << endl;
	
	if(error_count == 0){
	cout << programBlock << endl;
	InitializeNativeTarget();
	InitializeNativeTargetAsmPrinter();
	InitializeNativeTargetAsmParser();
	CodeGenContext context;
	createCoreFunctions(context);
    cout << "\nCheckpoint 02\n" << endl;
	context.generateCode(*programBlock);
    cout << "\nCheckpoint 03\n" << endl;
	context.runCode();
	cout << "Checkpoint 04\n" << endl;
	cout << "Successful!!\n" << endl;
	}
    
	fclose(yyin);
	return flag;
}

