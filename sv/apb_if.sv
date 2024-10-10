interface apb_if (input pclock, input presetn );

    timeunit 1ns;
    timeprecision 100ps;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import apb_pkg::*;

    localparam ADDR_WIDTH=8;
    localparam DATA_WIDTH=32;

    // Actual Signals
    logic [ADDR_WIDTH-1:0] paddr;
    logic [DATA_WIDTH-1:0] pwdata;
    logic [DATA_WIDTH-1:0] prdata;
    logic                  penable;
    logic                  pready;
    logic                  psel;
    logic                  pwrite;

    // signal for transaction recording
    bit monstart, drvstart;

    // modport for DUT
    modport slave (
        input pclock,
        input presetn,
        input drvstart,
        input paddr,
        input pwdata,
        input penable,
        input psel,
        input pwrite,
        output pready,
        output prdata
);

    // modport for apb_master_driver
    modport master (
        input pclock,
        input presetn,
        input drvstart,
        input pready,
        input prdata,
        output paddr,
        output pwdata,
        output penable,
        output psel,
        output pwrite,
        import send_to_dut,
        import apb_reset
    );

    // modport for apb_monitor
    modport monitor(
        input pclock,
        input presetn,
        input monstart,
        input paddr,
        input pwdata,
        input penable,
        input psel,
        input pwrite,
        input pready,
        input prdata,
        import collect_packet
    );

     // Collect Packets
    task collect_packet(
        output bit [ADDR_WIDTH-1:0]  addr,
               bit [DATA_WIDTH-1:0]  wdata,
               bit [DATA_WIDTH-1:0]  rdata,
               bit                   write);
       

        @(posedge pready  iff (penable))
        // trigger for transaction recording
        monstart = 1'b1;
        addr <= paddr;
        write <=pwrite;

        `uvm_info("APB_IF", "collect packets", UVM_HIGH)

        if(pwrite == 1'b1) begin
            wdata <= pwdata;
        end
        else begin
            rdata <= prdata;
            wdata <= 'b0;
        end
        @(negedge pready)
        monstart <= 1'b0;
    endtask : collect_packet

   
            
            


    // Gets a packet and drive it into the DUT
    task send_to_dut(
        input  bit [ADDR_WIDTH-1:0] addr,
               bit [DATA_WIDTH-1:0] wdata,
               bit                  write,
        output bit [DATA_WIDTH-1:0] rdata );

        @(posedge pclock)
        drvstart=1'b1;
        psel<='b1;
        paddr<=addr;
        penable<='b0;
        if(write==1) begin
            pwrite<=1'b1;
            pwdata<=wdata;
            
           @(posedge pclock or posedge pready);
           penable<='b1;

           if( pready) begin
           @(posedge pclock);
           penable<='b0;
           pwrite<='b0;
           psel<='b0;
           pwdata<='z;
           paddr<='z;
           end
           else begin
            @(posedge pready);
            @(posedge pclock);
            penable<='b0;
            pwrite<='b0;
            psel<='b0;
            pwdata<='z;
            paddr<='z;
           end

    
        end
        else begin 
    
            pwrite <= 1'b0; 
            pwdata <= 1'b0;
            @(posedge pclock);
            penable<=1'b1;
            
            @(posedge pready);
            @(posedge pclock);
            paddr<='z;
            psel<=1'b0;
            penable<=1'b0;
            `uvm_info("APB_IF",$sformatf("Master reads %h from %0h",rdata,addr), UVM_MEDIUM)
    
        end
    
       drvstart<='b0;

    endtask : send_to_dut

    task send_from_dut();
    endtask : send_from_dut
    
    task apb_reset();
        @(negedge presetn);
        pwdata <=  'hz;
        paddr <=  'hz;
        psel <= 1'b0;
        pwrite = 1'b0;
        penable = 1'b0;
        disable send_to_dut;
    endtask
      

endinterface : apb_if