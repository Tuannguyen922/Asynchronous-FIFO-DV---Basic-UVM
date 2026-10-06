class read_sequence extends my_sequence;

  `uvm_object_utils(read_sequence)

  function new(string name = "read_sequence");
    super.new(name);
    n_item = `DEPTH;
  endfunction

  virtual task body();
    repeat (n_item) send_write_rand();      // setup
    send_reset(5);
    repeat (n_item + 4) send_read();        // four beats past the end
    send_reset(5);
  endtask

endclass
