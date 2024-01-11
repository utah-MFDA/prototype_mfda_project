# Microfluidic Design Automation Toolchain

The purpose of this tool is generate a microfluidic chip from a set of open-source electronics design automation (EDA) tools and generate a SCAD output for 3D printing. This tool has been developed to be easily transportable using Docker containers to run the required software for the place and route module as well as the simulation software.

## Required Software

Docker


## Getting started

A new template design can be generated simply by
```
make mk_from_template TEMP_DESIGN=<your_new_design>
```
This will generate a new design from the template directory using the platform called in the PLATFORM variable in the Makefile. You will also need to change the DESIGN variable in the Makefile to match the design to be compiled.

To edit the design you will need to edit the following
    src/<your_design>.v
    - This file contains the netlist information of the component and there connections. The components are listed in the <platform>_pdk directory.

    src/simulation.config
    - This file contains the hardware information such as pumps used with pressures and flow rates. Additionally, the input chemical concentrations will be added here.

    openroad/io_contraints.tcl
    - This specifies the location of the pins that will match to the interface chip. You will need to uncomment the pins that will be used for the chip desired. Then replace the variable after -pin_name with the pin assigned in the verilog netlist file.


Files that can be optionally edited:
    src/eval.config
    - This file 
    
    openroad/config.mk
    - 
    
    openroad/global_place_args.tcl
    - 

    openscad/config.mk
    - 

    openscad/dimm.csv
    - 