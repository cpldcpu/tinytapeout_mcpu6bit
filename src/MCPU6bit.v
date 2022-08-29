//
// Minimal 6 Bit CPU
//
// 01-02/2001 Tim B"oscke
// 10   /2001 changed to synch. reset
// 10   /2004 Verilog version, unverified!
//
// 08   /2022 Changed to 6 bit


module mcpu6bit_top(datain,dataout,we,rst,clk);

inout [5:0] datain;
output [5:0] dataout;
output we;
input rst;
input clk;

reg [6:0] accumulator; // accumulator(6) is carry !
reg [3:0] adreg;
reg [3:0] pc;
reg [2:0] states;

initial begin
end

	always @(posedge clk)
		if (~rst) begin
			adreg 	  <= 0;
			states	  <= 0;
			accumulator <= 0;	
			pc <= 0;
		end
		else begin
			// PC / Address path
			if (~|states) begin
				pc	 <= adreg + 1'b1;
				adreg <= datain[3:0];  // was adreg <=pc, aw fix.
			end
			else adreg <= pc;
		
			// ALU / Data Path
			case(states)
				3'b010 : accumulator 	 <= {1'b0, accumulator[5:0]} + {1'b0, datain}; // add
				3'b011 : accumulator[5:0] <= ~(accumulator[5:0]|datain); // nor
				3'b101 : accumulator[6]   <= 1'b0; // branch not taken, clear carry					   
			endcase							// default:  instruction fetch, jcc taken

			// State machine
			if (|states) states <= 0;
			else begin 
				if ( &datain[5:4] && accumulator[6] ) states <= 3'b101;
				else states <= {1'b0, ~datain[5:4]};
			end
		end
// output
// assign adress = adreg;
// assign data   = states!=3'b001 ?  8'bZZZZZZZZ : accumulator[7:0]; 
assign dataout   = clk ?  {1'b00,adreg} : accumulator[5:0]; 
// assign dataout   = accumulator[5:0]; 
assign we     =  ~rst | (states!=3'b001) ; 

endmodule
