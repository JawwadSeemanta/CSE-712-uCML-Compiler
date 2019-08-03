# CSE-712-uCML-Compiler
This is a baby compiler made using FLEX, BISON and LLVM for Compiler Lab CSE 712 @ Chittagong University.

### Functionalities:
- Variable Declaration
- Extern Declaration
- User Defined Function
- Conditional Statements

### Shortcomings
- Looping not Implemented
- Scope not Implemented

### Known Issues
- Although runs completely fine, it gives following error at the end, for some operating system (Linux Mint), but doesn't occur in some (Fedora).
  
          " double free or corruption (fasttop)
            Aborted (core dumped) "
    
    
  ## Running Instruction
      Just open your terminal and run the following:
      make          - To compile, link and make the executable file (a.out)
      make clean    - To clean the files other than sources
      make test     - To run the test cases
      
      After running "make test", you can find the outputs in /output/ folder
