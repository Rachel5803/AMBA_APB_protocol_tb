class apb_packet extends uvm_sequence_item;

    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 8;

    // Define protocol data
    rand bit [ADDR_WIDTH-1:0] paddr;
    rand bit [DATA_WIDTH-1:0] pwdata;
         bit [DATA_WIDTH-1:0] prdata;
    //rand bit                   psel;                
    //rand bit                   pready;
        

    // Define control knobs
    rand bit pwrite;

    `uvm_object_utils_begin(apb_packet)
         `uvm_field_int (paddr, UVM_ALL_ON)
         `uvm_field_int (pwdata, UVM_ALL_ON)
     //   `uvm_field_int (psel, UVM_ALL_ON)
     //   `uvm_field_int (pready, UVM_ALL_ON)
         `uvm_field_int (prdata, UVM_ALL_ON)
         `uvm_field_int (pwrite, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "apb_packet");
        super.new(name);
    endfunction : new

    //Define packet constraint
    //constraint pwrite_dist  { pwrite dist{1'b0 := 1, 1'b1:=1}; }
    
endclass : apb_packet