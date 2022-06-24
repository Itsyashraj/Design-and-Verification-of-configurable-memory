module memory(
	clk_i, rst_i, addr_i, wr_rd_i, wdata_i, rdata_o, valid_i, ready_o
);
parameter WIDTH=32;
parameter SIZE=1024;
parameter DEPTH=32;
parameter ADDR_WIDTH = $clog2(DEPTH);

input clk_i, rst_i, wr_rd_i;
input [ADDR_WIDTH-1:0] addr_i;
input [WIDTH-1:0] wdata_i;
output reg [WIDTH-1:0] rdata_o;
input valid_i;
output reg ready_o;

//declare the storage
reg [WIDTH-1:0] mem [DEPTH-1:0];
integer i;

//memory funcitonality
//at every +edge clk, if reset is applied, reset the memory contents
					//else check if tx is valid, then check wr_rd, if write, do write to memory, else read memory
always @(posedge clk_i) begin
	if (rst_i == 1) begin
		ready_o = 0;
		rdata_o = 0;
		for (i = 0; i < DEPTH; i=i+1) begin
			mem[i] = 0;
		end
	end
	else begin
		if (valid_i == 1) begin
			ready_o = 1;
			if (wr_rd_i) begin
				mem[addr_i] = wdata_i;
			end
			else begin //read
				rdata_o = mem[addr_i];
			end
		end
		else begin
			ready_o = 0;
		end
	end
end
endmodule
