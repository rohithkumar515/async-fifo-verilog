module asyn_fifo_tb;
reg wclk,rclk,rst,wen,ren;
reg [7:0]din;
wire [7:0]dout;
wire full,empty;
integer i;
asyn_fifo h1(.wclk(wclk),.rclk(rclk),.rst(rst),.wen(wen),.ren(ren),.din(din),.dout(dout),.full(full),.empty(empty));
always #5 wclk=~wclk;
always #7 rclk=~rclk;
initial
begin
wclk=0;rclk=0;rst=1;
din=10;
#10;
rst=0;

ren=0;
for(i=0;i<=8;i=i+1)begin
@(posedge wclk);
wen=1;
din=$random;
@(posedge wclk);
wen=0;

end
#10;
wen=0;
ren=1;
//for(i=0;i<=7;i=i+1)begin
//r_ptr=i;
//@(posedge clk);
//end
#300 $stop;
end
endmodule