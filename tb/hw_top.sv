module hw_top;

    // Clock and reset signals
    logic clock;
    logic reset;

    // APB Interface to the DUT
    apb_if apb_if(
        .pclock(clock), 
        .presetn(reset)
    );

    // CLOCK_AND_RESET module generates clock and reset
    clock_and_reset clk_and_rst(
        .clock(clock),
        .reset(reset)
    );

    // DUT instance
    apb_slave dut(
        .pclk(clock),
        .rst_n(reset),
        .paddr(apb_if.paddr),
        .psel(apb_if.psel),
        .penable(apb_if.penable),
        .pwrite(apb_if.pwrite),
        .pwdata(apb_if.pwdata),
        .pready(apb_if.pready),
        .prdata(apb_if.prdata)
    );

endmodule : hw_top