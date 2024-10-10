class apb_master_agent extends uvm_agent;

    apb_monitor monitor;
    apb_master_driver driver;
    apb_sequencer sequencer;

    `uvm_component_utils_begin(apb_master_agent)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_component_utils_end

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = apb_monitor::type_id::create("monitor", this);
        if(is_active == UVM_ACTIVE) begin
            sequencer = apb_sequencer::type_id::create("sequencer", this);
            driver = apb_master_driver::type_id::create("driver", this);
        end
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        if(is_active == UVM_ACTIVE)
            driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction : connect_phase

endclass : apb_master_agent
