// Verilog project: License Plate Recognition in Verilog and Matlab 
// Top level module for testing the license plate recognition system
module Test_top(input clk // 33MHz   
                               ,rst, start,  
                               output reg[5:0] led  
   );  
      reg [7:0] image_pixel_val;  
      // Outputs  
      wire done;
      wire [15:0] image_pixel_addr;  
      wire [5:0] ReadCh;  
      reg[5:0] num1,num2,num3,num4,num5,num6,num7;  
      reg [2:0] count,count_4s;  
      wire CharCheck;  
      reg clk_4s,display;  
      integer counter;  
      reg [7:0] image_inv [0:65535];  
   // Instanitate the license plate recognition system 
      LPChRec uut (  
           .clk(clk),   
           .rst(rst),   
           .start(start),  
           .image_pixel_val(image_pixel_val),  
           .image_pixel_addr(image_pixel_addr),  
           .ReadCh(ReadCh),   
           .CharCheck(CharCheck),  
           .done(done)  
      );  
   // Read License Plate Image file into FPGA 
      initial begin  
      $readmemh ("10.dat", image_inv, 0, 65535);  
      end  
      always @(posedge clk or posedge rst) // clock 4s  
      begin  
           if(rst) begin  
                clk_4s <= 1'b0;  
                counter <= 0;  
                end  
           else  
           begin  
                counter <= counter + 1;  
                if(counter <= 66000000) clk_4s <= 1'b0;  
                else if(counter > 132000000)   
                begin  
                     counter <=0;  
                end  
                else  
                clk_4s <= 1'b1;  
           end  
      end  
      always @(posedge clk)  
      begin  
           image_pixel_val <= image_inv[image_pixel_addr];            
      end  

   always @(posedge clk or posedge rst)  
      begin  
           if(rst) begin   
                count = 3'd0;  
                num1 <= 40;  
                num2 <=0;  
                num3 <= 0;  
                num4 <= 0;  
                num5 <= 0;  
                num6 <= 0;  
                display <= 0;  
                end  
           else  
           begin  
                if(CharCheck) begin  
                count = count + 1'd1;  
                if(count==3'd1)   
                     num1 <= ReadCh;  
                else if(count==3'd2)  
                     num2 <= ReadCh;  
                else if(count==3'd3)  
                     num3 <= ReadCh;  
                else if(count==3'd4)  
                     num4 <= ReadCh;  
                else if(count==3'd5)  
                     num5 <= ReadCh;  
                else if(count==3'd6)  
                     num6 <= ReadCh;  
                else if(count==3'd7)  
                     num7 <= ReadCh;  
                else begin  
                num1 <= 0;  
                num2 <=0;  
                num3 <= 0;  
                num4 <= 0;  
                num5 <= 0;  
                num6 <= 0;  
                end  
                end  
                if(done) display <= 1;  
           end  
      end  

      always @(posedge clk_4s or posedge rst) begin  
           if(rst) begin count_4s <= 0; led <=0; end  
           else begin   
           if(display) begin  
           count_4s <= count_4s + 1;  
           if(count_4s==0) led <= num1;  
           else if(count_4s==1) led <=num2;  
           else if(count_4s==2) led <=num3;  
           else if(count_4s==3) led <=num4;  
           else if(count_4s==4) led <=num5;  
           else if(count_4s==5) led <=num6;  
           else if(count_4s==6) led <=num7;  
           else count_4s <= 0;  
           end  
           end   
      end  
 endmodule  
