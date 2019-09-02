//score_map.sv
//
//allows for an easy way to display the score on screen.
//cpounts the number of enemies killed and displays it
//using numbers stored in number_rom.sv

module score_map
(
	input logic 		vsync,
	input logic 		reset,
	input logic [5:0] X,
	input logic	[3:0] Y,

	input logic enemy_collision,
	
	output logic pixel
);

	logic [3:0] score_hundreds;
	logic [3:0] score_tens;
	logic [3:0] score_ones;
	
	logic [7:0] number_slice;
	logic [7:0] number_address;
	
	number_rom rom_instance(.address(number_address), .data(number_slice));
	
	assign pixel = number_slice[3'b111 - X[2:0]];
	
	always_ff @ (posedge reset or posedge enemy_collision) begin
		if(reset) begin
			score_hundreds = 4'd0;
			score_tens = 4'd0;
			score_ones = 4'd0;
		end
		
		else if(enemy_collision) begin
			//whenever we hit an enemy, increment the score count
			score_ones = score_ones + 4'd1;

			//check for carry
			if(score_ones > 4'd9) begin
				score_ones = 4'd0;
				score_tens = score_tens + 4'd1;
			end

			if(score_tens > 4'd9) begin
				score_tens = 4'd0;
				score_hundreds = score_hundreds + 4'd1;
			end
			
			if(score_hundreds > 4'd9) begin
				score_hundreds = 4'd0;
			end
			
		//keep things the same by default
		else begin
			score_hundreds = score_hundreds;
			score_tens = score_tens;
			score_ones = score_ones;
		end
			
		end
		
	end

	always_comb begin
	
		//choose which score to print
		if(X >= 6'd0 && X < 6'd8) begin
			number_address = {score_hundreds, 4'b0} + Y;
		end
		
		else if(X >= 6'd8 && X < 6'd16) begin
			number_address = {score_tens, 4'b0} + Y;
		end
		
		else begin
			number_address = {score_ones, 4'b0} + Y;
		end
	
	end
	
endmodule 