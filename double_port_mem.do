vlib work
vmap work work

vlog -work work double_port_mem.v
vlog -work work double_port_mem_tb.v

vsim -novopt work.double_port_mem_tb

add wave -position insertpoint sim:/double_port_mem_tb/*

run -all
