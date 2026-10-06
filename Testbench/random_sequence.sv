class random_sequence extends my_sequence;

  `uvm_object_utils(random_sequence)

  function new(string name = "random_sequence");
    super.new(name);
    n_item = 100;
  endfunction

  virtual task body();
    repeat (n_item) begin
      case ($urandom_range(0, 3))
        0 : send_write_rand();
        1 : send_read();
        2 : send_both();
        3 : random_gap();
      endcase
    end
    send_reset(5);
    repeat (`DEPTH * 2) send_read();         // drain whatever is left
    send_reset(5);
  endtask

endclass