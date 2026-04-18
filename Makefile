
lchain
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# Directories
RTL_DIR  = rtl
TB_DIR   = tb
SIM_DIR  = sim
BUILD_DIR = $(SIM_DIR)/build
WAVE_DIR  = $(SIM_DIR)/waveforms

# Files
TOP      = counter_tb
OUT      = $(BUILD_DIR)/$(TOP).out
VCD      = $(WAVE_DIR)/counter.vcd

# Sources
RTL_SRCS = $(wildcard $(RTL_DIR)/*.v)
TB_SRCS  = $(wildcard $(TB_DIR)/*.v)

# Default target
all: run

# Compile
compile:
	mkdir -p $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(OUT) $(RTL_SRCS) $(TB_SRCS)

# Run simulation
run: compile
	$(VVP) $(OUT)

# View waveform
wave:
	$(GTKWAVE) $(VCD)

# Clean
clean:
	rm -rf $(SIM_DIR)

.PHONY: all compile run wave clean
