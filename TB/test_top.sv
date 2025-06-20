`ifndef UVM_MACROS_INCLUDED
  import uvm_pkg::*;
  `include "uvm_macros.svh"
`endif

class counter_test extends uvm_test;
  `uvm_component_utils(counter_test)

  environment           env_h;
  main_sequence         seq;
  reset_sequence        rst_seq;

  int                   a = 0, b = 0, c = 0;
  bit [3:0]             z = 4'b0;
  string                my_name;
  uvm_cmdline_processor clp;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_h     = environment::type_id::create("env_h", this);
    rst_seq   = reset_sequence::type_id::create("rst_seq");
    seq       = main_sequence::type_id::create("seq");
    clp       = uvm_cmdline_processor::get_inst();
    seq.clp     = clp;
    rst_seq.clp = clp;
    get_arguments();
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    // TODO: Enable waveform dump or debug setup
  endfunction

  task pre_reset_phase(uvm_phase phase);
    super.pre_reset_phase(phase);
    // TODO: Pre-reset actions
  endtask

  task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    phase.raise_objection(this);
    `uvm_info("TEST", "Starting reset seq from reset_phase...", UVM_LOW)
    rst_seq.start(env_h.ag_h.seq_h);
    phase.drop_objection(this);
  endtask

  task post_reset_phase(uvm_phase phase);
    super.post_reset_phase(phase);
    // TODO: Post-reset setup
  endtask

  task pre_configure_phase(uvm_phase phase);
    super.pre_configure_phase(phase);
    // TODO: Prepare config
  endtask

  task configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    // TODO: Set config knobs or register values
  endtask

  task post_configure_phase(uvm_phase phase);
    super.post_configure_phase(phase);
    // TODO: Final config validation
  endtask

  task pre_main_phase(uvm_phase phase);
    super.pre_main_phase(phase);
    // TODO: Pre-main stimulus setup
  endtask

  task main_phase(uvm_phase phase);
    super.main_phase(phase);
    phase.raise_objection(this);
    `uvm_info("TEST", "Starting main_sequence from main_phase...", UVM_LOW)
    seq.start(env_h.ag_h.seq_h);
    phase.drop_objection(this);
  endtask

  task post_main_phase(uvm_phase phase);
    super.post_main_phase(phase);
    // TODO: Clean up after stimulus
  endtask

  task pre_shutdown_phase(uvm_phase phase);
    super.pre_shutdown_phase(phase);
    // TODO: Prepare for shutdown
  endtask

  task shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    // TODO: Stop clocks, close files
  endtask

  task post_shutdown_phase(uvm_phase phase);
    super.post_shutdown_phase(phase);
    // TODO: Wrap up shutdown
  endtask

  // ============================================================================
  // 3. CLEANUP PHASES
  // ============================================================================

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    // TODO: Extract scoreboard/coverage data
  endfunction

  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    // TODO: Check DUT outputs vs. expected
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    // TODO: Generate test summary
  endfunction

  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    // TODO: Close handles, final cleanup
  endfunction

  // ============================================================================
  // 4. CMDLINE ARGUMENT PARSING
  // ============================================================================
  function void get_arguments();
    string val_str;

    // a
    if (clp.get_arg_value("+a=", val_str)) begin
      a = val_str.atoi();
      `uvm_info("CMDLINE", $sformatf("Received a = %0d", a), UVM_LOW)
    end

    // b
    if (clp.get_arg_value("+b=", val_str)) begin
      b = val_str.atoi();
      `uvm_info("CMDLINE", $sformatf("Received b = %0d", b), UVM_LOW)
    end

    // c
    if (clp.get_arg_value("+c=", val_str)) begin
      c = val_str.atoi();
      `uvm_info("CMDLINE", $sformatf("Received c = %0d", c), UVM_LOW)
    end

    // my_name
    if (clp.get_arg_value("+name=", val_str)) begin
      my_name = val_str;
      `uvm_info("CMDLINE", $sformatf("Received name = %s", my_name), UVM_LOW)
    end

    // z (binary string like "1101" passed on command line)
    if (clp.get_arg_value("+z=", val_str)) begin
      z = val_str.atobin(); // e.g., z = "1101" becomes z = 4'b1101
      `uvm_info("CMDLINE", $sformatf("Received z = %b", z), UVM_LOW)
    end
  endfunction

endclass
