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

/*reg [11:0] count_a;
reg [23:0] count_b;

// внутри кадра
wire [9:0] frame;
assign frame = count_b[9:0];

// счетчик кадров
wire [1:0] cadr;
assign cadr = count_b[11:10];

wire [8:0] offset;
assign offset = count_b[23:15]; 

wire [11:0] offset2;
assign offset2 = {0,0,0,offset}; 

wire prefix;    

always @ (posedge clk)
begin
  //if (count_a == 2776) begin // 36 kHz
  //if (count_a == 2271) begin // 22 kHz
//  if (count_a == 1999) begin // 25 kHz
//  if (count_a == 1907) begin // 26.2 kHz
  if (count_a == 1800 + offset2) begin 
    count_a <= 0;
    count_b <= count_b + 1;
  end else begin
    count_a <= count_a + 1;
  end 
end    
    
    
assign Led = count_b[23:16];    


assign prefix = (frame == 0) || (frame == 2) || (frame == 4);
assign prefix_x = (frame == 0) || (frame == 4);


// xpand 26.2 khz
//assign JB = prefix_x || (cadr[0] == 0 & (frame == 2)); 

// sony 4 token
assign JB = prefix || (cadr == 0 & ((frame == 16) || (frame == 18))) || (cadr == 1 & ((frame == 12) || (frame == 14))) || (cadr == 2 & ((frame == 24) || (frame == 26))) || (cadr == 3 & ((frame == 20) || (frame == 22))); 

//assign JB = (count_b == 0) || (count_b == 2) || (count_b == 4) || (count_b == 12) || (count_b == 14);
//assign JB = (count_b == 0) || (count_b == 2) || (count_b == 4) || (count_b == 12) || (count_b == 14);
//assign JB = (count_b == 0) || (count_b == 2) || (count_b == 4) || (count_b == 12) || (count_b == 14);
*/


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
  
// монитор кадровой развертки 
//assign ledclk = vdata[8];    
assign ledclk = rx0_de;    

    
endmodule
