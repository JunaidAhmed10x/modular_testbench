
`ifndef UVM_MACROS_INCLUDED
  import uvm_pkg::*;
  `include "uvm_macros.svh"
`endif

 module tb_top;

    // Clock generation
    bit clk = 0;
    always #5 clk = ~clk;

    // BFM instantiation
    counter_bfm bfm(clk);

    // DUT instantiation
    counter DUT(
      .clk(clk),
      .rstn(bfm.rstn),
      .enable(bfm.enable),
      .out(bfm.out)
    );

    // Simulation control
    initial begin
      uvm_config_db #(virtual counter_bfm)::set(null, "*", "bfm", bfm);
      run_test("counter_test");
    end

    // Optional waveform dump
    initial begin
      $dumpfile("dump.vcd");
      $dumpvars(0, tb_top);
    end

  endmodule