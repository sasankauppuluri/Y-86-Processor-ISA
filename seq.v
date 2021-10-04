`timescale 1ns/1ps
`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "pcupdate.v"

module seq();

reg clock;
reg [0:639] instmem;
wire[0:63] valP, pc;
wire cnd, fetchflag, decodeflag, executeflag, err;
wire[3:0] icode, ifun, rA, rB;
wire [63:0] valA, valB, valC, valE, valM;
reg [7:0] mem[0: 199];

always #5 clock=~clock;

fetch seqf(instmem, pc, icode, ifun, rA, rB, valC, valP, fetchflag);
decode seqd(fetchflag, clock, icode, rA, rB, valA, valB, valM, valE, decodeflag);
execute seqe(decodeflag,valA, valB, valC, valE, icode, ifun, cnd, executeflag);
memory seqm(executeflag, icode, valE, valA, valM, err);
pcupdate seqwb(clock, cnd, valC, valM, icode, valP, pc);

initial begin
	clock=0;
	$dumpfile("seq_o.vcd");
	$dumpvars(0, seq);
	$readmemh("rough.txt", mem);
		instmem[0:7] = mem[0];
		instmem[8:15] = mem[1];
		instmem[16:23] = mem[2];
		instmem[24:31] = mem[3];
		instmem[32:39] = mem[4];
		instmem[40:47] = mem[5];
		instmem[48:55] = mem[6];
		instmem[56:63] = mem[7];
		instmem[64:71] = mem[8];
		instmem[72:79] = mem[9];
		instmem[80:87] = mem[10];
		instmem[88:95] = mem[11];
		instmem[96:103] = mem[12];
		instmem[104:111] = mem[13];
		instmem[112:119] = mem[14];
		instmem[120:127] = mem[15];
		instmem[128:135] = mem[16];
		instmem[136:143] = mem[17];
		instmem[144:151] = mem[18];
		instmem[152:159] = mem[19];
		instmem[160:167] = mem[20];
		instmem[168:175] = mem[21];
		instmem[176:183] = mem[22];
		instmem[184:191] = mem[23];
		instmem[192:199] = mem[24];
		instmem[200:207] = mem[25];
		instmem[208:215] = mem[26];
		instmem[216:223] = mem[27];
		instmem[224:231] = mem[28];
		instmem[232:239] = mem[29];
		instmem[240:247] = mem[30];
		instmem[248:255] = mem[31];
		instmem[256:263] = mem[32];
		instmem[264:271] = mem[33];
		instmem[272:279] = mem[34];
		instmem[280:287] = mem[35];
		instmem[288:295] = mem[36];
		instmem[296:303] = mem[37];
		instmem[304:311] = mem[38];
		instmem[312:319] = mem[39];
		instmem[320:327] = mem[40];
		instmem[328:335] = mem[41];
		instmem[336:343] = mem[42];
		instmem[344:351] = mem[43];
		instmem[352:359] = mem[44];
		instmem[360:367] = mem[45];
		instmem[368:375] = mem[46];
		instmem[376:383] = mem[47];
		instmem[384:391] = mem[48];
		instmem[392:399] = mem[49];
		instmem[400:407] = mem[50];
		instmem[408:415] = mem[51];
		instmem[416:423] = mem[52];
		instmem[424:431] = mem[53];
		instmem[432:439] = mem[54];
		instmem[440:447] = mem[55];
		instmem[448:455] = mem[56];
		instmem[456:463] = mem[57];
		instmem[464:471] = mem[58];
		instmem[472:479] = mem[59];
		instmem[480:487] = mem[60];
		instmem[488:495] = mem[61];
		instmem[496:503] = mem[62];
		instmem[504:511] = mem[63];
		instmem[512:519] = mem[64];
		instmem[520:527] = mem[65];
		instmem[528:535] = mem[66];
		instmem[536:543] = mem[67];
		instmem[544:551] = mem[68];
		instmem[552:559] = mem[69];
		instmem[560:567] = mem[70];
		instmem[568:575] = mem[71];
		instmem[576:583] = mem[72];
		instmem[584:591] = mem[73];
		instmem[592:599] = mem[74];
		instmem[600:607] = mem[75];
		instmem[608:615] = mem[76];
		instmem[616:623] = mem[77];
		instmem[624:631] = mem[78];
		instmem[632:639] = mem[79];
		
end

endmodule
