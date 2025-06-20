
`ifndef UVM_MACROS_INCLUDED
  import uvm_pkg::*;
  `include "uvm_macros.svh"
`endif
class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  // imp port to be connected with the monitor's analysis export
  uvm_analysis_imp#(sequence_item, scoreboard) analysis_imp;

  bit [3:0] expected_output; // reference model output

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_imp = new("analysis_imp", this);
  endfunction

  // Reference Model
  function void reference_model(sequence_item item);
    if (item.rstn == 0)
      expected_output <= 0;
    else if (item.enable == 1)
      expected_output <= expected_output + 1;
    // else hold value

    result(item);
  endfunction

  virtual function void write(sequence_item t);
    reference_model(t);
  endfunction

  // Result Comparison
  function void result(sequence_item item);
    if (expected_output == item.out) begin
      `uvm_info("SCOREBOARD : PASS", $sformatf("Expected: %0b, Actual: %0b", expected_output, item.out), UVM_HIGH)
    end else begin
      `uvm_info("SCOREBOARD : FAIL", $sformatf("Expected: %0b, Actual: %0b", expected_output, item.out), UVM_HIGH)
    end
  endfunction

endclass
