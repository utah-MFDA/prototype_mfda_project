export DESIGN_NAME      = smart_toilet_r
export PLATFORM         = mfda_30px_m

export VERILOG_FILES    = ./designs/src/$(DESIGN_NICKNAME)/smart_toilet_r.v
export SDC_FILE         = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# initial platform area
# 2550 1590
# values are in pixels which are 7.6 um

export DIE_AREA                 = 0 0 2550 1590
export CORE_AREA                = 0 0 2550 1590

export IO_CONSTRAINTS   = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/io_constraints.tcl
