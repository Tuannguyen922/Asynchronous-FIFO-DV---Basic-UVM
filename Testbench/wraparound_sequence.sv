class wraparound_sequence extends my_sequence;

  `uvm_object_utils(wraparound_sequence)

  int unsigned n_cycle = 12;      // full fill/drain rounds

  function new(string name = "wraparound_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat (n_cycle) begin
      repeat (`DEPTH) send_write_rand();     // right up to full
      send_reset(2);
      repeat (`DEPTH) send_read();           // right down to empty
      send_reset(2);
    end
  endtask

endclass