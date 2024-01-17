# Microfluidic Design Automation Toolchain

The purpose of this tool is generate a microfluidic chip from a set of open-source electronics design automation (EDA) tools and generate a SCAD output for 3D printing. This tool has been developed to be easily transportable using Docker containers to run the required software for the place and route module as well as the simulation software.

## Required Software

Docker


## Getting started

Make sure all submodules are pulled as well by running
```
git submodule update --init --recursive
```

A new template design can be generated simply by
```
make mk_from_template TEMP_DESIGN=<your_new_design>
```
This will generate a new design from the template directory using the variable, PLATFORM, in the Makefile. You will also need to change the DESIGN variable in the Makefile to match the design to be compiled when running the code.

make sure the necessary python libraries are installed including:
 - Pandas
 - docker
 - matplotlib


Additionally run 
```
make init
```
to pull the necessary docker containers and to build the library



To edit the design you will need to edit the following:    

 - src/<your_design>.v : This file contains the netlist information of the component and there connections. The components are listed in the <platform>_pdk directory.


 - src/simulation.config : This file contains the hardware information such as pumps used with pressures and flow rates. Additionally, the input chemical concentrations will be added here.

    
 - openroad/io_contraints.tcl : This specifies the location of the pins that will match to the interface chip. You will need to uncomment the pins that will be used for the chip desired. Then replace the variable after -pin_name with the port to be assigned in the verilog netlist file.


Files that can be optionally edited:
    
 - src/eval.config : This file describes the evaluations to make, currently only supports chemical evaluations
   
 - openroad/config.mk : describes the core and die area, not nessary to change.
    
 - openroad/global_place_args.tcl : variables use by the global placer RePlAce   

 - openscad/config.mk : configurations used for building the scad model 

 - openscad/dimm.csv : a wire by wire dimensional edit, can only be done for the whole wirelength

### Runng the code

After making the nessary edits to each of the folders you can run
```
make
```
to run through the entire process, alternatively you can run subsections of the code with
```
make pnr

make simulate_design
```

the results from the process will by put into the <your_platform>/<your_design>/results