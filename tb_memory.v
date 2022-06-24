`include "memory.v"
module tb;

parameter WIDTH=32;
parameter SIZE=1024;
parameter DEPTH=32;
parameter ADDR_WIDTH = $clog2(DEPTH);

reg clk_i, rst_i, wr_rd_i;
reg [ADDR_WIDTH-1:0] addr_i;
reg [WIDTH-1:0] wdata_i;
wire [WIDTH-1:0] rdata_o;
reg valid_i;
wire ready_o;
integer i;
reg [30*8:1] testname;

memory dut( clk_i, rst_i, addr_i, wr_rd_i, wdata_i, rdata_o, valid_i, ready_o);

initial begin
	clk_i = 0;
	forever #5 clk_i = ~clk_i;
end

initial begin
	$value$plusargs("testname=%s",testname);
	rst_i = 1;
	reset_inputs(); 
	#20;
	rst_i = 0;
	//stimulus
case (testname)
"test_wr_rd_one_location" : begin
	//write to one location
	@(posedge clk_i);
	addr_i = 5'h15;
	wr_rd_i = 1;
	wdata_i = $random;
	valid_i = 1;
	wait (ready_o == 1);
	@(posedge clk_i);
	reset_inputs();

	//read to same location
	@(posedge clk_i);
	addr_i = 5'h15;
	wr_rd_i = 0;
	valid_i = 1;
	wait (ready_o == 1);
	@(posedge clk_i);
	reset_inputs();
end
"test_mem_wr_rd_all_locations" : begin
	//Writing to all the memory
	for (i = 0; i < DEPTH; i=i+1) begin
		@(posedge clk_i);
		addr_i = i;
		wr_rd_i = 1;
		wdata_i = $random;
		valid_i = 1;
		wait (ready_o == 1);
	end
	@(posedge clk_i);
	reset_inputs();
	//Reading to all the memory
	for (i = 0; i < DEPTH; i=i+1) begin
		@(posedge clk_i);
		addr_i = i;
		wr_rd_i = 0;
		valid_i = 1;
		wait (ready_o == 1);
	end
