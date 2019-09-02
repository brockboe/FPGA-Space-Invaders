module collision_detection
(
	input logic reset,
	input logic vsync,
	
	input logic [9:0] pmissileX,
	input logic [9:0] pmissileY,
	input logic [9:0] emissileX,
	input logic [9:0] emissileY,
	
	output	logic [6:0] enemy_hit,
	
	input logic [9:0] enemy_offset,
	input	logic [9:0][5:0] 	enemy_status,
	
	output logic pcollision,
	output logic ecollision
);

	logic [9:0] pmissile_normalized;
	logic [9:0] ySlice1;
	logic [9:0] ySlice2;
	logic [9:0] ySlice3;
	logic [9:0] ySlice4;
	logic [9:0] ySlice5;
	logic [9:0] ySlice6;


	always_ff @ (posedge vsync or posedge reset) begin
	
		if(reset) begin
			pcollision = 1'b0;
			ecollision = 1'b0;
		end
		
		else begin
			
			//check for enemy collision with player missile
				
			// Y row start => middle of row
			// 32		=> 	48
			// 64		=> 	80
			// 96		=> 	112
			// 128	=> 	144
			// 160	=> 	176
			// 192	=> 	208
			// 224
			
			if(pcollision)
				pcollision = 1'b0;
			if(ecollision)
				ecollision = 1'b0;
				
			if(pmissileY[9:5] == ySlice1[9:5] &&
			pmissile_normalized[5] == 1'b0 &&
			enemy_status[pmissile_normalized[9:6]][ySlice1[7:5] - 3'd1]) begin
				enemy_hit = { pmissile_normalized[9:6], ySlice1[7:5] - 3'd1 };
				ecollision = 1'b1;
			end
			
			
			else if(pmissileY[9:5]	== ySlice2[9:5] &&
			pmissile_normalized[5] == 1'b0 &&
			enemy_status[pmissile_normalized[9:6]][ySlice2[7:5] - 3'd1]) begin	
				enemy_hit = { pmissile_normalized[9:6], ySlice2[7:5] - 3'd1 };
				ecollision = 1'b1;
			end
			
			
			else if(pmissileY[9:5]	== ySlice3[9:5] &&
			pmissile_normalized[5] == 1'b0 &&
			enemy_status[pmissile_normalized[9:6]][ySlice3[7:5] - 3'd1]) begin			
				enemy_hit = { pmissile_normalized[9:6], ySlice3[7:5] - 3'd1 };
				ecollision = 1'b1;
			end
			
			
			else if(pmissileY[9:5]	== ySlice4[9:5] &&
			pmissile_normalized[5] == 1'b0 &&
			enemy_status[pmissile_normalized[9:6]][ySlice4[7:5] - 3'd1]) begin
				enemy_hit = { pmissile_normalized[9:6], ySlice4[7:5] - 3'd1 };
				ecollision = 1'b1;
			end
			
			
			else if(pmissileY[9:5]	== ySlice5[9:5] &&
			pmissile_normalized[5] == 1'b0 &&
			enemy_status[pmissile_normalized[9:6]][ySlice5[7:5] - 3'd1]) begin
				enemy_hit = { pmissile_normalized[9:6], ySlice5[7:5] - 3'd1 };
				ecollision = 1'b1;

			end
			
			
			else if(pmissileY[9:5]	== ySlice6[9:5] &&
			pmissile_normalized[5] == 1'b0 &&
			enemy_status[pmissile_normalized[9:6]][ySlice6[7:5] - 3'd1]) begin
				enemy_hit = { pmissile_normalized[9:6], ySlice6[7:5] - 3'd1 };
				ecollision = 1'b1;
			end
		
		end
	
	end
	
	always_comb begin
	
		pmissile_normalized = pmissileX - enemy_offset;
		ySlice1 = 10'd63;
		ySlice2 = 10'd95;
		ySlice3 = 10'd127;
		ySlice4 = 10'd159;
		ySlice5 = 10'd191;
		ySlice6 = 10'd223;
	
	end

endmodule 