module praffulweek4(
    output reg [3:0] anode, 
    output reg [6:0] LED_out
    input clock, 
    input reset, 
    
    );
    wire [3:0] dout1,dout2;
    wire [3:0] din1,din2;
    wire enable2;
    reg [3:0] led_bcd;
    reg [19:0] re_counter;         
    wire [1:0] led_count;
    reg [2:0] address1;
    reg [7:0] sum,count;
    reg [26:0] counter2; 
    reg [15:0] shown_number; 
    reg ena1,ena2;
    reg wea1,wea2;
blk_mem_gen_0 praffulmem1 (
  .clka(clock),    // input wire clka
  .ena(ena1),      // input wire ena
  .wea(wea1),      // input wire [0 : 0] wea
  .addra(address1),  // input wire [2 : 0] addra
  .dina(din1),    // input wire [3 : 0] dina
  .douta(dout1)  // output wire [3 : 0] douta
);

blk_mem_gen_1 praffulmem2 (
  .clka(clock),    // input wire clka
  .ena(ena2),      // input wire ena
  .wea(wea2),      // input wire [0 : 0] wea
  .addra(address1),  // input wire [2 : 0] addra
  .dina(din2),    // input wire [3 : 0] dina
  .douta(dout2)  // output wire [3 : 0] douta
);

initial
begin
wea1=1'd0; 
wea2=1'd0;
ena1=1'd1;
ena2=1'd1;
sum=1'd0;
count=1'd0;
address1=3'd0;
end


always@(negedge clock)
begin
if(reset)
begin
sum=1'd0;
address1=3'd0;
end
else
begin
address1=address1+3'd1;
count=count+1'd1;
end	
begin
if(count >= 3 && count<11)
   sum=sum+dout1+dout2;
if(count>=11)
	begin
	address1=3'd0;
	count=11;
	end
end	
end         
always @(posedge clock or posedge reset)
    begin
     if(reset==1)
     counter2<= 0;
     else begin
     if(counter2>=99999999) 
     counter2 <= 0;
     else
     counter2 <= counter2 + 1'd1;
     end
     end 
     assign enable2 = (counter2==99999999)?1:0;
      always @(posedge clock or posedge reset)
      begin
      if(reset==1)
      shown_number <= 0;
      else if(enable2==1)
      shown_number <= sum ;
      end
      always @(posedge clock or posedge reset)
      begin 
      if(reset==1)
      re_counter <= 0;
      else
      re_counter <= re_counter + 1;
      end 
      assign led_count= re_counter[19:18];
 
    always @(*)
    begin
        case(led_count)
        2'd0: begin
            anode = 4'b0111; 
            led_bcd = shown_number/1000;
              end
        2'd1: begin
            anode = 4'b1011; 
            led_bcd = (shown_number % 1000)/100;
              end
        2'd2: begin
            anode = 4'b1101; 
            led_bcd = ((shown_number % 1000)%100)/10;
                end
        2'd3: begin
            anode = 4'b1110; 
            led_bcd = ((shown_number % 1000)%100)%10;  
               end
        endcase
    end
    always @(*)
    begin
        case(led_bcd)
        4'b0000 : LED_out = 7'b0000001; // "0"     
        4'b0001 : LED_out = 7'b1001111; // "1" 
        4'b0010 : LED_out = 7'b0010010; // "2" 
        4'b0011 : LED_out = 7'b0000110; // "3" 
        4'b0100 : LED_out = 7'b1001100; // "4" 
        4'b0101 : LED_out = 7'b0100100; // "5" 
        4'b0110 : LED_out = 7'b0100000; // "6" 
        4'b0111 : LED_out = 7'b0001111; // "7" 
        4'b1000 : LED_out = 7'b0000000; // "8"     
        4'b1001 : LED_out = 7'b0000100; // "9" 
        default : LED_out = 7'b0000001; // "0"
        endcase
    end
 endmodule