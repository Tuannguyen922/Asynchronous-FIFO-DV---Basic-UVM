class test_read extends test_base;

  `uvm_component_utils(test_read)

  function new(string name = "test_read", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = read_sequence::type_id::create("seq");
  endfunction

endclass
