module state_machine
(
		input logic 			vsync,
		input logic [59:0] 	enemy_array,
		input logic [2:0]		player_lives,
		input logic [7:0] 	key_pressed,
		input logic 			reset,
		
		output logic [3:0]	state
);

	always_ff @ (posedge vsync or posedge reset) begin
	
		if(reset) begin
			//state 0 = "press space" state
			state <= 4'b0;
		end
		
		else begin
		
			if(state == 4'b0 && key_pressed == 8'd44)
				//state 1 = game play state
				state <= 4'd1;
			
			else if(state == 4'd1 && enemy_array == 60'd0)
				//state 2 = you win state
				state <= 4'd2;
				
			else if(state == 4'd1 && player_lives == 3'd0)
				//state 3 = game over state
				state <= 4'd3;
				
			else
				//otherwise don't change anything
				state <= state;
		
		end
	
	end

endmodule 