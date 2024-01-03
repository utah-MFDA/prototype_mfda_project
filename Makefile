# Shell setup for make
SHELL		= /bin/bash
.SHELLFLAGS	= -o pipefail -c

# Default target when invoking without specific target
.DEFAULT_GOAL := all

# Design platform and name to explorew
PLATFORM ?= mfda_30px_m
#PLATFORM ?= mfda_30px

##### mfda_30px ## devices
#DESIGN   ?= PCR1_V2
#DESIGN   ?= PCR1_V2_opt
#DESIGN   ?= valve_test_01
#DESIGN   ?= smart_toilet_2_1
#DESIGN   ?= smart_toilet_t
#DESIGN   ?= smart_toilet_t_opt
#DESIGN   ?= smart_toilet_t2
#DESIGN   ?= smart_toilet_t_mod1
#DESIGN   ?= smart_toilet_t_mod2
#DESIGN   ?= smart_toilet_t_mod3
#DESIGN   ?= smart_toilet_t_mod3_opt_2

#DESIGN   ?= three_port_test1
#DESIGN   ?= three_port_test2

#DESIGN   ?= simple_two_mix

##### mfda_30px_m ## devices
#DESIGN ?= serp_100_200_test
#DESIGN ?= smart_t_multiplex
#DESIGN ?= valve_test
DESIGN ?= PCR_MIXER_1

LOCAL_OR_DIR  = ./$(PLATFORM)/$(DESIGN)/openroad
LOCAL_SCAD_DIR= ./$(PLATFORM)/$(DESIGN)/openscad
LOCAL_SRC_DIR = ./$(PLATFORM)/$(DESIGN)/src

#########################################
### Docker configurations
#########################################


PNR_DOCKER_IMAGE = bgoenner/mfda_pnr_cp:latest
SIM_DOCKER_IMAGE = bgoenner/mfda_xyce:latest

####### WINDOWS container ###############

#PNR_DOCKER_CONTAINER = musing_khayyam

####### LINUX container UB ##############
#PNR_DOCKER_CONTAINER = epic_boyd
#SIM_DOCKER_CONTAINER    = vibrant_clarke

## SUSE
PNR_DOCKER_CONTAINER = loving_blackburn
SIM_DOCKER_CONTAINER = gifted_colden

# results folder
DOCKER_RESULTS=
LOCAL_RESULTS = 

##### component library config ##########################################

LIBRARY_BASE_DIR = ./h.r.3.3_pdk/components/
LIBRARY_CSV      = $(LIBRARY_BASE_DIR)/StandardCellLibrary.csv

# docker configurations
PNR_ROOT = /place_and_route/pnr
PNR_MAKEFILE_LOCAL = ./$(PLATFORM)/$(DESIGN)/PnR_Makefile
OR_MAKEFILE_LOCAL  = $(LOCAL_OR_DIR)/OR_Makefile
DOCKER_OR_DIR  = $(PNR_ROOT)/openroad_flow/designs/$(PLATFORM)/$(DESIGN)
DOCKER_SCAD_DIR= $(PNR_ROOT)/scad_flow/designs/$(PLATFORM)/$(DESIGN)
DOCKER_OR_LOG  = $(PNR_ROOT)/openroad_flow/logs/$(DESIGN)

DOCKER_PNR_RESULT = $(PNR_ROOT)/openroad_flow/results/$(DESIGN)/base


#DOCKER_CONTAINER= reverent_mclean
#DOCKER_CONTAINER = intelligent_torvalds


##########################################

LOGS_DIR = ./$(PLATFORM)/$(DESIGN)/logs
RESULTS_DIR= ./$(PLATFORM)/$(DESIGN)/results

# Download configurations
SCAD_DOWN_DIR = $(RESULTS_DIR)/scad

PNR_RESULTS_DIR= $(RESULTS_DIR)/pnr

##### simulation config ##########################################



#SIM_DIR = ~/Github/simulation/Continuous
SIM_DIR       = ./simulation
#SIM_FILES_DIR = $(SIM_DIR)/V2Va_Parser/testFiles/$(PLATFORM)/$(DESIGN)
SIM_FILES_DIR           = ./$(PLATFORM)/$(DESIGN)/src
SIM_CIR_CONFIG          = $(SIM_DIR)/V2Va_Parser/VMF_xyce.mfsp

#SIM_PROJ_DIR  = ./$(PLATFORM)/$(DESIGN)/xyce
SIM_FILE      = $(LOCAL_SRC_DIR)/simulation.config

SIM_RESULTS   = $(RESULTS_DIR)/xyce

SIM_ARGS= --netlist $(DESIGN).v --sim_dir $(SIM_PROJ_DIR) --sim_file $(SIM_PROJ_DIR) --design $(DESIGN) --length_file $(SCAD_DOWN_DIR)/base/$(DESIGN)_lengths.xlsx --cir_config $(SIM_CIR_CONFIG) --docker_container $(SIM_DOCKER_CONTAINER) --lib $(LIBRARY_CSV)



# the template directory contains all of the nessary instructions
# Also verifies the Verilog file exists
TEMPLATE_DIR = ./$(PLATFORM)/template
TEMP_DESIGN ?= template




#make_src_from_mfda:

#LOCAL SCAD DIR
# Ub
#SCAD_FLOW_LOCAL_DIR = /home/bg/Github/MFDA/place_and_route/pnr/scad_flow
# Win
SCAD_FLOW_LOCAL_DIR = /mnt/c/Users/BG/Documents/Github/MFDA/place_and_route/pnr/scad_flow
#export $(SCAD_FLOW_LOCAL_DIR)/designs/$(PLATFORM)/$(DESIGN)/config.mk
#include $(LOCAL_SCAD_DIR)/config.mk
#export SCAD_DIR=$(SCAD_FLOW_LOCAL_DIR)/scad

ifdef DESIGN
export DESIGN
endif

## final docker config
#RUN_SIM_COMMAND = python3 $(SIM_DIR)/runMFDASim.py --preRoute False $(SIM_ARGS)
RUN_SIM_COMMAND = runMFDASim.py --preRoute False $(SIM_ARGS)

#PNR_DOCKER_COMMAND = cd $(PNR_ROOT) && make
#SIM_DOCKER_COMMAND = cd $(SIM_RUN_ROOT) && $(RUN_SIM_COMMAND)

# Check if docker is running
run_docker:
	docker run --rm -ti $(PNR_DOCKER_CONTAINER) bash -c 'source $(PNR_ROOT)/setup_env.sh'


create_pnr_docker:
	docker create -w $(PNR_ROOT) $(PNR_DOCKER_IMAGE) make

create_sim_docker:
	docker run -dit $(SIM_DOCKER_IMAGE)
	#docker create -w $(SIM_DIR) $(SIM_DOCKER_IMAGE) python3 $(RUN_SIM_COMMAND)

run_sim_docker:
	docker start $(SIM_DOCKER_CONTAINER)

# Upload design -------------------------------------------------------------------------------
upload_src:
	echo "Upload SRC Verilog"
	#docker exec $(PNR_DOCKER_CONTAINER) mkdir -p $(PNR_ROOT)/openroad_flow/designs/src/$(DESIGN)/
	mkdir ./$(PLATFORM)/$(DESIGN)/src/$(DESIGN)
	cp ./$(PLATFORM)/$(DESIGN)/src/$(DESIGN).v ./$(PLATFORM)/$(DESIGN)/src/$(DESIGN)/$(DESIGN).v
	docker cp ./$(PLATFORM)/$(DESIGN)/src/$(DESIGN) $(PNR_DOCKER_CONTAINER):$(PNR_ROOT)/openroad_flow/designs/src/
	rm -r ./$(PLATFORM)/$(DESIGN)/src/$(DESIGN)
	
upload_make_2_docker:

	rm -f $(PNR_MAKEFILE_LOCAL)
	rm -f $(OR_MAKEFILE_LOCAL)

	# create makefile for PnR
	touch $(PNR_MAKEFILE_LOCAL)
	echo "# Design platform and name to explore" >> $(PNR_MAKEFILE_LOCAL)
	echo "PLATFORM = $(PLATFORM)" >> $(PNR_MAKEFILE_LOCAL)
	echo "DESIGN = $(DESIGN)" >> $(PNR_MAKEFILE_LOCAL)
	cat PnR_Makefile >> $(PNR_MAKEFILE_LOCAL)
	
	# create makefile for Openroad
	touch $(OR_MAKEFILE_LOCAL)
	echo "DESIGN_CONFIG = ./designs/$(PLATFORM)/$(DESIGN)/config.mk" >> $(OR_MAKEFILE_LOCAL)
	echo "DESIGN ?= $(DESIGN)" >> $(OR_MAKEFILE_LOCAL)
	echo "PLATFORM ?= $(PLATFORM)" >> $(OR_MAKEFILE_LOCAL)
	cat OR_Makefile >> $(OR_MAKEFILE_LOCAL)
	
	# upload makefiles
	docker cp $(PNR_MAKEFILE_LOCAL) $(PNR_DOCKER_CONTAINER):$(PNR_ROOT)/Makefile
	docker cp $(OR_MAKEFILE_LOCAL) $(PNR_DOCKER_CONTAINER):$(PNR_ROOT)/openroad_flow/Makefile


upload_pnr: 
	mkdir -p $(LOCAL_OR_DIR)/$(PLATFORM)/$(DESIGN)
	cp $(LOCAL_OR_DIR)/config.mk $(LOCAL_OR_DIR)/$(PLATFORM)/$(DESIGN)
	cp $(LOCAL_OR_DIR)/constraint.sdc $(LOCAL_OR_DIR)/$(PLATFORM)/$(DESIGN)
	cp $(LOCAL_OR_DIR)/io_constraints.tcl $(LOCAL_OR_DIR)/$(PLATFORM)/$(DESIGN)
	cp $(LOCAL_OR_DIR)/global_place_args.tcl $(LOCAL_OR_DIR)/$(PLATFORM)/$(DESIGN)

	docker cp $(LOCAL_OR_DIR)/$(PLATFORM) $(PNR_DOCKER_CONTAINER):$(PNR_ROOT)/openroad_flow/designs
	
upload_scad: $(LOCAL_SCAD_DIR)/config.mk $(LOCAL_SCAD_DIR)/dimm.csv
	mkdir -p $(LOCAL_SCAD_DIR)/$(PLATFORM)/$(DESIGN)
	cp $(LOCAL_SCAD_DIR)/config.mk $(LOCAL_SCAD_DIR)/$(PLATFORM)/$(DESIGN)
	cp $(LOCAL_SCAD_DIR)/dimm.csv $(LOCAL_SCAD_DIR)/$(PLATFORM)/$(DESIGN)

	docker cp $(LOCAL_SCAD_DIR)/$(PLATFORM) $(PNR_DOCKER_CONTAINER):$(PNR_ROOT)/scad_flow/designs

# Run PnR Docker --------------------------------------------------------------------------------

run_docker_pnr_make:

	docker start -a $(PNR_DOCKER_CONTAINER)
	
	# cp logs
	mkdir -p $(LOGS_DIR)
	docker cp $(PNR_DOCKER_CONTAINER):$(DOCKER_OR_LOG)/base $(LOGS_DIR)

download_scad:
	#if [[ ! -e $(SCAD_DOWN_DIR) ]]; then
	mkdir -p $(SCAD_DOWN_DIR)
	#fi
	docker cp $(PNR_DOCKER_CONTAINER):$(PNR_ROOT)/results/$(PLATFORM)/$(DESIGN)/base $(SCAD_DOWN_DIR)
	
	# remove bulk 
	python3 ./removeBulk.py --infile $(SCAD_DOWN_DIR)/base/$(DESIGN).scad --platform $(PLATFORM) --design $(DESIGN)
	

download_pnr_results:
	
	mkdir -p $(PNR_RESULTS_DIR)
	
	docker cp $(PNR_DOCKER_CONTAINER):$(DOCKER_PNR_RESULT) $(PNR_RESULTS_DIR)

# Alternative scad 
local_scad:
	echo $(LOCAL_SCAD_DIR)
	mkdir -p $(SCAD_FLOW_LOCAL_DIR)/designs/$(PLATFORM)/$(DESIGN)

	# copy scad file to local scad flow
	cp -r $(LOCAL_SCAD_DIR)/* $(SCAD_FLOW_LOCAL_DIR)/designs/$(PLATFORM)/$(DESIGN)
	cp $(RESULTS_DIR)/pnr/base/4_final.def $(SCAD_FLOW_LOCAL_DIR)/designs/$(PLATFORM)/$(DESIGN)

	# SCAD flow make
	cd $(SCAD_FLOW_LOCAL_DIR) && $(MAKE)
	cp -r $(SCAD_FLOW_LOCAL_DIR)/designs/$(PLATFORM)/$(DESIGN)/base $(SCAD_DOWN_DIR)

remove_bulk_scad:
	# remove bulk 
	python3 ./removeBulk.py --infile $(SCAD_DOWN_DIR)/base/$(DESIGN).scad --platform $(PLATFORM) --design $(DESIGN)

# Simulation ---------------------------------------------
	

# Adjusted to work with the Xyce engine
simulate_design: 
	# copy netlist to xyce directory
	mkdir -p ./$(PLATFORM)/$(DESIGN)/xyce
	cp ./$(PLATFORM)/$(DESIGN)/src/$(DESIGN).v ./$(PLATFORM)/$(DESIGN)/xyce/$(DESIGN).v
	
	python3 $(SIM_DIR)/runMFDASim.py --preRoute False $(SIM_ARGS) 
	# mv results directory
	mkdir -p $(SIM_RESULTS)
	
	rm -rf $(SIM_RESULTS)/*
	mv ./$(PLATFORM)/$(DESIGN)/xyce/results/results $(SIM_RESULTS)
	
	#rm -rf ./$(PLATFORM)/$(DESIGN)/xyce/results/results

# sync instructions
DOCKER_LEF_DIR = /place_and_route/pnr/openroad_flow/platforms/$(PLATFORM)/lef
sync_lef:
	cd $(LIBRARY_BASE_DIR)/Components && make make_lef
	docker cp $(LIBRARY_BASE_DIR)/Components/HR3.3_merged.lef $(PNR_DOCKER_CONTAINER):$(DOCKER_LEF_DIR)/$(PLATFORM)_merged.lef

DOCKER_SCAD_DIR = /place_and_route/pnr/scad_flow/scad
sync_scad:
	cd $(LIBRARY_BASE_DIR)/Components && make make_lef
	docker cp $(LIBRARY_BASE_DIR)/Components/scad_build/HR3.3_merged.scad $(PNR_DOCKER_CONTAINER):$(DOCKER_SCAD_DIR)/$(PLATFORM)/$(PLATFORM)_components_merged.scad

XYCE_LIB_BASE_DIR = /mfda_simulation/component_library/VerilogA/MFlibrary/xyce_lib/MFlibrary
sync_xyce:
	cd $(LIBRARY_BASE_DIR)/Components && make make_lef
	docker cp $(LIBRARY_BASE_DIR)/Components/verilogA_build/lib/libMFXyce.so $(SIM_DOCKER_CONTAINER):$(XYCE_LIB_BASE_DIR)/libMFlibrary.so

sync_files: sync_lef sync_scad sync_xyce

	
# Not Adjusted yet
# TODO change to use with Xyce
simulate_preRoute:

	#cp $(LOCAL_SRC_DIR)/

	#SIM_ARGS_PREROUTE = --verilog_file $(DESIGN).v --path $(SIM_FILES_DIR) --design $(DESIGN) --lengths_file $(SCAD_DOWN_DIR)/base/$(DESIGN)_lengths.xlsx
	mkdir -p $(LOCAL_SRC_DIR)/spiceFiles/preRoute
	
	python3 $(SIM_DIR)/simMain.py $(SIM_ARGS) --preRoute True
	
	mkdir -p ./$(PLATFORM)/$(DESIGN)/spiceFiles/
	rm -f -r ./$(PLATFORM)/$(DESIGN)/spiceFiles/preRoute
	
	rsync -a $(LOCAL_SRC_DIR)/spiceFiles/preRoute ./$(PLATFORM)/$(DESIGN)/spiceFiles/preRoute

sim_mv_files:
	mv $(LOCAL_SRC_DIR)/spiceFiles/* ./$(PLATFORM)/$(DESIGN)/spiceFiles

# Make from template ---------------------------------

mk_from_template: 
	if [ $(TEMP_DESIGN) != template ]; then \
		mkdir -p $(PLATFORM)/$(TEMP_DESIGN); \
		python3 build_from_template.py --template_dir $(TEMPLATE_DIR) --new_design $(TEMP_DESIGN) --platform $(PLATFORM); \
	else \
		echo TEMP_DESIGN not defined; \
	fi;

# Clean ----------------------------------------------
	
clean_sim:
	rm -r $(PLATFORM)/$(DESIGN)/spiceFiles
	mkdir $(PLATFORM)/$(DESIGN)/spiceFiles
	
docker_clean:
	docker exec -w $(PNR_ROOT) $(PNR_DOCKER_CONTAINER) $(MAKE) clean_all


#-----

upload_files: upload_src upload_pnr upload_scad upload_make_2_docker
pnr: upload_files run_docker_pnr_make download_scad download_pnr_results
pnr_localscad: upload_files run_docker_OR download_pnr_results local_scad remove_bulk_scad

redesign: pnr simulate_design

#all: pnr simulate_preRoute simulate_design
all: pnr simulate_design
clean_all: docker_clean clean_sim

