class my_driver extends uvm_driver #(my_packet);

  `uvm_component_utils(my_driver)

  virtual fifo_if vif;

  function new(string name = "my_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", {"VIF must be set for: ", get_full_name(), ".vif"})
  endfunction

  virtual task run_phase(uvm_phase phase);
    idle_signals();
    forever begin
      seq_item_port.get_next_item(req);
      case (req.cmd)
        CMD_WRITE : drive_write(req);
        CMD_READ  : drive_read (req);
        CMD_BOTH  : drive_both (req);
        //CMD_IDLE  : drive_idle (req);
        CMD_RESET : drive_reset(req);
        default   : `uvm_error("DRV", $sformatf("Unknown command %0d", req.cmd))
      endcase
      seq_item_port.item_done();
    end
  endtask

  // Pins at rest
  task idle_signals();
    vif.wr_en   <= 1'b0;
    vif.wr_data <= '0;
    vif.rd_en   <= 1'b0;         // never drive rd_data, it is a DUT output
  endtask

  // Write port, timed by the write clock
  task drive_write(my_packet pkt);
    @(posedge vif.wr_clk_setup);
    vif.wr_en   <= 1'b1;
    vif.wr_data <= pkt.data;
    @(posedge vif.wr_clk_setup);
    vif.wr_en   <= 1'b0;
  endtask

  // Read port, timed by the read clock
  task drive_read(my_packet pkt);
    @(posedge vif.rd_clk_setup);
    vif.rd_en <= 1'b1;
    @(posedge vif.rd_clk_setup);
    vif.rd_en <= 1'b0;
  endtask
        
  task drive_both(my_packet pkt);
    fork
      drive_write(pkt);
      drive_read (pkt);
    join
  endtask

  // Quiet cycles, so a scenario can space its traffic out
//   task drive_idle(my_packet pkt);
//     idle_signals();
//     repeat (pkt.num_clk) @(posedge vif.wr_clk_setup);
//   endtask

  // Reset
  task drive_reset(my_packet pkt);
    `uvm_info("DRV", "Applying reset...", UVM_LOW)
    vif.rst_n = 1'b0;
    idle_signals();

    repeat (pkt.num_clk) @(posedge vif.wr_clk);
    @(negedge vif.wr_clk);
    vif.rst_n = 1'b1;

    // recovery window allowed by the specification, in BOTH domains
    repeat (5) @(posedge vif.wr_clk);
    repeat (5) @(posedge vif.rd_clk);
    `uvm_info("DRV", "Reset released", UVM_LOW)
  endtask

endclass
