class apb_env extends uvm_env;

    `uvm_component_utils(apb_env)

    apb_master_agent master_agent;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        master_agent = apb_master_agent::type_id::create("master_agent", this);
    endfunction : build_phase
endclass : apb_env