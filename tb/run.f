-timescale 1ns/1ns

-64

 -uvmhome $UVMHOME

 // include directories

 -incdir ../sv

 //compile files
 ../sv/apb_pkg.sv
 ../sv/apb_if.sv
 clock_and_reset.sv
 tb_top.sv
 hw_top.sv
 ../apb_dut/apb_slave.sv

 +UVM_TESTNAME=base_test
 +UVM_VERBOSITY=UVM_LOW
 +SVSEED=random