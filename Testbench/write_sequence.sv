class write_sequence extends my_sequence;

  `uvm_object_utils(write_sequence)

  function new(string name = "write_sequence");
    super.new(name);
    n_item = `DEPTH + 4;          // four beats more than the FIFO can hold
  endfunction

  virtual task body();
    repeat (n_item) send_write_rand();
    //send_idle(5);
  endtask

endclass