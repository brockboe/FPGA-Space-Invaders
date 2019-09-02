module score_text_map
(
	input logic [5:0] X,
	input logic [3:0] Y,
	output logic pixel
);

	logic [7:0] rom_address;
	logic [7:0] text_slice;
	
	assign pixel = text_slice[3'b111 - X[2:0]];

	score_text_rom text_rom(.address(rom_address), .data(text_slice));


	always_comb begin
	
		//S
		if(X >= 6'd0 && X < 6'd8) begin
			rom_address = 8'd0 + Y;
		end
		
		//C
		else if(X >= 6'd8 && X < 6'd16) begin
			rom_address = 8'd16 + Y;
		end
		
		//O
		else if(X >= 6'd16 && X < 6'd24) begin
			rom_address = 8'd32 + Y;
		end
		
		//R
		else if(X >= 6'd24 && X < 6'd32) begin
			rom_address = 8'd48 + Y;
		end
		
		//E
		else if(X >= 6'd32 && X < 6'd40) begin
			rom_address = 8'd64 + Y;
		end
		
		//:
		else begin
			rom_address = 8'd80 + Y;
		end
	
	end
	
endmodule 