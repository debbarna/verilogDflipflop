// Verilog project: License Plate Recognition in Verilog 
// Top level Verilog code for License Plate Recognition
module LPChRec(  
   input clk,  
   input rst,  
   input start,  
       input [7:0] image_pixel_val,  
       output [15:0] image_pixel_addr,  
   output [5:0] ReadCh,  
       output CharCheck,  
   output done  
   );  
 wire [7:0] ccl_th_low;  
 wire [7:0] ccl_th_high;  
 wire [7:0] image_pixel_val1;  
 wire [15:0] image_pixel_addr1;  
 wire [15:0] ImgAddr;  
 wire [7:0] ImgVal;  
 wire [7:0] ObjAddr1;  
 wire [55:0] ObjInfo;  
 wire                ccl_done,active;  
 assign ccl_th_low = 8'd40;  
 assign ccl_th_high = 8'd255;  
 assign image_pixel_addr = (active)?ImgAddr:image_pixel_addr1;  
 assign image_pixel_val1 = image_pixel_val;  
 assign ImgVal                    = image_pixel_val;  

// Image processor unit
 image_processor image_processor_inst (  
   .image_pixel_addr(image_pixel_addr1),   
   .image_pixel_val(image_pixel_val1),   
   .clk(clk),   
   .rst(rst),   
   .ccl_start(start),   
   .ccl_th_low(ccl_th_low),   
   .ccl_th_high(ccl_th_high),   
   .ccl_done(ccl_done),  
       .ccl_mem_result_addr(ObjAddr1),  
       .ccl_mem_result_data(ObjInfo)  
   );  

// Create object module 
 CreateObj CreateObjInst (  
   .clk(clk),   
   .rst(rst),   
   .start(ccl_done),   
   .thresh(ccl_th_low),   
   .ObjInfo(ObjInfo),   
   .ImgVal(ImgVal),   
   .ObjAddr1(ObjAddr1),   
   .ImgAddr(ImgAddr),  
   .Char(ReadCh),  
   .CharCheck(CharCheck),  
   .active(active),   
   .done(done)  
   );  
 endmodule  
