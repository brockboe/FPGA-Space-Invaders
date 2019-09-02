//player_missile.sv
//
//controls the missile fired by the player.
//can only have one on the screen at any
//given time.

module player_missile
(
	input		logic			reset,
	input		logic	[9:0]	playerx,			//X coord of left side of player's ship
	input		logic			vsync,			//vsync clock signal
	input		logic			create,			//set high whenever a creation request is made
	input		logic			has_collided,	//set high whenever a collision occurs
	
	output	logic exists,						//set high whenever missile exists
	output	logic [9:0]	playerMissileX,	//X coord
	output	logic [9:0] playerMissileY		//Y coord
);

	logic creation_flag;

	always_ff @ (posedge vsync or posedge reset) begin
	
		playerMissileX = playerMissileX;
		playerMissileY = playerMissileY;
	
		if(reset) begin
			exists = 1'b0;
			playerMissileX = 10'd0;
			playerMissileY = 10'd0;
		end
	
		else begin
			
			//if create is high, set the creation flag to 1
			//to signal we want to make a new missile
			if(create) begin
				creation_flag = 1'b1;
			end
			
			//make sure that the flag is only set whenever we have 
			//create held high, so not to queue input.
			else begin
				creation_flag = 1'b0;
			end
			
			//if we have collided, then erase the missile
			if(has_collided) begin
				exists = 1'b0;
			end
			
			//create a new missile if create flag is high 
			//and a missile doesn't already exist
			else if(creation_flag && !exists) begin
				exists = 1'b1;
				playerMissileX = playerx + 10'd30;
				playerMissileY = 10'd448;
			end
			
			//if we go out of bounds, delete the missile
			else if(exists && playerMissileY == 10'd0) begin
				exists = 1'b0;
			end
			
			//otherwise update the missile's position
			else if(exists) begin
				playerMissileY = playerMissileY - 10'd4;
			end
		
		end
	
	end
	
	always_comb begin
	
	
	
	end

endmodule