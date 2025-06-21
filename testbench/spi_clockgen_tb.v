`include "spi_define.v"

module spi_clockgen_tb;

  
  reg wb_clk_in;
  reg wb_rst;
  reg go;
  reg tip;
  reg last_clk;
  wire sclk_out;
  wire cpol_0;
  wire cpol_1;
  reg [`SPI_DIVIDER_LEN-1:0] divider;

  
  spi_clockgen dut (
    .wb_clk_in(wb_clk_in),
    .wb_rst(wb_rst),
    .go(go),
    .tip(tip),
    .last_clk(last_clk),
    .divider(divider),
    .sclk_out(sclk_out),
    .cpol_0(cpol_0),
    .cpol_1(cpol_1)
  );

 
  always begin
    #5 wb_clk_in = ~wb_clk_in;
  end

  
  initial begin
    wb_clk_in <= 0;
    wb_rst <= 1;
    #13;
    wb_rst <= 0;
    divider <= 1;
    tip <= 0;
    go <= 0;
    #17;
    go <= 1;
    #10;
    tip <= 1;
    last_clk <= 0;
  end

  initial begin
    #200;
  end

endmodule
