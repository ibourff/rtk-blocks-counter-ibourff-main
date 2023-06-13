# Counter

This assignment revisits the basic flex counter. 
This implementation will be much like last time, 
but you will need to account for a few more signals. 
Additionally, your module must be dynamic based on an input parameter. 

## Pre-Code Tasks
Every student will be required to create a block diagram of their design 
**BEFORE** coding their design. The parameter N should be used in the 
diagram, and wavedrom should be used to make a timing diagram. Only once
a TA signs off on both of these diagrams may a student proceed to their 
implementation.

## Source Files
- counter.sv : This is where the design code should be located.
- tb_counter.sv : This is the test bench used to test your design.

## Specifications
### Module Name 
- counter

### Required Parameters
- `N` | width of counter

### Required Signals

- `clk` | System Clock
- `nrst` | Asyncronous active low reset to 0
- `enable` | Enable counter
- `clear` | Synchronous active high clear to 0
- `wrap` | 0: no wrap at max, 1: wrap to 0 at max
- `max` | Max number of count (inclusive)
- `count` | Current count
- `at_max` | 1 when counter is at max, otherwise 0

## Downloading these files
Please DO NOT download as a .zip file.  
You should run the following commmand to *clone* the *repository* onto
your remote computer, replacing `<URL>` with the URL of this repository.

```bash
git clone <URL>
```

## Instructions
1. Clone the repo from github.
2. Run `make setup` to cofigure directory for the project.
3. Make an RTL-diagram for the counter and have the design approved by a TA. Use [draw.io](https://app.diagrams.net/) **Make sure your design is located in the docs directory.**
4. Code your design in SystemVerilog.
5. Run `make help`/`make` to see the make file targets.
6. Have both source and mapped versions of your code working.
7. Have a TA review your source and mapped waveforms

## Submitting your design
Once your design has passed all the test cases, you need to commit your design.
This can be done in one of many ways, the primary one is through the Source Control
VS Code Tool (Ctrl + Shift + G). You will need to stage your changes, then you
can commit them, then you hit the sync button to sync your local repository with
the remote repository. These are a lot of words which are explaned in more detail 
in the GitHub fundementals assignment.
