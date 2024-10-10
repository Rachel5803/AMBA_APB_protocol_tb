class apb_master_driver extends uvm_driver #(apb_packet);

    virtual interface apb_if vif;
    int num_sent;

    `uvm_component_utils_begin(apb_master_driver)
        `uvm_field_int(num_sent, UVM_ALL_ON)
    `uvm_component_utils_end

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void connect_phase (uvm_phase phase);
        if(!apb_vif_config::get(this, "", "vif", vif))
            `uvm_error(get_full_name(), "Missing virtual I/F")
    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        fork
          get_and_drive();
          reset_signals();
        join
    endtask : run_phase

    // Gets packets from the sequencer and passes them to the driver.
    task get_and_drive();
        //@(negedge vif.master.presetn);
        `uvm_info(get_type_name(),"Reset Dropped", UVM_MEDIUM)
        // concurrent blocks for packet driving and transaction recording
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", req.sprint()), UVM_LOW)
            fork
                // send packet
                vif.master.send_to_dut(req.paddr, req.pwdata, req.pwrite, req.prdata);
                @(posedge vif.drvstart) void'(begin_tr(req, "master_driver_APB_Packet"));
            join
            // End transaction recording
            end_tr(req);
            seq_item_port.item_done();
            num_sent++;
        end
    endtask : get_and_drive

    task reset_signals();
        forever 
        vif.apb_reset();
    endtask : reset_signals

    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: APB master driver sent %0d packets", num_sent), UVM_LOW)
    endfunction : report_phase
    
endclass : apb_master_driver