# Makefile for verilog files
# W.Eschenfelder Jan 18, 2024

# call in windows should work on Mac as well
#     make all source=Mux_2_1_TB

# Windows only
#   mv requires coreutils from gnu32win package



SIM_DIR=../simulation
x=$(notdir $(source))
y=$(basename $(x))

all:  exec wave

$(SIM_DIR)/$(y).vvp: $(y).v ../hdl/VCPU32.v
	iverilog -o $(SIM_DIR)/$(y).vvp $(y).v
	
exec: $(SIM_DIR)/$(y).vvp
	vvp $(SIM_DIR)/$(y).vvp
	mv $(y).vcd $(SIM_DIR)

wave: $(SIM_DIR)/$(y).vcd
	gtkwave $(SIM_DIR)/$(y).vcd
	

