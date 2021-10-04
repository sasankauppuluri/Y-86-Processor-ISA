`timescale 1ns/1ps

module decode(fetchflag, clock, icode, rA, rB, valA, valB, valM, valE, decodeflag);
//defining inuputs and outputs
input clock, fetchflag;
input [3: 0] icode, rA, rB;
input [63: 0] valM, valE;
output reg [63: 0] valA, valB;
output reg decodeflag;

reg [63:0] sfbitreg[14: 0];//15 64-bit registers
reg [3:0] srcA, srcB, destM, destE;

integer i;
initial sfbitreg[4]=10;//value stored in rsp
//Decode stage
always @ (fetchflag)
begin
	decodeflag=0;
	//Reading value of rA 
	if(icode==9||icode==4'hb)
	srcA=4;
	else if(icode==2||icode==4||icode==6||icode==4'ha)
        srcA=rA;
	else 
	srcA=4'hf;

	if(srcA!=4'hf)
	valA=sfbitreg[srcA];
	
	//reading value of rB
	if(icode==8||icode==9||icode==4'ha||icode==4'hb)
	srcB=4;
	else if(icode==4||icode==5||icode==6)
	srcB=rB;
	else
	srcB=4'hf;
	
	if(srcB!=4'hf)
        valB=sfbitreg[srcB];
decodeflag=1;

$display("Decode is done\n");		
$display(" scrA=%h srcB=%h valA=%0h valB=%0h", srcA, srcB, valA, valB);
end

//writeback stage
always @ (posedge clock)

begin
	//writing values into the register
	if (icode==8||icode==9||icode==4'ha||icode==4'hb)
	destE=4'h4;
	else if(icode==2||icode==3||icode==6)
        destE=rB;
	else 
	destE=4'hf;

	if(destE!=4'hf)
	sfbitreg[destE]=valE;

	if(icode==5||icode==4'hb)
	destM=rA;
	else
	destM=4'hf;
	
	if(destM!=4'hf)
	sfbitreg[destM]=valM;

$display("Writeback is done");
//Displaying the registers
for (i=0;i<15;i=i+1)
$display("Reg %0d = %d",i,sfbitreg[i]);
$display("destE=%h destM=%h valE=%h valM=%h", destE, destM, valE, valM);

end


endmodule

