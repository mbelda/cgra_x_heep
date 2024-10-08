// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package iffifo_reg_pkg;

  // Address widths within the block
  parameter int BlockAw = 5;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    logic [31:0] q;
    logic        re;
  } iffifo_reg2hw_fifo_out_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } iffifo_reg2hw_fifo_in_reg_t;

  typedef struct packed {logic [31:0] q;} iffifo_reg2hw_watermark_reg_t;

  typedef struct packed {
    logic q;
    logic qe;
  } iffifo_reg2hw_interrupts_reg_t;

  typedef struct packed {logic [31:0] d;} iffifo_hw2reg_fifo_out_reg_t;

  typedef struct packed {
    struct packed {
      logic d;
      logic de;
    } empty;
    struct packed {
      logic d;
      logic de;
    } available;
    struct packed {
      logic d;
      logic de;
    } reached;
    struct packed {
      logic d;
      logic de;
    } full;
  } iffifo_hw2reg_status_reg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } iffifo_hw2reg_occupancy_reg_t;

  // Register -> HW type
  typedef struct packed {
    iffifo_reg2hw_fifo_out_reg_t fifo_out;  // [99:67]
    iffifo_reg2hw_fifo_in_reg_t fifo_in;  // [66:34]
    iffifo_reg2hw_watermark_reg_t watermark;  // [33:2]
    iffifo_reg2hw_interrupts_reg_t interrupts;  // [1:0]
  } iffifo_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    iffifo_hw2reg_fifo_out_reg_t fifo_out;  // [72:41]
    iffifo_hw2reg_status_reg_t status;  // [40:33]
    iffifo_hw2reg_occupancy_reg_t occupancy;  // [32:0]
  } iffifo_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] IFFIFO_FIFO_OUT_OFFSET = 5'h0;
  parameter logic [BlockAw-1:0] IFFIFO_FIFO_IN_OFFSET = 5'h4;
  parameter logic [BlockAw-1:0] IFFIFO_STATUS_OFFSET = 5'h8;
  parameter logic [BlockAw-1:0] IFFIFO_OCCUPANCY_OFFSET = 5'hc;
  parameter logic [BlockAw-1:0] IFFIFO_WATERMARK_OFFSET = 5'h10;
  parameter logic [BlockAw-1:0] IFFIFO_INTERRUPTS_OFFSET = 5'h14;

  // Reset values for hwext registers and their fields
  parameter logic [31:0] IFFIFO_FIFO_OUT_RESVAL = 32'h0;

  // Register index
  typedef enum int {
    IFFIFO_FIFO_OUT,
    IFFIFO_FIFO_IN,
    IFFIFO_STATUS,
    IFFIFO_OCCUPANCY,
    IFFIFO_WATERMARK,
    IFFIFO_INTERRUPTS
  } iffifo_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] IFFIFO_PERMIT[6] = '{
      4'b1111,  // index[0] IFFIFO_FIFO_OUT
      4'b1111,  // index[1] IFFIFO_FIFO_IN
      4'b0001,  // index[2] IFFIFO_STATUS
      4'b1111,  // index[3] IFFIFO_OCCUPANCY
      4'b1111,  // index[4] IFFIFO_WATERMARK
      4'b0001  // index[5] IFFIFO_INTERRUPTS
  };

endpackage

