`timescale 1ns / 1ps

module main(
    input wire        rstbtn_n,    //The pink reset button
    input wire CLK,
    output wire ledclk,
    output [3:0] TMDS,
    output [3:0] TMDSB,
    input [3:0] RX_TMDS,
    input [3:0] RX_TMDSB,
    input wire RX_SCL,
    inout wire RX_SDA

    );

// edid
edid_rom edid_rom_rx0 (.clk(CLK), .sclk_raw(RX_SCL), .sdat_raw(RX_SDA), .edid_debug());
  

/////////////////////////
 //
 // Input Port 0
 //
 /////////////////////////
 wire rx0_pclk, rx0_pclkx2, rx0_pclkx10, rx0_pllclk0;
 wire rx0_plllckd;
 wire rx0_reset;
 wire rx0_serdesstrobe;
 wire rx0_hsync;          // hsync data
 wire rx0_vsync;          // vsync data
 wire rx0_de;             // data enable
 wire rx0_psalgnerr;      // channel phase alignment error
 wire [7:0] rx0_red;      // pixel data out
 wire [7:0] rx0_green;    // pixel data out
 wire [7:0] rx0_blue;     // pixel data out
 wire [29:0] rx0_sdata;
 wire rx0_blue_vld;
 wire rx0_green_vld;
 wire rx0_red_vld;
 wire rx0_blue_rdy;
 wire rx0_green_rdy;
 wire rx0_red_rdy;

 dvi_decoder dvi_rx0 (
   //These are input ports
   .tmdsclk_p   (RX_TMDS[3]),
   .tmdsclk_n   (RX_TMDSB[3]),
   .blue_p      (RX_TMDS[0]),
   .green_p     (RX_TMDS[1]),
   .red_p       (RX_TMDS[2]),
   .blue_n      (RX_TMDSB[0]),
   .green_n     (RX_TMDSB[1]),
   .red_n       (RX_TMDSB[2]),
   .exrst       (~rstbtn_n),

   //These are output ports
   .reset       (rx0_reset),
   .pclk        (rx0_pclk),
   .pclkx2      (rx0_pclkx2),
   .pclkx10     (rx0_pclkx10),
   .pllclk0     (rx0_pllclk0), // PLL x10 output
   .pllclk1     (rx0_pllclk1), // PLL x1 output
   .pllclk2     (rx0_pllclk2), // PLL x2 output
   .pll_lckd    (rx0_plllckd),
   .tmdsclk     (rx0_tmdsclk),
   .serdesstrobe(rx0_serdesstrobe),
   .hsync       (rx0_hsync),
   .vsync       (rx0_vsync),
   .de          (rx0_de),

   .blue_vld    (rx0_blue_vld),
   .green_vld   (rx0_green_vld),
   .red_vld     (rx0_red_vld),
   .blue_rdy    (rx0_blue_rdy),
   .green_rdy   (rx0_green_rdy),
   .red_rdy     (rx0_red_rdy),

   .psalgnerr   (rx0_psalgnerr),

   .sdout       (rx0_sdata),
   .red         (rx0_red),
   .green       (rx0_green),
   .blue        (rx0_blue)); 


dvi_out DVI (
  .reset(1'b0), 
  .clkfx(rx0_pclk), 
  
  .red_data(rx0_red[7:0]), 
  .green_data(rx0_green[7:0]),
  .blue_data(rx0_blue[7:0]),
   
  .hsync(rx0_hsync), 
  .vsync(rx0_vsync),
  .de(rx0_de),
   
  .TMDS(TMDS), 
  .TMDSB(TMDSB)
);
  
assign ledclk = rx0_de;    
    
endmodule
