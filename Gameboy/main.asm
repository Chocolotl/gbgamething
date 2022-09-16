;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.6 #12539 (MINGW32)
;--------------------------------------------------------
	.module main
	.optsdcc -mgbz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _jump
	.globl _would_hit_surf_y
	.globl _performance_delay
	.globl _printf
	.globl _set_sprite_data
	.globl _wait_vbl_done
	.globl _joypad
	.globl _floor_y_pos
	.globl _gravity
	.globl _jumping
	.globl _MSHRM
	.globl _current_speed_y
	.globl _player_pos
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_player_pos::
	.ds 2
_current_speed_y::
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_MSHRM::
	.ds 176
_jumping::
	.ds 1
_gravity::
	.ds 1
_floor_y_pos::
	.ds 2
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;main.c:12: void performance_delay(UINT8 numloops){
;	---------------------------------
; Function performance_delay
; ---------------------------------
_performance_delay::
;main.c:14: for(i = 0; i < numloops; i++){
	ld	c, #0x00
00103$:
	ld	a, c
	ldhl	sp,	#2
	sub	a, (hl)
	ret	NC
;main.c:15: wait_vbl_done();
	call	_wait_vbl_done
;main.c:14: for(i = 0; i < numloops; i++){
	inc	c
;main.c:18: }
	jr	00103$
;main.c:20: int would_hit_surf_y(UINT8 proj_y_pos){
;	---------------------------------
; Function would_hit_surf_y
; ---------------------------------
_would_hit_surf_y::
;main.c:21: if(proj_y_pos >= floor_y_pos){
	ldhl	sp,	#2
	ld	c, (hl)
	ld	b, #0x00
	ld	hl, #_floor_y_pos
	ld	a, c
	sub	a, (hl)
	inc	hl
	ld	a, b
	sbc	a, (hl)
	ld	a, b
	ld	d, a
	bit	7, (hl)
	jr	Z, 00110$
	bit	7, d
	jr	NZ, 00111$
	cp	a, a
	jr	00111$
00110$:
	bit	7, d
	jr	Z, 00111$
	scf
00111$:
	jr	C, 00102$
;main.c:22: return floor_y_pos;
	ld	hl, #_floor_y_pos
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ret
00102$:
;main.c:25: return -1;
	ld	de, #0xffff
;main.c:27: }
	ret
;main.c:30: void jump(){
;	---------------------------------
; Function jump
; ---------------------------------
_jump::
	dec	sp
;main.c:33: if(jumping == 0){
	ld	hl, #_jumping
	ld	a, (hl)
	or	a, a
	jr	NZ, 00102$
;main.c:35: jumping = 1;
	ld	(hl), #0x01
;main.c:36: current_speed_y = 10;
	ld	hl, #_current_speed_y
	ld	(hl), #0x0a
00102$:
;main.c:39: current_speed_y += gravity;
	ld	a, (#_current_speed_y)
	ld	hl, #_gravity
	add	a, (hl)
	ld	hl, #_current_speed_y
	ld	(hl), a
;main.c:41: player_pos[1] -= current_speed_y;
	ld	bc, #_player_pos+0
	ld	e, c
	ld	d, b
	inc	de
	ld	a, (de)
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	sub	a, l
	ld	(de), a
;main.c:43: pos_y_surf = would_hit_surf_y(player_pos[1]);
	push	bc
	push	de
	push	af
	inc	sp
	call	_would_hit_surf_y
	inc	sp
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	pop	de
	pop	bc
	push	hl
	ld	a, l
	ldhl	sp,	#2
	ld	(hl), a
	pop	hl
;main.c:45: if(pos_y_surf != -1){
	ldhl	sp,	#0
	ld	a, (hl)
	inc	a
	jr	Z, 00104$
;main.c:46: jumping = 0;
	ld	hl, #_jumping
	ld	(hl), #0x00
;main.c:47: move_sprite(0, player_pos[0],pos_y_surf);
	ld	a, (bc)
	ld	c, a
;c:/gbdk/include/gb/gb.h:1520: OAM_item_t * itm = &shadow_OAM[nb];
	ld	de, #_shadow_OAM+0
;c:/gbdk/include/gb/gb.h:1521: itm->y=y, itm->x=x;
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(de), a
	inc	de
	ld	a, c
	ld	(de), a
;main.c:47: move_sprite(0, player_pos[0],pos_y_surf);
	jr	00108$
00104$:
;main.c:50: move_sprite(0, player_pos[0],player_pos[1]);
	ld	a, (de)
	ld	e, a
	ld	a, (bc)
	ld	c, a
;c:/gbdk/include/gb/gb.h:1520: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;c:/gbdk/include/gb/gb.h:1521: itm->y=y, itm->x=x;
	ld	a, e
	ld	(hl+), a
	ld	(hl), c
;main.c:50: move_sprite(0, player_pos[0],player_pos[1]);
00108$:
;main.c:54: }
	inc	sp
	ret
;main.c:56: void main(){
;	---------------------------------
; Function main
; ---------------------------------
_main::
;main.c:59: printf("HELLO WORLD");
	ld	de, #___str_0
	push	de
	call	_printf
	pop	hl
;c:/gbdk/include/gb/gb.h:1447: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 2)
	ld	(hl), #0x00
;main.c:61: set_sprite_data(0, 2, MSHRM);
	ld	de, #_MSHRM
	push	de
	ld	a, #0x02
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;main.c:63: player_pos[0] = 10;
	ld	hl, #_player_pos
	ld	(hl), #0x0a
;main.c:64: player_pos[1] = floor_y_pos;
	ld	hl, #_floor_y_pos
	ld	b, (hl)
	ld	hl, #(_player_pos + 1)
	ld	(hl), b
;main.c:66: move_sprite(0, player_pos[0],player_pos[1]);
	ld	hl, #_player_pos
	ld	c, (hl)
;c:/gbdk/include/gb/gb.h:1520: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;c:/gbdk/include/gb/gb.h:1521: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:67: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;main.c:68: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;main.c:70: while(1){
00109$:
;main.c:71: if((joypad() & J_A) || jumping == 1){
	call	_joypad
	bit	4, e
	jr	NZ, 00101$
	ld	a, (#_jumping)
	dec	a
	jr	NZ, 00102$
00101$:
;main.c:72: jump();
	call	_jump
00102$:
;main.c:74: if(joypad() & J_LEFT){
	call	_joypad
	bit	1, e
	jr	Z, 00105$
;main.c:75: player_pos[0] -= 4;
	ld	a, (#_player_pos + 0)
	add	a, #0xfc
	ld	(#_player_pos),a
;main.c:76: move_sprite(0, player_pos[0],player_pos[1]);
	ld	hl, #(_player_pos + 1)
	ld	b, (hl)
	ld	c, a
;c:/gbdk/include/gb/gb.h:1520: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;c:/gbdk/include/gb/gb.h:1521: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:76: move_sprite(0, player_pos[0],player_pos[1]);
00105$:
;main.c:78: if(joypad() & J_RIGHT){
	call	_joypad
	ld	a, e
	rrca
	jr	NC, 00107$
;main.c:79: player_pos[0] += 4;
	ld	a, (#_player_pos + 0)
	add	a, #0x04
	ld	(#_player_pos),a
;main.c:80: move_sprite(0, player_pos[0],player_pos[1]);
	ld	hl, #(_player_pos + 1)
	ld	c, (hl)
	ld	b, a
;c:/gbdk/include/gb/gb.h:1520: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;c:/gbdk/include/gb/gb.h:1521: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:80: move_sprite(0, player_pos[0],player_pos[1]);
00107$:
;main.c:84: performance_delay(5);
	ld	a, #0x05
	push	af
	inc	sp
	call	_performance_delay
	inc	sp
;main.c:87: }
	jr	00109$
___str_0:
	.ascii "HELLO WORLD"
	.db 0x00
	.area _CODE
	.area _INITIALIZER
__xinit__MSHRM:
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x42	; 66	'B'
	.db #0x4e	; 78	'N'
	.db #0x81	; 129
	.db #0xcb	; 203
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x56	; 86	'V'
	.db #0x56	; 86	'V'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x6c	; 108	'l'
	.db #0x82	; 130
	.db #0xbe	; 190
	.db #0x82	; 130
	.db #0xfa	; 250
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x23	; 35
	.db #0x3f	; 63
	.db #0x31	; 49	'1'
	.db #0x3f	; 63
	.db #0x62	; 98	'b'
	.db #0x7f	; 127
	.db #0x5c	; 92
	.db #0x5f	; 95
	.db #0x42	; 66	'B'
	.db #0x43	; 67	'C'
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0xa8	; 168
	.db #0x88	; 136
	.db #0x48	; 72	'H'
	.db #0x08	; 8
	.db #0xb0	; 176
	.db #0x30	; 48	'0'
	.db #0xfc	; 252
	.db #0x7c	; 124
	.db #0x1e	; 30
	.db #0xfe	; 254
	.db #0x3e	; 62
	.db #0xfe	; 254
	.db #0xdc	; 220
	.db #0xdc	; 220
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x09	; 9
	.db #0x09	; 9
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x23	; 35
	.db #0x23	; 35
	.db #0x33	; 51	'3'
	.db #0x33	; 51	'3'
	.db #0x23	; 35
	.db #0x23	; 35
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0xa8	; 168
	.db #0x88	; 136
	.db #0x48	; 72	'H'
	.db #0x08	; 8
	.db #0xb0	; 176
	.db #0x30	; 48	'0'
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x37	; 55	'7'
	.db #0x37	; 55	'7'
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7e	; 126
	.db #0x42	; 66	'B'
	.db #0x7e	; 126
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
__xinit__jumping:
	.db #0x00	;  0
__xinit__gravity:
	.db #0xfe	; -2
__xinit__floor_y_pos:
	.dw #0x0064
	.area _CABS (ABS)
