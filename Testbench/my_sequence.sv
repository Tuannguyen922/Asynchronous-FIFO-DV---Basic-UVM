class my_sequence extends uvm_sequence #(my_packet);
  `uvm_object_utils(my_sequence)

  int unsigned n_item   = `DEPTH;   // how many beats the scenario produces
  int unsigned max_idle = 3;        // upper bound for the gaps between beats

  bit power_on_reset = 1;

  function new(string name = "my_sequence");
    super.new(name);
  endfunction

  virtual task pre_body();
    if (power_on_reset) send_reset(5);
  endtask

  task send_write(bit [`DATA_WIDTH-1:0] value);
    req = my_packet::type_id::create("req");
    start_item(req);
    req.cmd = CMD_WRITE;  req.data = value;  req.num_clk = 0;
    finish_item(req);
    req.print();
  endtask

  task send_write_rand();
    req = my_packet::type_id::create("req");
    start_item(req);
    if (!req.randomize() with { cmd == CMD_WRITE; })
      `uvm_fatal("RNDFAIL", "Randomize write failed")
    finish_item(req);
    req.print();
  endtask

  task send_read();
    req = my_packet::type_id::create("req");
    start_item(req);
    req.cmd = CMD_READ;  req.num_clk = 0;
    finish_item(req);
    req.print();
  endtask

  // one write and one read at the same time, one in each clock domain
  task send_both();
    req = my_packet::type_id::create("req");
    start_item(req);
    if (!req.randomize() with { cmd == CMD_BOTH; })
      `uvm_fatal("RNDFAIL", "Randomize both failed")
    finish_item(req);
    req.print();
  endtask

  task send_init(int unsigned cycles);
    if (cycles == 0) return;
    req = my_packet::type_id::create("req");
    start_item(req);
    req.cmd = CMD_INIT;  req.num_clk = cycles;
    finish_item(req);
    req.print();
  endtask

  task send_reset(int unsigned hold = 5);
    req = my_packet::type_id::create("req");
    start_item(req);
    req.cmd = CMD_RESET;  req.num_clk = hold;
    finish_item(req);
    req.print();
  endtask

  task random_gap();
    send_reset($urandom_range(0, max_idle));
  endtask

endclass