module Master(
	clk, reset,
	start, slaveSelect, masterDataToSend, masterDataReceived,
	SCLK, CS, MOSI, MISO
);

//    Inputs  & outputs

input clk,reset,start,MISO;
input [1:0] slaveSelect;
input [7:0] masterDataToSend;


output SCLK,MOSI;
output [0:2] CS;
output [7:0] masterDataReceived;

//     Reg  & wire

reg [3:0] Counter;
reg MOSI;
reg [7:0] masterDataReceived;
reg Start_Signal;
//reg SCLK;

wire SCLK;
wire [3:0] Counter_next;
wire MISO;
wire [0:2] CS;

// using Counter to determine the bit which will be transmitted and Stop Transmission after ALL Data be sent
always @(*)
begin
	if (start == 1 || (Counter > 0&& Counter < 8))
	//if((start == 1 && Counter ==0) || Counter < 8 )
	begin
		Start_Signal <= 1;
	end
	else
	begin
		Start_Signal <= 0;
		Counter =0;
	end
end

// Generate SCLK from CLk

assign SCLK = (Start_Signal)? clk : 0;

// Determine CS to send from SelectSlave
assign CS = (Start_Signal == 0)? 3'b111:
	    (slaveSelect == 0)? 3'b011:
	    (slaveSelect == 1)? 3'b101:
	    (slaveSelect == 2)? 3'b110:3'b111;

always @(posedge SCLK,posedge reset)
	begin
		if(reset)
			begin 
				Counter <= 0;
				masterDataReceived = 0;
				
			end
		else
			begin
				if(Counter<8)
				begin
					MOSI <= masterDataToSend[Counter];
					//Counter <= Counter_next;
				end
				else
				begin
					Counter = 0;
				end
			end
	end	

always @(negedge SCLK,posedge reset)
	begin
		if(reset)
			begin
				Counter <= 0;
			end
		else
			begin
				if(Counter<8)
				begin
					masterDataReceived [Counter] <= MISO;
					Counter <= Counter_next;
				end
				else
				begin
					Counter = 0;
				end
			end
	end	



assign Counter_next = (Start_Signal)? Counter+1:3'b0; 


endmodule