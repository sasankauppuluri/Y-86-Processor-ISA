`timescale 1ns/1ps

module pcupdate(clock, cnd, valC, valM, icode, valP, pc);
input clock, cnd;
input [3:0] icode;
input [63:0] valC, valM;
input [0: 63] valP;
output reg [0:63] pc;

initial #2 pc=0;
always @ (posedge clock)
begin
	if(icode==7&&cnd==1||icode==8) 
	pc=valC;
	else if (icode==9)
	pc=valM;
	else
	pc=valP;
$display("PC update is done\n");
$display("PC=%0d", pc);

end
endmodule
