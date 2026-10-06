class simultaneous_sequence extends my_sequence;

  `uvm_object_utils(simultaneous_sequence)

  function new(string name = "simultaneous_sequence");
    super.new(name);
    n_item = 30;
  endfunction

  virtual task body();
    repeat (`DEPTH / 2) send_write_rand();   // give the reader something to take
    send_reset(3);
    repeat (n_item) send_both();             // concurrent traffic
    send_reset(5);
    repeat (`DEPTH) send_read();             // drain the remainder
    send_reset(5);
  endtask

endclass