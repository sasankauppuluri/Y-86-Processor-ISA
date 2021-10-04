`timescale 1ns/1ps

module execute(decodeflag, valA, valB, valC, valE, icode, ifun, cnd, executeflag);
input decodeflag;
input [63: 0] valA, valB, valC;
input [3: 0] icode, ifun;
output reg[63:0] valE;
output reg cnd, executeflag;

reg [63: 0] aluA, aluB;
reg zero, overflow, sign;

always @ (decodeflag)
begin
	executeflag=0;
	//setting up value of aluA
	if(icode==2||icode==6)
	begin
		aluA=valA;
	end

	else if(icode==3||icode==4||icode==5)
	begin
		aluA=valC;
	end
	
	else if (icode==9|| icode==4'hb)
        begin
                aluA=8;
        end

	else if (icode==8|| icode==4'ha)
	begin
		aluA=-8;
	end
	
	else aluA=0;

	//setting up value of aluB
	if(icode==2||icode==3)
	begin
		aluB=0;
	end
	
	else aluB=valB;


// Computing valE
	if(icode!=6)
	begin
		valE=aluA+aluB;
	end	
	
	if(icode==6)
	begin
		if(ifun==0)
		begin
		valE=aluA+aluB;
		end

		if(ifun==1)
                begin
                valE=aluA-aluB;
                end
		
		if(ifun==2)
                begin
                valE=aluA&aluB;
                end
		
		if(ifun==3)
                begin
                valE=aluA^aluB;
                end

	end

// setting condition codes

if(icode==6)
begin
	zero=0;
	sign=0;
	overflow=0;

	if(valE==0)
	zero=1;
	if(valE[63]==1)
	sign=1;
	if((ifun==0&&aluA[63]==0 && aluB[63]==0 && valE[63]==1)||(ifun==0 && aluA[63]==1 && aluB[63]==1 && valE[63]==0)|| (ifun==1 && aluA[63]==0 && aluB[63]==1 && valE[63]==0)||(ifun==1 && aluA[63]==1 && aluB[63]==0 && valE[63]==1) )
	overflow=1;
end

cnd=0;
if(icode==2||icode==7)
begin
	if(ifun==0)// always 
	cnd=1;	
	if(ifun==1&& (sign^overflow|zero))//less than equal to
	cnd=1;
	if(ifun==2&& (sign^overflow))// less than
	cnd=1;
	if(ifun==3&& zero)//equal to
	cnd=1;
	if(ifun==4&& ~zero)// not equal to
	cnd=1;
	if(ifun==5&& ~(sign^overflow))// greater than equal to 
	cnd=1;
	if(ifun==6&& ((~(sign^overflow))& (~zero))  )// greater than
	cnd=1;
end
$display("Execute stage is done");
$display("Condition codes zero flag=%b sign flag=%b overflow flag=%b valE=%0d", zero, sign, overflow, valE);
executeflag=1;

end

endmodule
