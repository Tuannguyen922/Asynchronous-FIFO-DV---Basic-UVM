typedef enum {CMD_WRITE, CMD_READ, CMD_BOTH, CMD_INIT, CMD_RESET} cmd_e;
class my_packet extends uvm_sequence_item;

  rand cmd_e                 cmd;
  rand bit [`DATA_WIDTH-1:0] data;      // used by CMD_WRITE
  rand int unsigned          num_clk;   // used by CMD_INIT and CMD_RESET

  `uvm_object_utils_begin(my_packet)
    `uvm_field_enum(cmd_e, cmd, UVM_ALL_ON)
    `uvm_field_int (data,       UVM_ALL_ON | UVM_HEX)
    `uvm_field_int (num_clk,    UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end

  function new(string name = "my_packet");
    super.new(name);
  endfunction

  constraint c_num_clk {
    if (cmd == CMD_RESET) num_clk inside {[3:8]};
    else                  num_clk inside {[1:5]};
  }

  virtual function string convert2string();
    return $sformatf("cmd=%s data=0x%0h num_clk=%0d", cmd.name(), data, num_clk);
  endfunction

endclass
