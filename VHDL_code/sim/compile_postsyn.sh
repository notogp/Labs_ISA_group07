source /software/scripts/init_msim6.2g
vcom -93 -work ./work ../components/constants.vhd
vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/data_gen.vhd
vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/tb_FIR.vhd
vlog -work ./work ../netlist/FIR_Filter.v
vcd file ../vcd/FIT_Filter_syn.vcd
vcd add /tb_FIR/filter_fir/*
vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_fir/UUT=../netlist/FIR_Filter.sdf work.tb_fir
