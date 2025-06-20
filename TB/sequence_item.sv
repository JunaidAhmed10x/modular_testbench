
`ifndef UVM_MACROS_INCLUDED
  import uvm_pkg::*;
  `include "uvm_macros.svh"
`endif
class sequence_item extends uvm_sequence_item;
  `uvm_object_utils(sequence_item)

  rand bit rstn, enable;
  bit [3:0] out;

  rand int stim_index;

  function new(string name = "sequence_item");
    super.new(name);
  endfunction

endclass
