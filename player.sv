// player.sv
//
// Controls player's space ship, 
// and allows for user control

module player
(
	input logic reset,
	input logic vsync,
	input logic [7:0] keycode,			//code from the keyboard
	input logic pcollision,				//check if we're hit by an enemy missile
	
	output logic pmissile_create,		//command to create new player missile
	output logic player_flash,			//choose to flash whenever ship has post-hit invincibility
	output logic [9:0] x_pos,			//left X position of player's ship
	output logic [2:0] lives,			//number of lives left
	output logic player_unkillable
);

	// w = 8'd26
	// a = 8'd4
	// s = 8'd22
	// d = 8'd7
	// space = 8'd44
	
	logic [11:0] subpixel_position;
	logic invincible;
	logic [9:0] invincible_counter;
	
	assign player_flash = invincible_counter[2];
	
	always_ff @ (posedge vsync or posedge reset) begin
	
		subpixel_position = subpixel_position;
	
		if(reset) begin
			subpixel_position[11:2] = 10'd288;
			pmissile_create = 1'b0;
			lives = 3'd3;
			invincible = 1'b0;
			invincible_counter = 9'd0;
			player_unkillable = 1'b0;
		end
		
		else begin
		
			//if we're hit by a missile, we're not invincible, and we
			//still have lives left, remove a life, and make us
			//temporarily invincible.
			if(pcollision && lives > 3'd0 && !invincible) begin
				lives = lives - 3'd1;
				invincible = 1'b1;
				invincible_counter = 9'd0;
				player_unkillable = 1'b1;
			end
			//if we're invincible, decrement the invincibility counter
			else if(invincible && invincible_counter <= 9'd240) begin
				invincible_counter = invincible_counter + 9'd1;
				player_unkillable = 1'b1;
			end
			//if the invincibility counter runs out, reset everything
			else begin
				invincible_counter = 9'd0;
				invincible = 1'b0;
				player_unkillable = 1'b0;
			end
							
			//move left whenever a is pressed				
			if(keycode == 8'd4)
				subpixel_position = subpixel_position - 12'd6;
			//move right whenever d is pressed 
			else if(keycode == 8'd7)
				subpixel_position = subpixel_position + 12'd6;
			//if space is pressed, shoot a missile
			else if(keycode == 8'd44)
				pmissile_create = 1'b1;
			//otherwise do nothing
			else
				pmissile_create = 1'b0;
			
			//check the left bound
			if(subpixel_position[11:2] == 10'd0)
				subpixel_position = 12'd0;
			
			//check for overflow
			else if(subpixel_position[11:2] >= 10'd999)
				subpixel_position = 12'd0;
			
			//check the right bound
			else if(subpixel_position[11:2] > 10'd576)
				subpixel_position[11:2] = 10'd576;
			
		end
	
	end
	
	assign x_pos = subpixel_position[11:2];
	
endmodule 