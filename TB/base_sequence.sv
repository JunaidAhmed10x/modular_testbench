
`ifndef UVM_MACROS_INCLUDED
  import uvm_pkg::*;
  `include "uvm_macros.svh"
`endif
class main_sequence extends uvm_sequence #(sequence_item);
  `uvm_object_utils(main_sequence)

  sequence_item counter_stimulus;

  int total_cycles = 35;
  string arg;
  uvm_cmdline_processor clp;

  function new(string name = "main_sequence");
    super.new(name);
  endfunction

  // Get simulation arguments from command line
  function void get_arguments();
    string arg;

    if (clp.get_arg_value("+total_cycles=", arg)) begin
      total_cycles = arg.atoi();
      `uvm_info("CMDLINE", $sformatf("Received total_cycles = %0d", total_cycles), UVM_LOW)
    end
  endfunction

  // Main stimulus generation
  task body();
    get_arguments();

    `uvm_info("MAIN_SEQ", "********* MAIN SEQUENCE STARTED *********", UVM_LOW)
    for (int i = 0; i < total_cycles; i++) begin
      counter_stimulus = sequence_item::type_id::create("counter_stimulus");
      start_item(counter_stimulus);

      assert(counter_stimulus.randomize() with {
        stim_index == i;
        rstn == 1;          // Reset handled externally
        enable == 1;        // Stimulus always enabled during main phase
      });

      finish_item(counter_stimulus);
    end
    `uvm_info("MAIN_SEQ", "********* MAIN SEQUENCE COMPLETED *********", UVM_LOW)
  endtask

endclass
