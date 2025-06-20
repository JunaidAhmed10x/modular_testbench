
`ifndef UVM_MACROS_INCLUDED
  import uvm_pkg::*;
  `include "uvm_macros.svh"
`endif
`ifndef COUNTER_BFM_SV
`define COUNTER_BFM_SV

interface counter_bfm(input bit clk);
  logic       rstn;
  logic       enable;
  logic [3:0] out;

  // Clocking block for optional RTL modules
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output rstn, enable;
  endclocking

  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input out, rstn, enable;
  endclocking

  // Modports (for modules only, not used in UVM)
  modport DRIVER  (clocking driver_cb, input clk);
  modport MONITOR (clocking monitor_cb, input clk);

endinterface

`endif
