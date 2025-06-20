
`ifndef UVM_MACROS_INCLUDED
  import uvm_pkg::*;
  `include "uvm_macros.svh"
`endif
  
`ifndef MONITOR_SV
`define MONITOR_SV

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  virtual counter_bfm bfm;
  uvm_analysis_port #(sequence_item) monitor_analysis_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual counter_bfm)::get(this, "*", "bfm", bfm))
      `uvm_fatal("MONITOR", "Failed to get bfm from config DB")

    monitor_analysis_port = new("monitor_analysis_port", this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      sequence_item counter_data = sequence_item::type_id::create("counter_data");
      @(posedge bfm.clk);
      counter_data.out    = bfm.out;
      counter_data.rstn   = bfm.rstn;
      counter_data.enable = bfm.enable;
      monitor_analysis_port.write(counter_data);
    end
  endtask

endclass

`endif
