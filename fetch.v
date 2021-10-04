`timescale 1ns/1ps

module fetch(instmem, pc, icode, ifun, rA, rB, valC, valP, fetchflag);

// initialising input 
input [0:639]instmem;
input [0:63]pc;
// initialising output
output reg [3: 0] icode, ifun;
output reg [3: 0] rA, rB;
output reg [63: 0] valC;
output reg [0: 63]valP;
output reg fetchflag;

reg temp[0:3];

integer i, j;//loop variables
integer fhbyte, shbyte;

always @ (pc)
begin
fetchflag=0;
//Obtaining the first bit
	for(i=0; i<4; i=i+1)
	begin
		icode[3-i]=instmem[pc+i];
		ifun[3-i]=instmem[pc+4+i];	
	end	
fhbyte=icode;
shbyte=ifun;
//Halt condition
	if (fhbyte==0) 
	begin
		$display("Halt instruction is fetched");
		$finish;	
	end
//Obtaining the registers 
	if ((fhbyte>=2 && fhbyte<=6) || fhbyte==4'ha||fhbyte==4'hb)
	begin	
		for (i=0;i<4;i=i+1)
		begin
			rA[3-i]=instmem[pc+8+i];
			rB[3-i]=instmem[pc+12+i];
		end
	end	
//calculating the value of the constant i.e. valC	
	if (fhbyte<6 && fhbyte>2)
	begin	
		for (i=0;i<64;i=i+1)
		valC[63-i]=instmem[pc+16+i]; 
	end

	if (fhbyte==7||fhbyte==8)
	begin	
		for (i=0;i<64;i=i+1)
                valC[63-i]=instmem[pc+8+i];
       	end
//Calculating the new program counter	
	
	if(fhbyte==1||fhbyte==9)
        begin
                valP=pc+8;
        end


	if(fhbyte==2||fhbyte==6||fhbyte==4'ha||fhbyte==4'hb)
	begin
		valP=pc+16;
	end	

	if(fhbyte==3||fhbyte==4||fhbyte==5)
	begin
		valP=pc+80;
	end

	if(fhbyte==7||fhbyte==8)
        begin
                valP=pc+72;
        end


//Reversing the string after initially swapping to obtain valC in a form that is suitable for reading
//in the next stages

	for(i=0; i<64; i=i+8) 
	begin	
		for(j=0; j<4; j=j+1)
		begin
			temp[j]=valC[i+j+4];
			valC[i+j+4]=valC[i+j];
			valC[i+j]=temp[j];
		end
	end

	for(i=0; i<31; i=i+4) 
	begin
		for(j=0; j<4; j=j+1)
			begin
				temp[j]=valC[i+j];
				valC[i+j]=valC[64-i+j-4];
				valC[60-i+j]=temp[j];
			end
	end

fetchflag=1;

$display("Fetch is done");
$display("icode=%h ifun=%h rA=%h rB=%h valC=%h valP=%0d", icode, ifun, rA, rB, valC, valP);
end
endmodule
