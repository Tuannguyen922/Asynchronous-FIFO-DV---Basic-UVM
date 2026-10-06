class reset_sequence extends my_sequence;

  `uvm_object_utils(reset_sequence)

  bit [`DATA_WIDTH-1:0] before_reset [$];
  bit [`DATA_WIDTH-1:0] after_reset  [$];

  function new(string name = "reset_sequence");
    super.new(name);
  endfunction

  virtual task body();
    before_reset = '{16'hAAA0, 16'hAAA1, 16'hAAA2, 16'hAAA3};
    after_reset  = '{16'hBBB0, 16'hBBB1, 16'hBBB2, 16'hBBB3};

    foreach (before_reset[i]) send_write(before_reset[i]);
    send_reset(5);                                    // the reset under test
    foreach (after_reset[i])  send_write(after_reset[i]);
    send_reset(3);
    repeat (after_reset.size()) send_read();
    
    //
  endtask

endclass
