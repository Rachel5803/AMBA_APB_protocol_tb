class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    apb_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = apb_env::type_id::create("env", this);
        uvm_config_wrapper::set(this,
                                "env.master_agent.sequencer.run_phase",
                                "default_sequence",
                                apb_write_read_same_address::get_type());
        uvm_config_int::set(this, "*", "recording_detail", 1); 
        `uvm_info("BASE_TEST","Build phase of base_test is being executed", UVM_HIGH )
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);
    endtask : run_phase

    function void check_phase(uvm_phase phase);
        check_config_usage();
    endfunction : check_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

endclass : base_test

class write_read_test extends base_test;

    `uvm_component_utils(write_read_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this,
                                "env.master_agent.sequencer.run_phase",
                                "default_sequence",
                                apb_write_read_same_address::get_type());
        super.build_phase(phase);                        
    endfunction : build_phase

endclass : write_read_test
