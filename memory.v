`timescale 1ns/1ps

module memory(executeflag, icode, valE, valA, valM, err);
input executeflag;
input [3:0] icode;
input [63:0] valE, valA;
output reg [63:0] valM;
output reg err;

reg datamem[63:0][63:0];  //We have defined an arbitrary memory
reg [15:0] address;
reg [63:0] datain;
reg memread, memwrite;


integer i;

always @ (posedge executeflag)
begin
	memread=0;
	memwrite=0;

	if(icode==9||icode==4'hb)
	address=valA;
	
	if(icode==4||icode==5||icode==8||icode==4'ha)
	address=valE;

	if(address>64)
	err=1;//error when the input address is too large
	else
	begin
	err=0;	
		//Reading from memory
		if(icode==5||icode==9||icode==4'hb)
		memread=1;
		
		if(memread==1)
		begin
			for(i=0; i<64; i=i+1)
			valM[i]=datamem[address][i];
		end
		//Dumping into memory
		if(icode==4||icode==8||icode==4'ha)
                memwrite=1;

		if(memwrite==1)
		begin
			 for(i=0; i<64; i=i+1)
			 datamem[address][i]=datain[i];
		end
	end
$display("Memory is done\n");
$display("valM=%0d", valM);

if(err==1)
begin
$display("Halted");
$finish;
end

end
endmodule
