class test_wraparound extends test_base;

  `uvm_component_utils(test_wraparound)

  function new(string name = "test_wraparound", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = wraparound_sequence::type_id::create("seq");
  endfunction

endclass
