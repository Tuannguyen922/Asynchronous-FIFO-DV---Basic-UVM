class test_simultaneous extends test_base;

  `uvm_component_utils(test_simultaneous)

  function new(string name = "test_simultaneous", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = simultaneous_sequence::type_id::create("seq");
  endfunction

endclass