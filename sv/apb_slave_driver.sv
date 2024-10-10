class apb_slave_driver extends uvm_driver #(apb_packet);

    virtual interface apb_if vif;

    `uvm_component_utils(apb_slave_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void connect_phase (uvm_phase phase);
        if(!apb_vif_config::get(this, "", "vif", vif))
            `uvm_error(get_full_name(), "Missing virtual I/F")
    endfunction : connect_phase

    task run_phase(uvm_phase phase);
    endtask : run_phase

endclass : apb_slave_driver