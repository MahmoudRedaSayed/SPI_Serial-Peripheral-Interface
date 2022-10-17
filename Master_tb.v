`include"Master.v"
module Master_tb();

//input to the master
reg clk, Reset, Start, Miso;
reg [1:0] SalveSelect;
reg [7:0] MasterDataToSalve;

//output from the master
wire Sclk,Mosi;
wire [0:2] Cs;
wire [7:0] MasterDataReceived;

//the storage to the data out 
reg [7:0] MOSI;
integer i,index,failures;
localparam PERIOD = 20;
localparam TESTCASECOUNT=7;

Master master(clk,Reset,Start,SalveSelect,MasterDataToSalve,MasterDataReceived,Sclk,Cs,Mosi,Miso);

reg [7:0] testcase_masterData [0:TESTCASECOUNT]; //using it to fill the data that will be sent by the master to the slave
reg [7:0] testcase_salveData [0:TESTCASECOUNT]; //using it to fill the data that will be sent by the salve to the master
always 
#(PERIOD/2) clk=~clk;

initial 
begin
//$monitor("Mosi=%b CS=%b MOSI=%b,MasterDataToSalve = %b ",Mosi,Cs,MOSI,MasterDataToSalve);
clk =0;
Reset=1;
Start = 0;
failures =0;
//MOSI = 8'b0;
#(PERIOD);
Reset=0;
//Miso=1;
SalveSelect=2'b01;
testcase_masterData[0]=8'b01011111;
testcase_masterData[1]=8'b01010011;
testcase_masterData[2]=8'b00111100;
testcase_masterData[3]=8'b00001001;
testcase_masterData[4]=8'b00100010;
testcase_masterData[5]=8'b10000011;
testcase_masterData[6]=8'b00111100;
testcase_masterData[7]=8'b10011000;
//data to test the resived data from the slave
testcase_salveData[0]=8'b01010111;
testcase_salveData[1]=8'b01110011;
testcase_salveData[2]=8'b00111110;
testcase_salveData[3]=8'b11001001;
testcase_salveData[4]=8'b00101010;
testcase_salveData[5]=8'b10011011;
testcase_salveData[6]=8'b11111100;
testcase_salveData[7]=8'b10011110;
//MOSI[0]= Mosi;
for(index=0;index<8;index=index+1)
begin

MasterDataToSalve=testcase_masterData[index];
#(PERIOD)Start=1;

for(i=0;i<8;i=i+1)
begin
	#(PERIOD/2)Miso=testcase_salveData[index][i];
	#(PERIOD/2)MOSI[i]=Mosi;
	Start=0;
end
$display("TestCase %d",index+1);
#(3*PERIOD);
if(MOSI==MasterDataToSalve)
begin
$display("successful Send");
end
else begin
$display("failed Send");
$display("MasterDataToSalve=%b MOSI = %b",MasterDataToSalve,MOSI);
failures = failures + 1;
end
//$display(" MasterDataReceived Test ");
if(testcase_salveData[index]==MasterDataReceived)
begin
$display("successful Receive");
end
else begin
$display("failed Receive");
$display("MasterDataReceived=%b testcase_salveData_corrected = %b",MasterDataReceived,testcase_salveData[index]);
failures = failures + 1;
end
end
#15;
if(failures)
begin
$display("no of failed cases =%d out of %d testcases have failed",failures,2*(TESTCASECOUNT+1));
end
else begin
$display("SUCCESS: All %d testcases have been successful",2*(TESTCASECOUNT+1));
end 

$finish;
end
endmodule
