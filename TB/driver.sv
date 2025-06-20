
`ifndef UVM_MACROS_INCLUDED
  import uvm_pkg::*;
  `include "uvm_macros.svh"
`endif
`ifndef DRIVER_SV
`define DRIVER_SV

class driver extends uvm_driver #(sequence_item);
  `uvm_component_utils(driver)

  virtual counter_bfm bfm;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual counter_bfm)::get(this, "*", "bfm", bfm))
      `uvm_fatal("DRIVER", "Failed to get bfm from config DB")
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      sequence_item counter_data = sequence_item::type_id::create("counter_data");
      seq_item_port.get_next_item(counter_data);

      @(posedge bfm.clk);
      bfm.rstn   <= counter_data.rstn;
      bfm.enable <= counter_data.enable;

      seq_item_port.item_done();
    end
  endtask

endclass

`endif
