   module asyn_fifo(input wclk,rclk,rst,wen,ren,
                     input [7:0]din,
                     output reg[7:0]dout,
                     output full,empty);
                     reg [7:0]mem[7:0]; // declaration of fifo memory
                     reg [3:0]wptr,rptr; // declaration of write pointer and read pointer
                     reg [3:0]w1,w2,r1,r2;
                     integer i;
    always @(posedge wclk or posedge rst)begin
    if(rst) 
    begin
        wptr<=0;
        for(i=0;i<8;i=i+1) // reseting the all memory locations
        mem[i]<=0;
    end
    else if(wen && full==0)
    // here we are writing the memory
    begin
    mem[wptr]<=din;
    wptr<=wptr+1'b1; // while writing the memory write pointer is incrementing itself
    end
    end
    
    always @(posedge rclk or posedge rst)begin 
    // this block is to sent the data which is consits in memory to dout
    if(rst)
    rptr<=0;
    else if(ren && empty == 0)begin
    dout<=mem[rptr];
    rptr<=rptr+1'b1;
    end
    end
    
    //now we need to sync the rptr with wclk using d_ff
    always @(posedge wclk or posedge rst)begin
    if(rst)begin
    r1<=0;
    r2<=0;
    end
    else begin
    r1<=rptr;
    r2<=r1;
    end
    end
    
    // now we need to sync the wptr with rclk usgin d_ff
    always @(posedge rclk or posedge rst)begin
    if(rst)begin
    w1<=0;
    w2<=0;
    end
    else begin
    w1<=wptr;
    w2<=w1;
    end
    end
    assign full= ((wptr[3]^r2[3])&&(wptr[2:0]==r2[2:0]));
    assign empty=(w2==rptr);
    endmodule