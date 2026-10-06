class test_base extends uvm_test;
  `uvm_component_utils(test_base)

  my_driver    drv;
  my_sequencer seqr;
  my_sequence  seq;

  function new(string name = "test_base", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv  = my_driver   ::type_id::create("drv",  this);
    seqr = my_sequencer::type_id::create("seqr", this);
    seq  = my_sequence ::type_id::create("seq");     // child testcases replace this
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this, 2000ns);

    seq.start(seqr);               // the one scenario this testcase runs

    phase.drop_objection(this);
  endtask


endclass
