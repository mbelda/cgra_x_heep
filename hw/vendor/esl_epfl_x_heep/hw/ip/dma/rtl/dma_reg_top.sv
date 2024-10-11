// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`


`include "common_cells/assertions.svh"

module dma_reg_top #(
    parameter type reg_req_t = logic,
    parameter type reg_rsp_t = logic,
    parameter int AW = 7
) (
    input logic clk_i,
    input logic rst_ni,
    input reg_req_t reg_req_i,
    output reg_rsp_t reg_rsp_o,
    // To HW
    output dma_reg_pkg::dma_reg2hw_t reg2hw,  // Write
    input dma_reg_pkg::dma_hw2reg_t hw2reg,  // Read


    // Config
    input devmode_i  // If 1, explicit error return for unmapped register access
);

  import dma_reg_pkg::*;

  localparam int DW = 32;
  localparam int DBW = DW / 8;  // Byte Width

  // register signals
  logic           reg_we;
  logic           reg_re;
  logic [ AW-1:0] reg_addr;
  logic [ DW-1:0] reg_wdata;
  logic [DBW-1:0] reg_be;
  logic [ DW-1:0] reg_rdata;
  logic           reg_error;

  logic addrmiss, wr_err;

  logic [DW-1:0] reg_rdata_next;

  // Below register interface can be changed
  reg_req_t reg_intf_req;
  reg_rsp_t reg_intf_rsp;


  assign reg_intf_req = reg_req_i;
  assign reg_rsp_o = reg_intf_rsp;


  assign reg_we = reg_intf_req.valid & reg_intf_req.write;
  assign reg_re = reg_intf_req.valid & ~reg_intf_req.write;
  assign reg_addr = reg_intf_req.addr;
  assign reg_wdata = reg_intf_req.wdata;
  assign reg_be = reg_intf_req.wstrb;
  assign reg_intf_rsp.rdata = reg_rdata;
  assign reg_intf_rsp.error = reg_error;
  assign reg_intf_rsp.ready = 1'b1;

  assign reg_rdata = reg_rdata_next;
  assign reg_error = (devmode_i & addrmiss) | wr_err;


  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic [31:0] src_ptr_qs;
  logic [31:0] src_ptr_wd;
  logic src_ptr_we;
  logic [31:0] dst_ptr_qs;
  logic [31:0] dst_ptr_wd;
  logic dst_ptr_we;
  logic [31:0] addr_ptr_qs;
  logic [31:0] addr_ptr_wd;
  logic addr_ptr_we;
  logic [15:0] size_d1_qs;
  logic [15:0] size_d1_wd;
  logic size_d1_we;
  logic [15:0] size_d2_qs;
  logic [15:0] size_d2_wd;
  logic size_d2_we;
  logic status_ready_qs;
  logic status_ready_re;
  logic status_window_done_qs;
  logic status_window_done_re;
  logic [5:0] src_ptr_inc_d1_qs;
  logic [5:0] src_ptr_inc_d1_wd;
  logic src_ptr_inc_d1_we;
  logic [22:0] src_ptr_inc_d2_qs;
  logic [22:0] src_ptr_inc_d2_wd;
  logic src_ptr_inc_d2_we;
  logic [5:0] dst_ptr_inc_d1_qs;
  logic [5:0] dst_ptr_inc_d1_wd;
  logic dst_ptr_inc_d1_we;
  logic [22:0] dst_ptr_inc_d2_qs;
  logic [22:0] dst_ptr_inc_d2_wd;
  logic dst_ptr_inc_d2_we;
  logic [15:0] slot_rx_trigger_slot_qs;
  logic [15:0] slot_rx_trigger_slot_wd;
  logic slot_rx_trigger_slot_we;
  logic [15:0] slot_tx_trigger_slot_qs;
  logic [15:0] slot_tx_trigger_slot_wd;
  logic slot_tx_trigger_slot_we;
  logic [1:0] src_data_type_qs;
  logic [1:0] src_data_type_wd;
  logic src_data_type_we;
  logic [1:0] dst_data_type_qs;
  logic [1:0] dst_data_type_wd;
  logic dst_data_type_we;
  logic sign_ext_qs;
  logic sign_ext_wd;
  logic sign_ext_we;
  logic [1:0] mode_qs;
  logic [1:0] mode_wd;
  logic mode_we;
  logic dim_config_qs;
  logic dim_config_wd;
  logic dim_config_we;
  logic dim_inv_qs;
  logic dim_inv_wd;
  logic dim_inv_we;
  logic [5:0] pad_top_qs;
  logic [5:0] pad_top_wd;
  logic pad_top_we;
  logic [5:0] pad_bottom_qs;
  logic [5:0] pad_bottom_wd;
  logic pad_bottom_we;
  logic [5:0] pad_right_qs;
  logic [5:0] pad_right_wd;
  logic pad_right_we;
  logic [5:0] pad_left_qs;
  logic [5:0] pad_left_wd;
  logic pad_left_we;
  logic [12:0] window_size_qs;
  logic [12:0] window_size_wd;
  logic window_size_we;
  logic [7:0] window_count_qs;
  logic interrupt_en_transaction_done_qs;
  logic interrupt_en_transaction_done_wd;
  logic interrupt_en_transaction_done_we;
  logic interrupt_en_window_done_qs;
  logic interrupt_en_window_done_wd;
  logic interrupt_en_window_done_we;
  logic transaction_ifr_qs;
  logic transaction_ifr_re;
  logic window_ifr_qs;
  logic window_ifr_re;

  // Register instances
  // R[src_ptr]: V(False)

  prim_subreg #(
      .DW      (32),
      .SWACCESS("RW"),
      .RESVAL  (32'h0)
  ) u_src_ptr (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(src_ptr_we),
      .wd(src_ptr_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.src_ptr.q),

      // to register interface (read)
      .qs(src_ptr_qs)
  );


  // R[dst_ptr]: V(False)

  prim_subreg #(
      .DW      (32),
      .SWACCESS("RW"),
      .RESVAL  (32'h0)
  ) u_dst_ptr (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(dst_ptr_we),
      .wd(dst_ptr_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.dst_ptr.q),

      // to register interface (read)
      .qs(dst_ptr_qs)
  );


  // R[addr_ptr]: V(False)

  prim_subreg #(
      .DW      (32),
      .SWACCESS("RW"),
      .RESVAL  (32'h0)
  ) u_addr_ptr (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(addr_ptr_we),
      .wd(addr_ptr_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.addr_ptr.q),

      // to register interface (read)
      .qs(addr_ptr_qs)
  );


  // R[size_d1]: V(False)

  prim_subreg #(
      .DW      (16),
      .SWACCESS("RW"),
      .RESVAL  (16'h0)
  ) u_size_d1 (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(size_d1_we),
      .wd(size_d1_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(reg2hw.size_d1.qe),
      .q (reg2hw.size_d1.q),

      // to register interface (read)
      .qs(size_d1_qs)
  );


  // R[size_d2]: V(False)

  prim_subreg #(
      .DW      (16),
      .SWACCESS("RW"),
      .RESVAL  (16'h0)
  ) u_size_d2 (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(size_d2_we),
      .wd(size_d2_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.size_d2.q),

      // to register interface (read)
      .qs(size_d2_qs)
  );


  // R[status]: V(True)

  //   F[ready]: 0:0
  prim_subreg_ext #(
      .DW(1)
  ) u_status_ready (
      .re (status_ready_re),
      .we (1'b0),
      .wd ('0),
      .d  (hw2reg.status.ready.d),
      .qre(reg2hw.status.ready.re),
      .qe (),
      .q  (reg2hw.status.ready.q),
      .qs (status_ready_qs)
  );


  //   F[window_done]: 1:1
  prim_subreg_ext #(
      .DW(1)
  ) u_status_window_done (
      .re (status_window_done_re),
      .we (1'b0),
      .wd ('0),
      .d  (hw2reg.status.window_done.d),
      .qre(reg2hw.status.window_done.re),
      .qe (),
      .q  (reg2hw.status.window_done.q),
      .qs (status_window_done_qs)
  );


  // R[src_ptr_inc_d1]: V(False)

  prim_subreg #(
      .DW      (6),
      .SWACCESS("RW"),
      .RESVAL  (6'h4)
  ) u_src_ptr_inc_d1 (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(src_ptr_inc_d1_we),
      .wd(src_ptr_inc_d1_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.src_ptr_inc_d1.q),

      // to register interface (read)
      .qs(src_ptr_inc_d1_qs)
  );


  // R[src_ptr_inc_d2]: V(False)

  prim_subreg #(
      .DW      (23),
      .SWACCESS("RW"),
      .RESVAL  (23'h4)
  ) u_src_ptr_inc_d2 (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(src_ptr_inc_d2_we),
      .wd(src_ptr_inc_d2_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.src_ptr_inc_d2.q),

      // to register interface (read)
      .qs(src_ptr_inc_d2_qs)
  );


  // R[dst_ptr_inc_d1]: V(False)

  prim_subreg #(
      .DW      (6),
      .SWACCESS("RW"),
      .RESVAL  (6'h4)
  ) u_dst_ptr_inc_d1 (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(dst_ptr_inc_d1_we),
      .wd(dst_ptr_inc_d1_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.dst_ptr_inc_d1.q),

      // to register interface (read)
      .qs(dst_ptr_inc_d1_qs)
  );


  // R[dst_ptr_inc_d2]: V(False)

  prim_subreg #(
      .DW      (23),
      .SWACCESS("RW"),
      .RESVAL  (23'h4)
  ) u_dst_ptr_inc_d2 (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(dst_ptr_inc_d2_we),
      .wd(dst_ptr_inc_d2_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.dst_ptr_inc_d2.q),

      // to register interface (read)
      .qs(dst_ptr_inc_d2_qs)
  );


  // R[slot]: V(False)

  //   F[rx_trigger_slot]: 15:0
  prim_subreg #(
      .DW      (16),
      .SWACCESS("RW"),
      .RESVAL  (16'h0)
  ) u_slot_rx_trigger_slot (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(slot_rx_trigger_slot_we),
      .wd(slot_rx_trigger_slot_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.slot.rx_trigger_slot.q),

      // to register interface (read)
      .qs(slot_rx_trigger_slot_qs)
  );


  //   F[tx_trigger_slot]: 31:16
  prim_subreg #(
      .DW      (16),
      .SWACCESS("RW"),
      .RESVAL  (16'h0)
  ) u_slot_tx_trigger_slot (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(slot_tx_trigger_slot_we),
      .wd(slot_tx_trigger_slot_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.slot.tx_trigger_slot.q),

      // to register interface (read)
      .qs(slot_tx_trigger_slot_qs)
  );


  // R[src_data_type]: V(False)

  prim_subreg #(
      .DW      (2),
      .SWACCESS("RW"),
      .RESVAL  (2'h0)
  ) u_src_data_type (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(src_data_type_we),
      .wd(src_data_type_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.src_data_type.q),

      // to register interface (read)
      .qs(src_data_type_qs)
  );


  // R[dst_data_type]: V(False)

  prim_subreg #(
      .DW      (2),
      .SWACCESS("RW"),
      .RESVAL  (2'h0)
  ) u_dst_data_type (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(dst_data_type_we),
      .wd(dst_data_type_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.dst_data_type.q),

      // to register interface (read)
      .qs(dst_data_type_qs)
  );


  // R[sign_ext]: V(False)

  prim_subreg #(
      .DW      (1),
      .SWACCESS("RW"),
      .RESVAL  (1'h0)
  ) u_sign_ext (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(sign_ext_we),
      .wd(sign_ext_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.sign_ext.q),

      // to register interface (read)
      .qs(sign_ext_qs)
  );


  // R[mode]: V(False)

  prim_subreg #(
      .DW      (2),
      .SWACCESS("RW"),
      .RESVAL  (2'h0)
  ) u_mode (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(mode_we),
      .wd(mode_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.mode.q),

      // to register interface (read)
      .qs(mode_qs)
  );


  // R[dim_config]: V(False)

  prim_subreg #(
      .DW      (1),
      .SWACCESS("RW"),
      .RESVAL  (1'h0)
  ) u_dim_config (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(dim_config_we),
      .wd(dim_config_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.dim_config.q),

      // to register interface (read)
      .qs(dim_config_qs)
  );


  // R[dim_inv]: V(False)

  prim_subreg #(
      .DW      (1),
      .SWACCESS("RW"),
      .RESVAL  (1'h0)
  ) u_dim_inv (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(dim_inv_we),
      .wd(dim_inv_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.dim_inv.q),

      // to register interface (read)
      .qs(dim_inv_qs)
  );


  // R[pad_top]: V(False)

  prim_subreg #(
      .DW      (6),
      .SWACCESS("RW"),
      .RESVAL  (6'h0)
  ) u_pad_top (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(pad_top_we),
      .wd(pad_top_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.pad_top.q),

      // to register interface (read)
      .qs(pad_top_qs)
  );


  // R[pad_bottom]: V(False)

  prim_subreg #(
      .DW      (6),
      .SWACCESS("RW"),
      .RESVAL  (6'h0)
  ) u_pad_bottom (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(pad_bottom_we),
      .wd(pad_bottom_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.pad_bottom.q),

      // to register interface (read)
      .qs(pad_bottom_qs)
  );


  // R[pad_right]: V(False)

  prim_subreg #(
      .DW      (6),
      .SWACCESS("RW"),
      .RESVAL  (6'h0)
  ) u_pad_right (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(pad_right_we),
      .wd(pad_right_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.pad_right.q),

      // to register interface (read)
      .qs(pad_right_qs)
  );


  // R[pad_left]: V(False)

  prim_subreg #(
      .DW      (6),
      .SWACCESS("RW"),
      .RESVAL  (6'h0)
  ) u_pad_left (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(pad_left_we),
      .wd(pad_left_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.pad_left.q),

      // to register interface (read)
      .qs(pad_left_qs)
  );


  // R[window_size]: V(False)

  prim_subreg #(
      .DW      (13),
      .SWACCESS("RW"),
      .RESVAL  (13'h0)
  ) u_window_size (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(window_size_we),
      .wd(window_size_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.window_size.q),

      // to register interface (read)
      .qs(window_size_qs)
  );


  // R[window_count]: V(False)

  prim_subreg #(
      .DW      (8),
      .SWACCESS("RO"),
      .RESVAL  (8'h0)
  ) u_window_count (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      .we(1'b0),
      .wd('0),

      // from internal hardware
      .de(hw2reg.window_count.de),
      .d (hw2reg.window_count.d),

      // to internal hardware
      .qe(),
      .q (reg2hw.window_count.q),

      // to register interface (read)
      .qs(window_count_qs)
  );


  // R[interrupt_en]: V(False)

  //   F[transaction_done]: 0:0
  prim_subreg #(
      .DW      (1),
      .SWACCESS("RW"),
      .RESVAL  (1'h0)
  ) u_interrupt_en_transaction_done (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(interrupt_en_transaction_done_we),
      .wd(interrupt_en_transaction_done_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.interrupt_en.transaction_done.q),

      // to register interface (read)
      .qs(interrupt_en_transaction_done_qs)
  );


  //   F[window_done]: 1:1
  prim_subreg #(
      .DW      (1),
      .SWACCESS("RW"),
      .RESVAL  (1'h0)
  ) u_interrupt_en_window_done (
      .clk_i (clk_i),
      .rst_ni(rst_ni),

      // from register interface
      .we(interrupt_en_window_done_we),
      .wd(interrupt_en_window_done_wd),

      // from internal hardware
      .de(1'b0),
      .d ('0),

      // to internal hardware
      .qe(),
      .q (reg2hw.interrupt_en.window_done.q),

      // to register interface (read)
      .qs(interrupt_en_window_done_qs)
  );


  // R[transaction_ifr]: V(True)

  prim_subreg_ext #(
      .DW(1)
  ) u_transaction_ifr (
      .re (transaction_ifr_re),
      .we (1'b0),
      .wd ('0),
      .d  (hw2reg.transaction_ifr.d),
      .qre(reg2hw.transaction_ifr.re),
      .qe (),
      .q  (reg2hw.transaction_ifr.q),
      .qs (transaction_ifr_qs)
  );


  // R[window_ifr]: V(True)

  prim_subreg_ext #(
      .DW(1)
  ) u_window_ifr (
      .re (window_ifr_re),
      .we (1'b0),
      .wd ('0),
      .d  (hw2reg.window_ifr.d),
      .qre(reg2hw.window_ifr.re),
      .qe (),
      .q  (reg2hw.window_ifr.q),
      .qs (window_ifr_qs)
  );




  logic [25:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[0] = (reg_addr == DMA_SRC_PTR_OFFSET);
    addr_hit[1] = (reg_addr == DMA_DST_PTR_OFFSET);
    addr_hit[2] = (reg_addr == DMA_ADDR_PTR_OFFSET);
    addr_hit[3] = (reg_addr == DMA_SIZE_D1_OFFSET);
    addr_hit[4] = (reg_addr == DMA_SIZE_D2_OFFSET);
    addr_hit[5] = (reg_addr == DMA_STATUS_OFFSET);
    addr_hit[6] = (reg_addr == DMA_SRC_PTR_INC_D1_OFFSET);
    addr_hit[7] = (reg_addr == DMA_SRC_PTR_INC_D2_OFFSET);
    addr_hit[8] = (reg_addr == DMA_DST_PTR_INC_D1_OFFSET);
    addr_hit[9] = (reg_addr == DMA_DST_PTR_INC_D2_OFFSET);
    addr_hit[10] = (reg_addr == DMA_SLOT_OFFSET);
    addr_hit[11] = (reg_addr == DMA_SRC_DATA_TYPE_OFFSET);
    addr_hit[12] = (reg_addr == DMA_DST_DATA_TYPE_OFFSET);
    addr_hit[13] = (reg_addr == DMA_SIGN_EXT_OFFSET);
    addr_hit[14] = (reg_addr == DMA_MODE_OFFSET);
    addr_hit[15] = (reg_addr == DMA_DIM_CONFIG_OFFSET);
    addr_hit[16] = (reg_addr == DMA_DIM_INV_OFFSET);
    addr_hit[17] = (reg_addr == DMA_PAD_TOP_OFFSET);
    addr_hit[18] = (reg_addr == DMA_PAD_BOTTOM_OFFSET);
    addr_hit[19] = (reg_addr == DMA_PAD_RIGHT_OFFSET);
    addr_hit[20] = (reg_addr == DMA_PAD_LEFT_OFFSET);
    addr_hit[21] = (reg_addr == DMA_WINDOW_SIZE_OFFSET);
    addr_hit[22] = (reg_addr == DMA_WINDOW_COUNT_OFFSET);
    addr_hit[23] = (reg_addr == DMA_INTERRUPT_EN_OFFSET);
    addr_hit[24] = (reg_addr == DMA_TRANSACTION_IFR_OFFSET);
    addr_hit[25] = (reg_addr == DMA_WINDOW_IFR_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(DMA_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(DMA_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(DMA_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(DMA_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(DMA_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(DMA_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(DMA_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(DMA_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(DMA_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(DMA_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(DMA_PERMIT[10] & ~reg_be))) |
               (addr_hit[11] & (|(DMA_PERMIT[11] & ~reg_be))) |
               (addr_hit[12] & (|(DMA_PERMIT[12] & ~reg_be))) |
               (addr_hit[13] & (|(DMA_PERMIT[13] & ~reg_be))) |
               (addr_hit[14] & (|(DMA_PERMIT[14] & ~reg_be))) |
               (addr_hit[15] & (|(DMA_PERMIT[15] & ~reg_be))) |
               (addr_hit[16] & (|(DMA_PERMIT[16] & ~reg_be))) |
               (addr_hit[17] & (|(DMA_PERMIT[17] & ~reg_be))) |
               (addr_hit[18] & (|(DMA_PERMIT[18] & ~reg_be))) |
               (addr_hit[19] & (|(DMA_PERMIT[19] & ~reg_be))) |
               (addr_hit[20] & (|(DMA_PERMIT[20] & ~reg_be))) |
               (addr_hit[21] & (|(DMA_PERMIT[21] & ~reg_be))) |
               (addr_hit[22] & (|(DMA_PERMIT[22] & ~reg_be))) |
               (addr_hit[23] & (|(DMA_PERMIT[23] & ~reg_be))) |
               (addr_hit[24] & (|(DMA_PERMIT[24] & ~reg_be))) |
               (addr_hit[25] & (|(DMA_PERMIT[25] & ~reg_be)))));
  end

  assign src_ptr_we = addr_hit[0] & reg_we & !reg_error;
  assign src_ptr_wd = reg_wdata[31:0];

  assign dst_ptr_we = addr_hit[1] & reg_we & !reg_error;
  assign dst_ptr_wd = reg_wdata[31:0];

  assign addr_ptr_we = addr_hit[2] & reg_we & !reg_error;
  assign addr_ptr_wd = reg_wdata[31:0];

  assign size_d1_we = addr_hit[3] & reg_we & !reg_error;
  assign size_d1_wd = reg_wdata[15:0];

  assign size_d2_we = addr_hit[4] & reg_we & !reg_error;
  assign size_d2_wd = reg_wdata[15:0];

  assign status_ready_re = addr_hit[5] & reg_re & !reg_error;

  assign status_window_done_re = addr_hit[5] & reg_re & !reg_error;

  assign src_ptr_inc_d1_we = addr_hit[6] & reg_we & !reg_error;
  assign src_ptr_inc_d1_wd = reg_wdata[5:0];

  assign src_ptr_inc_d2_we = addr_hit[7] & reg_we & !reg_error;
  assign src_ptr_inc_d2_wd = reg_wdata[22:0];

  assign dst_ptr_inc_d1_we = addr_hit[8] & reg_we & !reg_error;
  assign dst_ptr_inc_d1_wd = reg_wdata[5:0];

  assign dst_ptr_inc_d2_we = addr_hit[9] & reg_we & !reg_error;
  assign dst_ptr_inc_d2_wd = reg_wdata[22:0];

  assign slot_rx_trigger_slot_we = addr_hit[10] & reg_we & !reg_error;
  assign slot_rx_trigger_slot_wd = reg_wdata[15:0];

  assign slot_tx_trigger_slot_we = addr_hit[10] & reg_we & !reg_error;
  assign slot_tx_trigger_slot_wd = reg_wdata[31:16];

  assign src_data_type_we = addr_hit[11] & reg_we & !reg_error;
  assign src_data_type_wd = reg_wdata[1:0];

  assign dst_data_type_we = addr_hit[12] & reg_we & !reg_error;
  assign dst_data_type_wd = reg_wdata[1:0];

  assign sign_ext_we = addr_hit[13] & reg_we & !reg_error;
  assign sign_ext_wd = reg_wdata[0];

  assign mode_we = addr_hit[14] & reg_we & !reg_error;
  assign mode_wd = reg_wdata[1:0];

  assign dim_config_we = addr_hit[15] & reg_we & !reg_error;
  assign dim_config_wd = reg_wdata[0];

  assign dim_inv_we = addr_hit[16] & reg_we & !reg_error;
  assign dim_inv_wd = reg_wdata[0];

  assign pad_top_we = addr_hit[17] & reg_we & !reg_error;
  assign pad_top_wd = reg_wdata[5:0];

  assign pad_bottom_we = addr_hit[18] & reg_we & !reg_error;
  assign pad_bottom_wd = reg_wdata[5:0];

  assign pad_right_we = addr_hit[19] & reg_we & !reg_error;
  assign pad_right_wd = reg_wdata[5:0];

  assign pad_left_we = addr_hit[20] & reg_we & !reg_error;
  assign pad_left_wd = reg_wdata[5:0];

  assign window_size_we = addr_hit[21] & reg_we & !reg_error;
  assign window_size_wd = reg_wdata[12:0];

  assign interrupt_en_transaction_done_we = addr_hit[23] & reg_we & !reg_error;
  assign interrupt_en_transaction_done_wd = reg_wdata[0];

  assign interrupt_en_window_done_we = addr_hit[23] & reg_we & !reg_error;
  assign interrupt_en_window_done_wd = reg_wdata[1];

  assign transaction_ifr_re = addr_hit[24] & reg_re & !reg_error;

  assign window_ifr_re = addr_hit[25] & reg_re & !reg_error;

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[31:0] = src_ptr_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[31:0] = dst_ptr_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[31:0] = addr_ptr_qs;
      end

      addr_hit[3]: begin
        reg_rdata_next[15:0] = size_d1_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[15:0] = size_d2_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = status_ready_qs;
        reg_rdata_next[1] = status_window_done_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[5:0] = src_ptr_inc_d1_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[22:0] = src_ptr_inc_d2_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[5:0] = dst_ptr_inc_d1_qs;
      end

      addr_hit[9]: begin
        reg_rdata_next[22:0] = dst_ptr_inc_d2_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[15:0]  = slot_rx_trigger_slot_qs;
        reg_rdata_next[31:16] = slot_tx_trigger_slot_qs;
      end

      addr_hit[11]: begin
        reg_rdata_next[1:0] = src_data_type_qs;
      end

      addr_hit[12]: begin
        reg_rdata_next[1:0] = dst_data_type_qs;
      end

      addr_hit[13]: begin
        reg_rdata_next[0] = sign_ext_qs;
      end

      addr_hit[14]: begin
        reg_rdata_next[1:0] = mode_qs;
      end

      addr_hit[15]: begin
        reg_rdata_next[0] = dim_config_qs;
      end

      addr_hit[16]: begin
        reg_rdata_next[0] = dim_inv_qs;
      end

      addr_hit[17]: begin
        reg_rdata_next[5:0] = pad_top_qs;
      end

      addr_hit[18]: begin
        reg_rdata_next[5:0] = pad_bottom_qs;
      end

      addr_hit[19]: begin
        reg_rdata_next[5:0] = pad_right_qs;
      end

      addr_hit[20]: begin
        reg_rdata_next[5:0] = pad_left_qs;
      end

      addr_hit[21]: begin
        reg_rdata_next[12:0] = window_size_qs;
      end

      addr_hit[22]: begin
        reg_rdata_next[7:0] = window_count_qs;
      end

      addr_hit[23]: begin
        reg_rdata_next[0] = interrupt_en_transaction_done_qs;
        reg_rdata_next[1] = interrupt_en_window_done_qs;
      end

      addr_hit[24]: begin
        reg_rdata_next[0] = transaction_ifr_qs;
      end

      addr_hit[25]: begin
        reg_rdata_next[0] = window_ifr_qs;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // Unused signal tieoff

  // wdata / byte enable are not always fully used
  // add a blanket unused statement to handle lint waivers
  logic unused_wdata;
  logic unused_be;
  assign unused_wdata = ^reg_wdata;
  assign unused_be = ^reg_be;

  // Assertions for Register Interface
  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit))

endmodule

module dma_reg_top_intf #(
    parameter  int AW = 7,
    localparam int DW = 32
) (
    input logic clk_i,
    input logic rst_ni,
    REG_BUS.in regbus_slave,
    // To HW
    output dma_reg_pkg::dma_reg2hw_t reg2hw,  // Write
    input dma_reg_pkg::dma_hw2reg_t hw2reg,  // Read
    // Config
    input devmode_i  // If 1, explicit error return for unmapped register access
);
  localparam int unsigned STRB_WIDTH = DW / 8;

  `include "register_interface/typedef.svh"
  `include "register_interface/assign.svh"

  // Define structs for reg_bus
  typedef logic [AW-1:0] addr_t;
  typedef logic [DW-1:0] data_t;
  typedef logic [STRB_WIDTH-1:0] strb_t;
  `REG_BUS_TYPEDEF_ALL(reg_bus, addr_t, data_t, strb_t)

  reg_bus_req_t s_reg_req;
  reg_bus_rsp_t s_reg_rsp;

  // Assign SV interface to structs
  `REG_BUS_ASSIGN_TO_REQ(s_reg_req, regbus_slave)
  `REG_BUS_ASSIGN_FROM_RSP(regbus_slave, s_reg_rsp)



  dma_reg_top #(
      .reg_req_t(reg_bus_req_t),
      .reg_rsp_t(reg_bus_rsp_t),
      .AW(AW)
  ) i_regs (
      .clk_i,
      .rst_ni,
      .reg_req_i(s_reg_req),
      .reg_rsp_o(s_reg_rsp),
      .reg2hw,  // Write
      .hw2reg,  // Read
      .devmode_i
  );

endmodule


