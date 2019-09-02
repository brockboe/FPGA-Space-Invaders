module enemy_controller
(
	input logic 			v_sync,
	input logic				reset,
	output logic [7:0] 	animation_offset,
	output logic [9:0]	enemy_offset
);


logic [7:0] counter;
logic count_up_offset;
logic [11:0] subpixel_offset;

always_ff @ (posedge v_sync or posedge reset) begin

	subpixel_offset = subpixel_offset;

	if(reset) begin
		count_up_offset <= 1'b1;
		subpixel_offset <= 12'd0;
		counter <= 8'd0;
	end

	else begin
		counter = counter + 8'd1;
		if(counter >= 8'd120)
			counter = 8'd0;
			
		if(count_up_offset)
			subpixel_offset = subpixel_offset + 12'h001;
		else
			subpixel_offset = subpixel_offset - 12'h001;
			
		if(subpixel_offset[11:2] >= 10'd32) begin
			subpixel_offset[11:2] = 10'd32;
			count_up_offset = 1'b0;
		end
		if(subpixel_offset[11:2] == 10'd0) begin
			count_up_offset = 1'b1;
		end
	end
		
end

assign enemy_offset = subpixel_offset[11:2];


always_comb begin

	if(counter < 8'd60)
		animation_offset = 8'd8;
	else
		animation_offset = 8'd0;
		
end

endmodule 