//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module space_invaders( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk;
    logic [7:0] keycode;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
		  
			//testing without keyboard
			if(~KEY[3])
				keycode <= 8'd4;
			else if (~KEY[1])
				keycode <= 8'd7;
			else if (~KEY[2])
				keycode <= 8'd44;
			else
				keycode <= 8'd0;
		  
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 
	 logic [9:0] DrawX, DrawY;
	 logic is_ball;
	 
	 logic [7:0] animation_offset;
	 logic [9:0] enemy_offset;
	 logic [9:0] player_offset;
	 logic [2:0] player_lives;
	 logic player_flash;
	 
	 logic missile_exists;
	 logic [9:0] missileX;
	 logic [9:0] missileY;
	 
	 logic [9:0][5:0]	enemy_status;
	 
	 logic pmissile_create;
	 logic pmissile_exists;
	 logic [9:0] playerMissileX;
	 logic [9:0] playerMissileY;
	 
	 logic [6:0] enemy_hit;
	 logic enemy_collision;
	 logic player_collision;
	 
	 logic lives_text_pixel;
	 
	 logic current_score_pixel;
	 
	 logic score_text_pixel;
	 
	 logic [9:0] score_text_x_offset;
	 
    assign score_text_x_offset = DrawX - 10'd496;
	 
	 logic press_space_pixel;
	 logic you_win_pixel;
	 logic game_over_pixel;
	 
	 logic [3:0] state;
	 
	 logic player_unkillable;
	 
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             //.keycode_export(keycode),  
									  .keycode_export(),
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(
										.Clk(Clk),
										.Reset(Reset_h),
										.VGA_HS,
										.VGA_VS,
										.VGA_CLK,
										.VGA_BLANK_N,
										.VGA_SYNC_N,
										.DrawX,
										.DrawY
	 );
    
	// enemy_controller is responsible for controlling the location
	// of the enemy array
	enemy_controller enemy_instance(
										.reset(Reset_h),
										.v_sync(VGA_VS),
										.animation_offset(animation_offset),
										.enemy_offset(enemy_offset)
	);
	
	// allow the user to have control over the player space ship
	player player_instance(
										.reset(Reset_h),
										.vsync(VGA_VS),
										.keycode(keycode),
										.pcollision(player_collision),
										
										.player_flash(player_flash),
										.pmissile_create(pmissile_create),
										.x_pos(player_offset),
										.lives(player_lives),
										.player_unkillable(player_unkillable)
	);
	
	// missiles that are shot from the enemies
	enemy_missile emissile (
										.reset(Reset_h),
										.vsync(VGA_VS),
										.playerX(player_offset),
										.enemy_offset(enemy_offset),
										.enemy_status(enemy_status),
										.state(state),
										
										.exists(missile_exists),
										.missileX(missileX),
										.missileY(missileY)
	);
	
	// records which enemies are still alive
	enemy_status enemy_array (
										.reset(Reset_h),
										.enemy_hit(enemy_hit),
										.collision(enemy_collision),
										.enemy_status(enemy_status)
	);
	
	// keep track of missiles the player has shot
	player_missile pmissile (
										.reset(Reset_h),
										.playerx(player_offset),
										.vsync(VGA_VS),
										.create(pmissile_create),
										.has_collided(enemy_collision),
										
										.exists(pmissile_exists),
										.playerMissileX(playerMissileX),
										.playerMissileY(playerMissileY)
	);
	
	// detect whenever player and enemy missiles collide
	collision_detection cd (
										.reset(Reset_h),
										.vsync(VGA_VS),
										
										.pmissileX(playerMissileX),
										.pmissileY(playerMissileY),
										.emissileX(missileX),
										.emissileY(missileY),
										
										.playerX(player_offset),
										
										.enemy_hit(enemy_hit),
										
										.enemy_offset(enemy_offset),
										.enemy_status(enemy_status),
										
										.pcollision(player_collision),
										.ecollision(enemy_collision)
	);
	
	// keep track of the score
	score_map scorekeeper (
										.vsync(VGA_VS),
										.reset(Reset_h),
										.X(DrawX[6:1] - 6'h028),
										.Y(DrawY[4:1]),
										
										.enemy_collision(enemy_collision),
										
										.pixel(current_score_pixel)
	);
	
	lives_text_map lives_text (
										.X(DrawX[6:1]),
										.Y(DrawY[4:1]),
										
										.pixel(lives_text_pixel)
	);
	
	game_over_text_map gotm (
										.X(DrawX[6:1] - 6'h10),
										.Y(DrawY[5:1] - 5'h08),
										
										.pixel(game_over_pixel)
	);
	
	press_fire_text_map (
										.X(DrawX[6:1] - 6'h0C),
										.Y(DrawY[5:1] - 5'h08),
										
										.pixel(press_space_pixel)
	);
	
	you_win_text_map (
										.X(DrawX[6:1] - 6'h14),
										.Y(DrawY[5:1] - 5'h08),
										
										.pixel(you_win_pixel)
	);
	
	score_text_map score_text (
										.X(score_text_x_offset[6:1]),
										.Y(DrawY[4:1]),
										
										.pixel(score_text_pixel)
	);
	
	state_machine sm (
										.vsync(VGA_VS),
										.enemy_array({enemy_status[0], enemy_status[1], enemy_status[2], 
														enemy_status[3], enemy_status[4], enemy_status[5], 
														enemy_status[6], enemy_status[7], enemy_status[8], 
														enemy_status[9]}),
										.player_lives(player_lives),
										.key_pressed(keycode),
										.reset(Reset_h),
										
										.state(state)
	);
    
	 // draw all elements on screen
    color_mapper color_instance(
										.state(state),
										.you_win_pixel(you_win_pixel),
										.press_space_pixel(press_space_pixel),
										.game_over_pixel(game_over_pixel),
										
										.player_unkillable(player_collision),
	 	 
										.animation_offset(animation_offset),
										.enemy_offset(enemy_offset),
										.player_offset(player_offset),
										.player_flash(player_flash),
										
										.missile_exists(missile_exists),
										.missileX(missileX),
										.missileY(missileY),
										
										.pmissile_exists(pmissile_exists),
										.pMissileX(playerMissileX),
										.pMissileY(playerMissileY),
										
										.enemy_status(enemy_status),
										.player_lives(player_lives),
										
										.current_score_pixel(current_score_pixel),
										
										.lives_block_pixel(lives_text_pixel),
										
										.score_text_pixel(score_text_pixel),
										
										.DrawX,
										.DrawY,
										.VGA_R,
										.VGA_G,
										.VGA_B
	 );
    
    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
    
endmodule
