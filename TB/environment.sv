`ifndef UVM_MACROS_INCLUDED
  import uvm_pkg::*;
  `include "uvm_macros.svh"
`endif
class environment extends uvm_env;
    `uvm_component_utils(environment);

    scoreboard scb_h;
    agent 	   ag_h;

    //------------------------
    //CONSTRUCTOR
    //------------------------
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    //------------------------
    //BUILD PHASE
    //------------------------
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      scb_h = scoreboard::type_id::create("scb_h",this);
      ag_h  = agent     ::type_id::create("ag_h",this);
    endfunction

    //------------------------
    //CONNECT PHASE
    //------------------------
    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      ag_h.mon_h.monitor_analysis_port.connect(scb_h.analysis_imp);

    endfunction

  endclass