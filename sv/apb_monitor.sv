class apb_monitor extends uvm_monitor;

    `uvm_component_utils(apb_monitor)

    virtual interface apb_if vif;

    // Collected Data handle
    apb_packet pkt;
    // Count packets collected
    int num_pkt_col;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
        // Create collected packet instance
        pkt = apb_packet::type_id::create("pkt", this);
        forever begin 
          // concurrent blocks for packet collection and transaction recording
          fork
            // collect packet
            vif.monitor.collect_packet(pkt.paddr, pkt.pwdata, pkt.prdata, pkt.pwrite);
            // trigger transaction at start of packet
            @(posedge vif.monitor.monstart) void'(begin_tr(pkt, "Monitor_APB_Packet"));
          join
          // End transaction recording
          end_tr(pkt);
          `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_LOW)
          num_pkt_col++;
        end
    endtask : run_phase


    function void connect_phase( uvm_phase phase);
        if ( ! apb_vif_config::get(this, "", "vif", vif ) )
        `uvm_error(get_full_name(), "Missing virtual I/F")
    endfunction : connect_phase

    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: APB Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
    endfunction : report_phase

endclass : apb_monitor
