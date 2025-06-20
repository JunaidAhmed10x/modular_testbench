`ifndef UVM_MACROS_INCLUDED
  import uvm_pkg::*;
  `include "uvm_macros.svh"
`endif

class reset_sequence extends uvm_sequence #(sequence_item);
  `uvm_object_utils(reset_sequence)

  // Reference to command-line processor, to be set externally
  uvm_cmdline_processor clp;

  // Default reset duration
  int reset_cycles = 5;

  function new(string name = "reset_sequence");
    super.new(name);
  endfunction

 // Main reset sequence body
  task body();
    get_arguments();

    `uvm_info("RESET_SEQ", "Reset sequence started", UVM_LOW)

    for (int i = 0; i < reset_cycles; i++) begin
      sequence_item item = sequence_item::type_id::create("reset_item");
      start_item(item);
      assert(item.randomize() with {
        rstn == 0;
        enable == 0;
      });
      finish_item(item);
    end
    `uvm_info("RESET_SEQ", "Reset sequence completed", UVM_LOW)
  endtask

  function void get_arguments();
    string arg; //
    if (clp != null) begin
      int val;
      if (clp.get_arg_value("+reset_cycles=", arg)) begin
        reset_cycles = arg.atoi();
        `uvm_info("RESET_SEQ", $sformatf("Received reset_cycles = %0d", reset_cycles), UVM_LOW)
      end
    end
    else begin
      `uvm_error("RESET_SEQ", "Command-line processor (clp) is NULL. Make sure to assign it from the test in connect_phase.")
    end
  endfunction

endclass
