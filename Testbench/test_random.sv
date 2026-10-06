class test_random extends test_base;

  `uvm_component_utils(test_random)

  function new(string name = "test_random", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = random_sequence::type_id::create("seq");
  endfunction


endclass
