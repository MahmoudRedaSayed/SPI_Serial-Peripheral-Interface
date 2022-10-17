//NOTE : at CS==1 no receiving or sending operation done , both work at CS==0 at the same time
//NOTE : receiving done @negative edge and sending @positive of SCLK
module Slave(
    reset,
	slaveDataToSend, slaveDataReceived,
	SCLK, CS, MOSI, MISO
);
input reset;
input SCLK;
input CS;
output [7:0]slaveDataReceived;
input MOSI;
input [7:0]slaveDataToSend;
output MISO;
//NOTE:reg the following as it is left side in always block
reg MISO;
reg [7:0]slaveDataReceived;
reg[3:0] count=4'b0000;
reg[3:0] count_2=4'b0000;

always @( negedge SCLK ,posedge reset)
begin
//NOTE : no need to make slaveDataToSend=0 as DevelopmentTB made it already
if(reset==1'b1)
  begin
    slaveDataReceived<=8'b00000000;
    count<=4'b0000;
    MISO<=1'bz;
  end
else if(CS==0)
  begin
   if(count!=4'b1000)
    begin
     slaveDataReceived[count]=MOSI;
     count=count+1;
	 if(count==4'b1000)
	  begin
        count=4'b0000;
      end
    end
  end
end

always @( posedge SCLK )
begin
 if(CS==0 && reset==1'b0)
  begin

   if(count_2!=4'b1000)
    begin
	 MISO=slaveDataToSend[count_2];
     count_2=count_2+1;
	 if(count_2==4'b1000)
	  begin
        count_2=4'b0000;
      end
    end
  end
else if(CS==1)
   begin
     MISO<=1'bz;
   end

end

endmodule
