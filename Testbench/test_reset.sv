class test_reset extends test_base;

  `uvm_component_utils(test_reset)

  reset_sequence rseq;

  function new(string name = "test_reset", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rseq = reset_sequence::type_id::create("seq");
    seq  = rseq;
  endfunction

endclass
