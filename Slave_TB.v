module Slave_TB ();

reg reset;
reg [7:0] slaveDataToSend;//input
wire [7:0] slaveDataReceived;//output 
reg SCLK;
reg CS;
reg MOSI;
wire MISO;
wire [7:0] testcase_slaveData  [1:/*TESTCASECOUNT*/4];
wire [7:0] testcase_masterData [1:/*TESTCASECOUNT*/4];
integer i,j;
reg [7:0] masterDataReceived;
localparam PERIOD = 10;
Slave UUT_S(
	reset,
	slaveDataToSend, slaveDataReceived,
	SCLK, CS, MOSI, MISO 
);
assign testcase_slaveData[1] = 8'b00000000;//data send from slave and received in master
assign testcase_slaveData[2] = 8'b11111111;
assign testcase_slaveData[3] = 8'b10000011;
assign testcase_slaveData[4] = 8'b10011010;

assign testcase_masterData[1] = 8'b00000000;//data send from master and received in slave
assign testcase_masterData[2] = 8'b11111111;
assign testcase_masterData[3] = 8'b00100000;
assign testcase_masterData[4] = 8'b01111111;

always #(PERIOD/2) SCLK = ~SCLK;

initial begin	
	SCLK = 1;
    reset = 1;
	#PERIOD	reset = 0;
    i=0;j=0;
	CS = 0;
for(i = 1; i<=4;i=i+1) 
begin
    
	$display("Running test set %d", i);
    slaveDataToSend=testcase_slaveData[i];
		for(j = 0; j<8;j=j+1) 
		begin
			#(PERIOD/2) MOSI = testcase_masterData[i][j];
			#(PERIOD/2)masterDataReceived[j]=MISO;
		end
	if(slaveDataReceived == testcase_masterData[i]) $display("From Master to Slave : Success");
	else begin
		$display("From Master to Slave : Failure (Expected: %b, Received: %b)", testcase_masterData[i], slaveDataReceived);
	end
	if(masterDataReceived == testcase_slaveData[i]) $display("From Slave to Master : Success");
	else begin
		$display("From Slave to Master : Failure (Expected: %b, Received: %b)", testcase_slaveData[i], masterDataReceived);
	end
end
 $finish;
end


endmodule

