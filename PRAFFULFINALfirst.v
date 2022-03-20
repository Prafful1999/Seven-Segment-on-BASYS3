module praffulweek4(sum); 
wire [3:0] dout1,dout2; 
wire din; 
reg ena,wea;
reg clock;
reg [3:0] count; 
reg clear; 
reg [2:0] address;
output reg [15:0]sum; 

blk_mem_gen_0 praffulmem1 (
  .clka(clock),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(address),  // input wire [2 : 0] addra
  .dina(din),    // input wire [3 : 0] dina
  .douta(dout1)  // output wire [3 : 0] douta
);

blk_mem_gen_1 praffulmem2 (
  .clka(clock),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(address),  // input wire [2 : 0] addra
  .dina(din),    // input wire [3 : 0] dina
  .douta(dout2)  // output wire [3 : 0] douta
);

always 
#5 clock = ~clock;

initial begin
address=3'd0;
clock=3'd0;
sum=16'd0;
count=4'd0; 
end

initial 
begin
clear=1'd1;
#5;clear=1'd0;
end
initial
begin
ena=1'd1;
wea=1'd0;
address=3'd0;
end


always @(posedge clock) 
begin

if(clear)
  begin
   address=3'd0;
   sum = sum;
  end
  
else
   begin
 case(count)
 4'd10   : clear = 1'd0;
  default : 
  begin
  address=address+3'd1;
  sum=sum+dout1+dout2;
  count=count+1'd1;
  end
  endcase;
end
end
endmodule