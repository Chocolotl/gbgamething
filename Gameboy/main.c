#include <gb/gb.h>
#include <stdio.h>
#include "MSHRM.c"
#include "gameChar.c"

char player_pos[2];
short jumping = 0;
short gravity = -2;
int current_speed_y;
int floor_y_pos = 100;

struct charx2 bee;
struct charx2 fly;

void setup_fly(){
	fly.x = 100;
	fly.y = 100;
	fly.width = 16;
	fly.height = 8;

	set_sprite_tile(0,0);
	fly.spriteids[0] = 0;
	set_sprite_tile(1,1);
	fly.spriteids[1] = 1;
}

void setup_bee(){
	bee.x = 150;
	bee.y = 100;
	bee.width = 16;
	bee.height = 8;

	set_sprite_tile(0,0);
	bee.spriteids[0] = 0;
	set_sprite_tile(1,1);
	bee.spriteids[1] = 1;
}



void performance_delay(int numloops){
	int i;
	for(i = 0; i < numloops; i++){
		wait_vbl_done();

	}
}

int would_hit_surf_y(UINT8 proj_y_pos){
	if(proj_y_pos >= floor_y_pos){
		return floor_y_pos;

	}
	return -1;

}


void jump(){
	int pos_y_surf;

	if(jumping == 0){

		jumping = 1;
		current_speed_y = 10;
	}

	current_speed_y += gravity;

	player_pos[1] -= current_speed_y;

	pos_y_surf = would_hit_surf_y(player_pos[1]);

	if(pos_y_surf != -1){
		jumping = 0;
		move_sprite(0, player_pos[0],pos_y_surf);
	}
	else{
		move_sprite(0, player_pos[0],player_pos[1]);
	}


}




void main(){
	setup_bee();
	setup_fly();

	printf("HELLO WORLD");
	set_sprite_tile(0, 0);
	set_sprite_data(0, 2, MSHRM);

	player_pos[0] = 10;
	player_pos[1] = floor_y_pos;

	move_sprite(0, player_pos[0],player_pos[1]);
	DISPLAY_ON;
	SHOW_SPRITES;

	while(1){
		if((joypad() & J_A) || jumping == 1){
			jump();
		}
		if(joypad() & J_LEFT){
			player_pos[0] -= 4;
			move_sprite(0, player_pos[0],player_pos[1]);
		}
		if(joypad() & J_RIGHT){
			player_pos[0] += 4;
			move_sprite(0, player_pos[0],player_pos[1]);
		}


		performance_delay(4);

	}
}
