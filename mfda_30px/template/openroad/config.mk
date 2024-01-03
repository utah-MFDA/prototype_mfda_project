export DESIGN_NAME      = %template%
export PLATFORM         = mfda_30px

export VERILOG_FILES    = ./designs/src/$(DESIGN_NICKNAME)/%template%.v
export SDC_FILE         = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# 2550 1590

export DIE_AREA                 = 0 0 2550 1590
export CORE_AREA                = 0 0 2550 1590

export IO_CONSTRAINTS   = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/io_constraints.tcl
