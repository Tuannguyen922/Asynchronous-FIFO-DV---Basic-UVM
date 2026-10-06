  `define DEPTH       8
  `define DATA_WIDTH  16
  `define ADDR_WIDTH  $clog2(`DEPTH)
  `define WR_PERIOD   10
  `define RD_PERIOD   14
  `define T_SETUP     3
  `define T_HOLD      2

  `include "interface.sv"

package pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  //=========== transaction ==========
  `include "my_packet.sv"

  //=========== sequences ============
  `include "my_sequence.sv"     // base class must come BEFORE its children
  `include "write_sequence.sv"
  `include "read_sequence.sv"
  `include "reset_sequence.sv"
  `include "random_sequence.sv"
  `include "wraparound_sequence.sv"
  `include "simultaneous_sequence.sv"

  //=========== sequencer ============
  `include "my_sequencer.sv"      // one class, instantiated twice

  //=========== drivers ==============
  `include "my_driver.sv"

  //=========== test cases ===========
  `include "test_base.sv"         // base test first
  `include "test_write.sv"
  `include "test_read.sv"
  `include "test_reset.sv"
  `include "test_random.sv"
  `include "test_wraparound.sv"
  `include "test_simultaneous.sv"

endpackage
