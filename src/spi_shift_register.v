
`include "spi_define.v"

module spi_shift_register(rx_negedge,
                     tx_negedge,
                     byte_sel,
                     latch,
                     len,
                     p_in,
                     wb_clk_in,
                     wb_rst,
                     go,
                     miso,
                     lsb,
                     sclk,
                     cpol_0,
                     cpol_1,
                     p_out,
                     last,
                     mosi,
                     tip);

    input   rx_negedge,
            tx_negedge,
            wb_clk_in,
            wb_rst,
            go,miso,
            lsb,
            sclk,
            cpol_0,
            cpol_1;

    input [3:0] byte_sel,latch;
    input [`SPI_CHAR_LEN_BITS-1:0] len;
    input [31:0] p_in;

    output [`SPI_MAX_CHAR-1:0] p_out;
    output reg tip,mosi;
    output last;

    reg [`SPI_CHAR_LEN_BITS:0] char_count;  
    reg [`SPI_MAX_CHAR-1:0] master_data;    
    reg [`SPI_CHAR_LEN_BITS:0] tx_bit_pos;  
    reg [`SPI_CHAR_LEN_BITS:0] rx_bit_pos;  
    wire rx_clk;                            
    wire tx_clk;                            


always@(posedge wb_clk_in or posedge wb_rst)
begin
  if(wb_rst)
    begin
      char_count <= 0;
    end
  else
    begin
      if(tip)
        begin
          if(cpol_0)
            begin
              char_count <= char_count - 1;
            end
        end
      else
        char_count <= {1'b0,len}; 
    end
end


always@(posedge wb_clk_in or posedge wb_rst)
begin
  if(wb_rst)
    begin
      tip <= 0;
    end
  else
    begin
      if(go && ~tip)
        begin
          tip <= 1;
        end
      else if(last && tip && cpol_0)
        begin
          tip <= 0;
        end
    end
end


assign last = ~(|char_count);


always@(posedge wb_clk_in or posedge wb_rst)
begin
  if(wb_rst)
    begin
      mosi <= 0;
    end
  else
    begin
      if(tx_clk)
        begin
          mosi <= master_data[tx_bit_pos[`SPI_CHAR_LEN_BITS-1:0]];
        end
    end
end


assign tx_clk = ((tx_negedge)?cpol_1 : cpol_0) && !last;
assign rx_clk = ((rx_negedge)?cpol_1 : cpol_0) && (!last || sclk);


always@(lsb,len,char_count)
begin
  if(lsb)
    begin
      tx_bit_pos = ({~{|len},len}-char_count);
    end
  else
    begin
      tx_bit_pos = char_count-1;
    end
end


always@(lsb,len,rx_negedge,char_count)
begin
  if(lsb)
    begin
      if(rx_negedge)
        rx_bit_pos = {~(|len),len}-(char_count+1);
      else
        rx_bit_pos = {~(|len),len}-char_count;
    end
  else
    begin
      if(rx_negedge)
        begin
          rx_bit_pos = char_count;
        end
      else
        begin
          rx_bit_pos = char_count-1;
        end
    end
end


assign p_out = master_data;


always@(posedge wb_clk_in or posedge wb_rst)
begin
  if(wb_rst)
    master_data <= {`SPI_MAX_CHAR{1'b0}};

    // Recieving bits from the parallel line
    `ifdef SPI_MAX_CHAR_128
      else if(latch[0] && !tip) // TX0 is selected
        begin
          if(byte_sel[0])
            begin
             master_data[7:0] <= p_in[7:0];
            end
          if(byte_sel[1])
            begin
             master_data[15:8] <= p_in[15:8];
            end
          if(byte_sel[2])
            begin
             master_data[23:16] <= p_in[23:16];
            end
          if(byte_sel[3])
            begin
             master_data[31:24] <= p_in[31:24];
            end
        end
      else if(latch[1] && !tip) // TX1 is selected
        begin
          if(byte_sel[0])
            begin
              master_data[39:32] <= p_in[7:0];
            end
          if(byte_sel[1])
            begin
              master_data[47:40] <= p_in[15:8];
            end
          if(byte_sel[2])
            begin
              master_data[55:48] <= p_in[23:16];
            end
          if(byte_sel[3])
            begin
              master_data[63:56] <= p_in[31:24];
            end
        end
      else if(latch[2] && !tip) // TX2 is selected
        begin
          if(byte_sel[0])
            begin
              master_data[71:64] <= p_in[7:0];
            end
          if(byte_sel[1])
            begin
              master_data[79:72] <= p_in[15:8];
            end
          if(byte_sel[2])
            begin
              master_data[87:80] <= p_in[23:16];
            end
          if(byte_sel[3])
            begin
              master_data[95:88] <= p_in[31:24];
            end
        end
      else if(latch[3] && !tip) 
        begin
          if(byte_sel[0])
            begin
              master_data[103:96] <= p_in[7:0];
            end
          if(byte_sel[1])
            begin
              master_data[111:104] <= p_in[15:8];
            end
          if(byte_sel[2])
            begin
              master_data[119:112] <= p_in[23:16];
            end
          if(byte_sel[3])
            begin
              master_data[127:120] <= p_in[31:24];
            end
        end
    `else
    `ifdef SPI_MAX_CHAR_64
      else if(latch[0] && !tip) 
        begin
          if(byte_sel[0])
            begin
             master_data[7:0] <= p_in[7:0];
            end
          if(byte_sel[1])
            begin
             master_data[15:8] <= p_in[15:8];
            end
          if(byte_sel[2])
            begin
             master_data[23:16] <= p_in[23:16];
            end
          if(byte_sel[3])
            begin
             master_data[31:24] <= p_in[31:24];
            end
        end
      else if(latch[1] && !tip) 
        begin
          if(byte_sel[0])
            begin
              master_data[39:32] <= p_in[7:0];
            end
          if(byte_sel[1])
            begin
              master_data[47:40] <= p_in[15:8];
            end
          if(byte_sel[2])
            begin
              master_data[55:48] <= p_in[23:16];
            end
          if(byte_sel[3])
            begin
              master_data[63:56] <= p_in[31:24];
            end
        end
    `else
      else if(latch[0] && !tip) //TX0 is selected
        begin

          `ifdef SPI_MAX_CHAR_8
            if(byte_sel[0])
              begin
                master_data[7:0] <= p_in[7:0];
              end
          `endif

          `ifdef SPI_MAX_CHAR_16
            if(byte_sel[0])
              begin
                master_data[7:0] <= p_in[7:0];
              end
            if(byte_sel[1])
              begin
                master_data[15:8] <= p_in[15:8];
              end
          `endif

          `ifdef SPI_MAX_CHAR_24
            if(byte_sel[0])
              begin
                master_data[7:0] <= p_in[7:0];
              end
            if(byte_sel[1])
              begin
                master_data[15:8] <= p_in[15:8];
              end
            if(byte_sel[2])
              begin
                master_data[23:16] <= p_in[23:16];
              end
          `endif

          `ifdef SPI_MAX_CHAR_32
            if(byte_sel[0])
              begin
                master_data[7:0] <= p_in[7:0];
               end
            if(byte_sel[1])
              begin
                master_data[15:8] <= p_in[15:8];
              end
            if(byte_sel[2])
              begin
                master_data[23:16] <= p_in[23:16];
              end
            if(byte_sel[3])
              begin
                master_data[31:24] <= p_in[31:24];
              end
          `endif
        end
      `endif
    `endif

    
    else
      begin
        if(rx_clk)
          master_data[rx_bit_pos[`SPI_CHAR_LEN_BITS-1:0]] <= miso;
        end
    end
endmodule