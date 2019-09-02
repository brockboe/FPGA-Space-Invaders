//enemy_controller.sv
//
//Responsible for controlling the behaviour of the enemy array

module enemy_controller
(
	input logic 			v_sync,
	input logic				reset,
	output logic [7:0] 	animation_offset,	//Selects which enemy animation to use
	output logic [9:0]	enemy_offset		//X offset of the enemy array
);


logic [7:0] counter;
logic count_up_offset;
logic [11:0] subpixel_offset;	//use a subpixel offset to allow for smooth, sloow
										//movement

always_ff @ (posedge v_sync or posedge reset) begin

	//by default, don't change position
	subpixel_offset = subpixel_offset;

	if(reset) begin
		count_up_offset <= 1'b1;
		subpixel_offset <= 12'd0;
		counter <= 8'd0;
	end

	//update enemy possition
	else begin
		//set a counter to know what enemy animation
		//frame we should use.
		counter = counter + 8'd1;
		if(counter >= 8'd120)
			counter = 8'd0;
			
		//if we're moving to the right, then move to the right
		if(count_up_offset)
			subpixel_offset = subpixel_offset + 12'h001;
		//otherwise move to the left
		else
			subpixel_offset = subpixel_offset - 12'h001;
			
		//if we're at the right side, then start moving to the left
		if(subpixel_offset[11:2] >= 10'd32) begin
			subpixel_offset[11:2] = 10'd32;
			count_up_offset = 1'b0;
		end
		//if we're at the left side, then start moving to the right
		if(subpixel_offset[11:2] == 10'd0) begin
			count_up_offset = 1'b1;
		end
	end
		
end

assign enemy_offset = subpixel_offset[11:2];


always_comb begin

	//for one second, use the first animation.
	//for every other second, use the second
	//animation
	if(counter < 8'd60)
		animation_offset = 8'd8;
	else
		animation_offset = 8'd0;
		
end

endmodule 