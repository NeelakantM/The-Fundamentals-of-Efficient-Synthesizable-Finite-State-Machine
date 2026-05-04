# Toolchain
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# Directories
RTL_DIR  = rtl
TB_DIR   = tb
SIM_DIR  = sim
BUILD_DIR = $(SIM_DIR)/build
WAVE_DIR  = $(SIM_DIR)/waveforms
MODULE_NAME = checkbit_calc

# Files
TOP      = $(MODULE_NAME)_tb
OUT      = $(BUILD_DIR)/$(TOP).out
VCD      = $(WAVE_DIR)/$(MODULE_NAME).vcd

# Sources
RTL_SRCS = $(wildcard $(RTL_DIR)/$(MODULE_NAME).v)
TB_SRCS  = $(wildcard $(TB_DIR)/$(MODULE_NAME)_tb.v)

# Default target
all: run

# Compile RTL source with Test Bench
compiletb:
	mkdir -p $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(OUT) $(RTL_SRCS) $(TB_SRCS)

# Compile RTL Source file alone
compilesrc: 
	$(IVERILOG) -o sim.out $(RTL_SRCS)

# Run simulation
run: compiletb
	$(VVP) $(OUT)

# View waveform
wave:
	$(GTKWAVE) $(VCD)

# Clean
clean:
	rm -rf $(SIM_DIR)

.PHONY: all compile run wave clean
