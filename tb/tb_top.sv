module tb_top;

    import uvm_pkg::*;

    `include "uvm_macros.svh"

    // import the APB package
    import apb_pkg::*;

    // include the test_lib
    `include "test_lib.sv"

    initial begin
        apb_vif_config::set(null, "*.env.master_agent.*", "vif", hw_top.apb_if);
        run_test("base_test");
     end


endmodule : tb_top