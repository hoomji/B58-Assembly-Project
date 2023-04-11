###################################################
#
# CSCB58 Winter 2023 Assemble Final Project
# UTSC
# Henry Tran | 1007298862
#
#
# Bitmap Display Configuration
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 512
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 3 (choose the one that applies)
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. Health/score 
# 2. Fail condition
# 3. Win condition 
# 4. Different levels
# 5. Pick-up effects
# 	- slow down time
#	- speed up time
#	- increment score
# 	- go to next level
#	- win the game
#	- climb rope (vertical movement)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes, and please share this project github link as well!
#
# Any additional information the TA needs to know: 
# - (write here, if any)
# - do not reset the level manual without going to the game over screen first by dying 
# - not meant to be able to reset after you win the game
#
#################################################################################

.eqv BASE_ADDRESS 0x10008000
.eqv BLACK 0x000000
.eqv WHITE 0xFFFFFF
.eqv RED 0xff0000
.eqv GREEN 0x00ff00
.eqv YELLOW 0xFFFF00
.eqv ORANGE 0xffa500 
.eqv PURPLE 0xA020F0 

.eqv BLUE 0x0000ff
.eqv SKIN 0xF7EBEC


.data
Sleep: .word 100 # 40 ms -> 25 Hz 
Player_position: .space 24
Player_colors: .space 24
Player_size: .word 6 

move: .space 4

Platform_1: .space 4

Platform_2: .space 4

Floor: .space 16384 # 1 = floor, 2 = ladder, 3 = death, 4 =  win 1, 5, = win 2, 6 = win 3

Width: .word 64
Height: .word 64

.text
.globl main

main:
  jal init
  j main_loop

main_loop:
# Erase objects from the old position on the screen.
  la $t1, Player_position
  li $t0, BASE_ADDRESS 
	
  li $t8, BLACK
  lw $t2, 0($t1)
  add $t3, $t2, $t0
  sw $t8, 0($t3)

  lw $t2, 4($t1)
  add $t3, $t2, $t0
  sw $t8, 0($t3)

  lw $t2, 8($t1)
  add $t3, $t2, $t0
  sw $t8, 0($t3)

  lw $t2, 12($t1)
  add $t3, $t2, $t0
  sw $t8, 0($t3)

  lw $t2, 16($t1)
  add $t3, $t2, $t0
  sw $t8, 0($t3)

  lw $t2, 20($t1)
  add $t3, $t2, $t0
  sw $t8, 0($t3)
  
# Check for keyboard input.
  jal check_keypress
  
# Figure out if the player character is standing on a platform.
  # Check Player-Floor
    jal check_player_floor
  # Check Player-ladder
    jal check_player_ladder
# Check for various collisions (e.g., between player and enemies).
  # Check Red Collision
    jal check_player_dead
  # Check win collisions
    jal check_player_win
    jal check_player_win1
    jal check_player_win2

# Update other game state and end of game.

# Update player location, enemies, platforms, power ups, etc.
  # Move player to the right in a loop
    # update player location
      jal update_player_location 

# Redraw objects in the new position on the screen. 

  # draw player
    jal draw_player

# Sleep (40ms) and loop

sleep:		
  la $t0, Sleep
  lw $t0, 0($t0)
  li $v0, 32
  addi $a0, $t0, 0 # Wait one second (1000 milliseconds)
  syscall

	j main_loop

init: 
	# Load Inital player location into array
    la $t9, Player_position
    addi $t2, $zero, 520
    sw $t2, 0($t9)
    addi $t2, $zero, 524
    sw $t2, 4($t9)
    addi $t2, $zero, 776
    sw $t2, 8($t9)
    addi $t2, $zero, 780
    sw $t2, 12($t9)
    addi $t2, $zero, 1032
    sw $t2, 16($t9)
    addi $t2, $zero, 1036
    sw $t2, 20($t9)

  # Load Inital Player Colors
    la $t9, Player_colors
    li $t8, BLUE
    sw $t8, 0($t9)
    sw $t8, 4($t9)

    li $t8, SKIN
    sw $t8, 8($t9)
    sw $t8, 12($t9)
    sw $t8, 16($t9)
    sw $t8, 20($t9)

  # Load Platform_1
    li $t0, BASE_ADDRESS
    la $t1, Floor

    li $t4, 8196
    
    li $t8, GREEN
    li $t9, 1 

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Platform_2
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, GREEN
    li $t4, 8324

    li $t9, 1

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Bottom Floor Location 
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 15876
    li $t8, GREEN

    li $t9, 1


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Border Floor
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 16128
    li $t8, RED
    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Wall right
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 252
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Wall left
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 0
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Ceiling
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 0
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Star 
    # Load Ceiling
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 15336
    li $t8, PURPLE

    li $t9, 4


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    sub $t4, $t4, 8
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 512
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Score 0
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, WHITE
    li $t4, 1004

    li $t9, 2

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    # Delete You LOST
      # Letter Y
        li $t0, BASE_ADDRESS
        la $t1, Floor
        li $t8, BLACK
        li $t4, 11024

        li $t9, 0

        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        add $t4, $t4, 4
        add $t4, $t4, 256
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        add $t4, $t4, 4
        add $t4, $t4, 256
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        add $t4, $t4, 256
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        add $t4, $t4, 256
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        add $t4, $t4, 256
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        sub $t4, $t4, 1024
        add $t4, $t4, 4
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        sub $t4, $t4, 256
        add $t4, $t4, 4
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)
    
      # Letter o

      add $t4, $t4, 28
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      # Letter U
      add $t4, $t4, 28
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 16

     # Letter L
      add $t4, $t4, 40
      add $t4, $t4, 1024
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 16

      # Letter o

      add $t4, $t4, 28
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      # Letter S

      add $t4, $t4, 28
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 512
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 512
      sub $t4, $t4, 256

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)


      sub $t4, $t4, 16
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      # Letter T
      add $t4, $t4, 12
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      sub $t4, $t4, 1024
      sub $t4, $t4, 256

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      # Exclamation Mark
      add $t4, $t4, 16
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 512

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)


  j reset

init2: 
	# Load Inital player location into array
    la $t9, Player_position
    addi $t2, $zero, 520
    sw $t2, 0($t9)
    addi $t2, $zero, 524
    sw $t2, 4($t9)
    addi $t2, $zero, 776
    sw $t2, 8($t9)
    addi $t2, $zero, 780
    sw $t2, 12($t9)
    addi $t2, $zero, 1032
    sw $t2, 16($t9)
    addi $t2, $zero, 1036
    sw $t2, 20($t9)

  # Load Inital Player Colors
    la $t9, Player_colors
    li $t8, BLUE
    sw $t8, 0($t9)
    sw $t8, 4($t9)

    li $t8, SKIN
    sw $t8, 8($t9)
    sw $t8, 12($t9)
    sw $t8, 16($t9)
    sw $t8, 20($t9)

  # Load Platform_1
    li $t0, BASE_ADDRESS
    la $t1, Floor

    li $t4, 8196
    
    li $t8, GREEN
    li $t9, 1 

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Platform_2
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, GREEN
    li $t4, 8324

    li $t9, 1

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Platform_2 ladder
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, WHITE
    li $t4, 8320

    li $t9, 2

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Bottom Floor Location 
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 15876
    li $t8, GREEN

    li $t9, 1


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Border Floor
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 16128
    li $t8, RED
    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Wall right
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 252
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Wall left
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 0
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Ceiling
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 0
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Star 
    # Load Ceiling
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 15336
    li $t8, ORANGE

    li $t9, 5


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    sub $t4, $t4, 8
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 512
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Delete Score 0
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, BLACK
    li $t4, 1004

    li $t9, 2

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Score |
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, WHITE
    li $t4, 1004

    li $t9, 2

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Speed up time by 20 ms

  la $t0, Sleep
  lw $t1, 0($t0), # load value of sleep
  sub $t1, $t1, 60
  sw $t1, 0($t0)

  j reset

init3: 
	# Load Inital player location into array
    la $t9, Player_position
    addi $t2, $zero, 520
    sw $t2, 0($t9)
    addi $t2, $zero, 524
    sw $t2, 4($t9)
    addi $t2, $zero, 776
    sw $t2, 8($t9)
    addi $t2, $zero, 780
    sw $t2, 12($t9)
    addi $t2, $zero, 1032
    sw $t2, 16($t9)
    addi $t2, $zero, 1036
    sw $t2, 20($t9)

  # Load Inital Player Colors
    la $t9, Player_colors
    li $t8, BLUE
    sw $t8, 0($t9)
    sw $t8, 4($t9)

    li $t8, SKIN
    sw $t8, 8($t9)
    sw $t8, 12($t9)
    sw $t8, 16($t9)
    sw $t8, 20($t9)

  # Load Platform_1
    li $t0, BASE_ADDRESS
    la $t1, Floor

    li $t4, 8196
    
    li $t8, GREEN
    li $t9, 1 

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Platform_2
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, GREEN
    li $t4, 8324

    li $t9, 1

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Platform_2 ladder
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, WHITE
    li $t4, 8320

    li $t9, 2

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Border Floor
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 16128
    li $t8, RED
    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Bottom Floor Location 
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 15876
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


  # Load Wall right
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 252
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Wall left
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 0
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Ceiling
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 0
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Star 
    # Load Ceiling
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 15336
    li $t8, YELLOW

    li $t9, 6


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    sub $t4, $t4, 8
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 512
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Score 2
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, WHITE
    li $t4, 1004

    li $t9, 2

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    

    add $t4, $t4, 16

    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    li $t8, BLACK

    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


  la $t0, Sleep
  lw $t1, 0($t0), # load value of sleep
  add $t1, $t1, 100
  sw $t1, 0($t0)

  j reset

init4: 
	# Load Inital player location into array
    la $t9, Player_position
    addi $t2, $zero, 520
    sw $t2, 0($t9)
    addi $t2, $zero, 524
    sw $t2, 4($t9)
    addi $t2, $zero, 776
    sw $t2, 8($t9)
    addi $t2, $zero, 780
    sw $t2, 12($t9)
    addi $t2, $zero, 1032
    sw $t2, 16($t9)
    addi $t2, $zero, 1036
    sw $t2, 20($t9)

  # Load Inital Player Colors
    la $t9, Player_colors
    li $t8, BLUE
    sw $t8, 0($t9)
    sw $t8, 4($t9)

    li $t8, SKIN
    sw $t8, 8($t9)
    sw $t8, 12($t9)
    sw $t8, 16($t9)
    sw $t8, 20($t9)

  # Load Platform_1
    li $t0, BASE_ADDRESS
    la $t1, Floor

    li $t4, 8196
    
    li $t8, GREEN
    li $t9, 1 

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Platform_2
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, GREEN
    li $t4, 8324

    li $t9, 1

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Platform_2 ladder
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, BLACK
    li $t4, 8320

    add $t4, $t4, 256

    li $t9, 2

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Border Floor
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 16128
    li $t8, RED
    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Bottom Floor Location 
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 15876
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


  # Load Wall right
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 252
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Wall left
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 0
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Ceiling
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 0
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Star 
    # Load Ceiling
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 15336
    li $t8, BLACK

    li $t9, 6


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    sub $t4, $t4, 8
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 512
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Score 3
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, WHITE
    li $t4, 1004

    li $t9, 2

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    

    add $t4, $t4, 16

    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 16 


    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    li $t8, BLACK

    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load You Win!
    
    # Letter Y
      li $t0, BASE_ADDRESS
      la $t1, Floor
      li $t8, WHITE
      li $t4, 11024

      li $t9, 2

      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      sub $t4, $t4, 1024
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      sub $t4, $t4, 256
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

    # Letter o

      add $t4, $t4, 28
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

    # Letter U
      add $t4, $t4, 28
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 16

    # Letter W

      add $t4, $t4, 48
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 32
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

    # Letter o

      add $t4, $t4, 44
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

    # Letter n

      add $t4, $t4, 28
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 16
      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

    # Exclamation Mark
      add $t4, $t4, 16
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 512

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)


  la $t0, Sleep
  lw $t1, 0($t0), # load value of sleep
  add $t1, $zero, 40
  sw $t1, 0($t0)

  j reset

init5: 
	# Load Inital player location into array
    la $t9, Player_position
    addi $t2, $zero, 520
    sw $t2, 0($t9)
    addi $t2, $zero, 524
    sw $t2, 4($t9)
    addi $t2, $zero, 776
    sw $t2, 8($t9)
    addi $t2, $zero, 780
    sw $t2, 12($t9)
    addi $t2, $zero, 1032
    sw $t2, 16($t9)
    addi $t2, $zero, 1036
    sw $t2, 20($t9)

  # Load Inital Player Colors
    la $t9, Player_colors
    li $t8, BLUE
    sw $t8, 0($t9)
    sw $t8, 4($t9)

    li $t8, SKIN
    sw $t8, 8($t9)
    sw $t8, 12($t9)
    sw $t8, 16($t9)
    sw $t8, 20($t9)

  # Load Platform_1
    li $t0, BASE_ADDRESS
    la $t1, Floor

    li $t4, 8196
    
    li $t8, GREEN
    li $t9, 1 

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Platform_2
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, GREEN
    li $t4, 8324

    li $t9, 1

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Platform_2 ladder
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, BLACK
    li $t4, 8320

    add $t4, $t4, 256

    li $t8, BLACK
    li $t9, 0

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Border Floor
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 16128
    li $t8, RED
    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Bottom Floor Location 
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 15876
    li $t8, BLACK
    li $t9, 0


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Wall right
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 252
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Wall left
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 0
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Ceiling
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 0
    li $t8, RED

    li $t9, 3


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Star 
    # Load Ceiling
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t4, 15336
    li $t8, BLACK

    li $t9, 0


    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    sub $t4, $t4, 8
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 512
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

  # Load Score 2
    li $t0, BASE_ADDRESS
    la $t1, Floor
    li $t8, BLACK
    li $t4, 1004

    li $t9, 0

    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    

    add $t4, $t4, 16

    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    add $t4, $t4, 4
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)

    li $t8, BLACK

    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)
    sub $t4, $t4, 256
    add $t5, $t4, $t0
    sw $t8, 0($t5)
    add $t5 $t4, $t1
    sw $t9, 0($t5)


  # Load You LOST
    # Letter Y
        li $t0, BASE_ADDRESS
        la $t1, Floor
        li $t8, WHITE
        li $t4, 11024

        li $t9, 2

        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        add $t4, $t4, 4
        add $t4, $t4, 256
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        add $t4, $t4, 4
        add $t4, $t4, 256
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        add $t4, $t4, 256
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        add $t4, $t4, 256
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        add $t4, $t4, 256
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        sub $t4, $t4, 1024
        add $t4, $t4, 4
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)

        sub $t4, $t4, 256
        add $t4, $t4, 4
        add $t5, $t4, $t0
        sw $t8, 0($t5)
        add $t5 $t4, $t1
        sw $t9, 0($t5)
    
    # Letter o

      add $t4, $t4, 28
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

    # Letter U
      add $t4, $t4, 28
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 16

    # Letter L
      add $t4, $t4, 40
      add $t4, $t4, 1024
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 16

    # Letter o

      add $t4, $t4, 28
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

    # Letter S

      add $t4, $t4, 28
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 512
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      
      sub $t4, $t4, 512
      sub $t4, $t4, 256

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)


      sub $t4, $t4, 16
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      sub $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

    # Letter T
      add $t4, $t4, 12
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      sub $t4, $t4, 1024
      sub $t4, $t4, 256

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 4
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

    # Exclamation Mark
      add $t4, $t4, 16
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)
      add $t4, $t4, 512

      add $t4, $t4, 256
      add $t5, $t4, $t0
      sw $t8, 0($t5)
      add $t5 $t4, $t1
      sw $t9, 0($t5)

  la $t0, Sleep
  lw $t1, 0($t0), # load value of sleep
  add $t1, $zero, 100
  sw $t1, 0($t0)

  j reset

reset:
	# Load Inital player location into array
    la $t9, Player_position
    addi $t2, $zero, 520
    sw $t2, 0($t9)
    addi $t2, $zero, 524
    sw $t2, 4($t9)
    addi $t2, $zero, 776
    sw $t2, 8($t9)
    addi $t2, $zero, 780
    sw $t2, 12($t9)
    addi $t2, $zero, 1032
    sw $t2, 16($t9)
    addi $t2, $zero, 1036
    sw $t2, 20($t9)

  jr $ra
	
check_keypress: 
  # check_keypress()
  # move character 
  # wasd -> up | left | down | right
	# t9 store keypress info
	# t8 - 1 if keypressed, 0 o/w
	# t2 - store hex value of keypressed

	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, keypress_happened
	j keypress_done

keypress_happened:
	# key is pressed
	lw $t2, 4($t9)
	# reset keypress
	li $t8, 0 # set keypress to 0 
	# beq $t2, 
	beq $t2, 0x61, respond_to_a
	beq $t2, 0x64, respond_to_d
	beq $t2, 0x77, respond_to_w
	beq $t2, 0x65, respond_to_e
	beq $t2, 0x70, respond_to_p
	beq $t2, 0x6f, respond_to_o

respond_to_a:
	j move_left

respond_to_d:
	j move_right

respond_to_w:
  j move_up

respond_to_s:


respond_to_e:
	j keypress_done
	
respond_to_p:
	j main

respond_to_o:
	# print stats
	# Load player into array
	la $t9, Player_position
	li $v0, 1
	lw $a0, 0($t9)
	syscall
	li $v0, 1
	lw $a0, 4($t9)
	syscall
	li $v0, 1
	lw $a0, 8($t9)
	syscall
	li $v0, 1
	lw $a0, 12($t9)
	syscall
	j keypress_done

keypress_done:
	jr $ra	

update_player_location:
  j gravity

gravity: 

  la $t9, Player_position
	lw $t0, 0($t9)
	add $t0, $t0, 256
	sw $t0, 0($t9)
	lw $t0, 4($t9)
	add $t0, $t0, 256
	sw $t0, 4($t9)
	lw $t0, 8($t9)
	add $t0, $t0, 256
	sw $t0, 8($t9)
	lw $t0, 12($t9)
	add $t0, $t0, 256
	sw $t0, 12($t9)
  lw $t0, 16($t9)
	add $t0, $t0, 256
	sw $t0, 16($t9)
  lw $t0, 20($t9)
	add $t0, $t0, 256
	sw $t0, 20($t9)
  jr $ra 

check_player_floor:
  la $t9, Player_position
  la $t8, Floor
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 1, end_player_floor
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 1, end_player_floor
  jr $ra

end_player_floor:
  # cancel gravity
	lw $t0, 0($t9)
	sub $t0, $t0, 256
	sw $t0, 0($t9)
	lw $t0, 4($t9)
	sub $t0, $t0, 256
	sw $t0, 4($t9)
	lw $t0, 8($t9)
	sub $t0, $t0, 256
	sw $t0, 8($t9)
	lw $t0, 12($t9)
	sub $t0, $t0, 256
	sw $t0, 12($t9)
  lw $t0, 16($t9)
	sub $t0, $t0, 256
	sw $t0, 16($t9)
  lw $t0, 20($t9)
	sub $t0, $t0, 256
	sw $t0, 20($t9)
  jr $ra

check_player_dead:
  la $t9, Player_position
  la $t8, Floor

  # Top two pixels
  lw $t0, 0($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 3, end_player_dead

  lw $t0, 0($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 3, end_player_dead

  lw $t0, 4($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 3, end_player_dead

  lw $t0, 4($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 3, end_player_dead

  # Middle two pixels
  lw $t0, 8($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 3, end_player_dead

  lw $t0, 12($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 3, end_player_dead

  # Bottom two pixels
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 3, end_player_dead
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 3, end_player_dead
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 3, end_player_dead
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 3, end_player_dead
  jr $ra

end_player_dead:
  # reset
  j init5
  jr $ra

check_player_ladder:
  la $t9, Player_position
  la $t8, Floor


  # Top two pixels
  lw $t0, 0($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 2, end_player_ladder

  lw $t0, 0($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 2, end_player_ladder

  lw $t0, 4($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 2, end_player_ladder

  lw $t0, 4($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 2, end_player_ladder

  # Middle two pixels
  lw $t0, 8($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 2, end_player_ladder

  lw $t0, 12($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 2, end_player_ladder

  # Bottom two pixels
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 2, end_player_ladder
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 2, end_player_ladder
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 2, end_player_ladder
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 2, end_player_ladder
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 2, end_player_ladder
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 2, end_player_ladder
  
  jr $ra

end_player_ladder:
  # cancel gravity
	lw $t0, 0($t9)
	sub $t0, $t0, 256
	sw $t0, 0($t9)
	lw $t0, 4($t9)
	sub $t0, $t0, 256
	sw $t0, 4($t9)
	lw $t0, 8($t9)
	sub $t0, $t0, 256
	sw $t0, 8($t9)
	lw $t0, 12($t9)
	sub $t0, $t0, 256
	sw $t0, 12($t9)
  lw $t0, 16($t9)
	sub $t0, $t0, 256
	sw $t0, 16($t9)
  lw $t0, 20($t9)
	sub $t0, $t0, 256
	sw $t0, 20($t9)

check_player_win:
  la $t9, Player_position
  la $t8, Floor

 # Top two pixels
  lw $t0, 0($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 4, end_player_win

  lw $t0, 0($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 4, end_player_win

  lw $t0, 4($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 4, end_player_win

  lw $t0, 4($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 4, end_player_win

  # Middle two pixels
  lw $t0, 8($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 4, end_player_win

  lw $t0, 12($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 4, end_player_win

  # Bottom two pixels
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 4, end_player_win
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 4, end_player_win
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 4, end_player_win
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 4, end_player_win
  jr $ra

end_player_win:
  j init2
  jr $ra

check_player_win1:
  la $t9, Player_position
  la $t8, Floor

 # Top two pixels
  lw $t0, 0($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 5, end_player_win1

  lw $t0, 0($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 5, end_player_win1

  lw $t0, 4($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 5, end_player_win1

  lw $t0, 4($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 5, end_player_win1

  # Middle two pixels
  lw $t0, 8($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 5, end_player_win1

  lw $t0, 12($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 5, end_player_win1

  # Bottom two pixels
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 5, end_player_win1
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 5, end_player_win1
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 5, end_player_win1
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 5, end_player_win1
  jr $ra

end_player_win1:
  j init3
  jr $ra

check_player_win2:
  la $t9, Player_position
  la $t8, Floor

 # Top two pixels
  lw $t0, 0($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 6, end_player_win2

  lw $t0, 0($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 6, end_player_win2

  lw $t0, 4($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 6, end_player_win2

  lw $t0, 4($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 6, end_player_win2

  # Middle two pixels
  lw $t0, 8($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 6, end_player_win2

  lw $t0, 12($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 6, end_player_win2

  # Bottom two pixels
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 6, end_player_win2
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 6, end_player_win2
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 6, end_player_win2
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 6, end_player_win2
  jr $ra

end_player_win2:
  j init4
  jr $ra

end_prog:	
	# end program
	li $v0, 10
	syscall

move_right:
	la $t9, Player_position
	lw $t0, 0($t9)
	add $t0, $t0, 4
	sw $t0, 0($t9)
	lw $t0, 4($t9)
	add $t0, $t0, 4
	sw $t0, 4($t9)
	lw $t0, 8($t9)
	add $t0, $t0, 4
	sw $t0, 8($t9)
	lw $t0, 12($t9)
	add $t0, $t0, 4
	sw $t0, 12($t9)
  	lw $t0, 16($t9)
	add $t0, $t0, 4
	sw $t0, 16($t9)
  	lw $t0, 20($t9)
	add $t0, $t0, 4
	sw $t0, 20($t9)
  j keypress_done

move_left:
	la $t9, Player_position
	lw $t0, 0($t9)
	sub $t0, $t0, 4
	sw $t0, 0($t9)
	lw $t0, 4($t9)
	sub $t0, $t0, 4
	sw $t0, 4($t9)
	lw $t0, 8($t9)
	sub $t0, $t0, 4
	sw $t0, 8($t9)
	lw $t0, 12($t9)
	sub $t0, $t0, 4
	sw $t0, 12($t9)
  	lw $t0, 16($t9)
	sub $t0, $t0, 4
	sw $t0, 16($t9)
  	lw $t0, 20($t9)
	sub $t0, $t0, 4
	sw $t0, 20($t9)
  j keypress_done

move_up:
  # check if player is touching ladder
  la $t9, Player_position
  la $t8, Floor

  # Top two pixels
  lw $t0, 0($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 2, end_move_up

  lw $t0, 0($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 2, end_move_up

  lw $t0, 4($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 2, end_move_up

  lw $t0, 4($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 2, end_move_up

  # Middle two pixels
  lw $t0, 8($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 2, end_move_up

  lw $t0, 12($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 2, end_move_up

  # Bottom two pixels
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  sub $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 2, end_move_up
  lw $t0, 16($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 2, end_move_up
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 256
  lw $t1, 0($t5)
  beq $t1, 2, end_move_up
  lw $t0, 20($t9)
  add $t5, $t8, $t0
  addi $t5, $t5, 4
  lw $t1, 0($t5)
  beq $t1, 2, end_move_up
  jr $ra
  
end_move_up:
	la $t9, Player_position
	lw $t0, 0($t9)
	sub $t0, $t0, 256
	sw $t0, 0($t9)
	lw $t0, 4($t9)
	sub $t0, $t0, 256
	sw $t0, 4($t9)
	lw $t0, 8($t9)
	sub $t0, $t0, 256
	sw $t0, 8($t9)
	lw $t0, 12($t9)
	sub $t0, $t0, 256
	sw $t0, 12($t9)
  	lw $t0, 16($t9)
	sub $t0, $t0, 256
	sw $t0, 16($t9)
  	lw $t0, 20($t9)
	sub $t0, $t0, 256
	sw $t0, 20($t9)
  jr $ra

move_down:

draw_player:
    # $t0 stores the base address for display
    # $t1 stores Player_position
    # $t2 stores Player_colors
    la $t2, Player_colors
    la $t1, Player_position
    li $t0, BASE_ADDRESS 

    li $t8, SKIN # stores the red colour code
    lw $t5, 0($t1)
    add $t6, $t5, $t0
    sw $t8, 0($t6)

    lw $t5, 4($t1)
    add $t6, $t5, $t0
    sw $t8, 0($t6)

    li $t8, BLUE # $t1 stores the red colour code
    lw $t5, 8($t1)
    add $t6, $t5, $t0
    sw $t8, 0($t6)

    lw $t5, 12($t1)
    add $t6, $t5, $t0
    sw $t8, 0($t6)

    lw $t5, 16($t1)
    add $t6, $t5, $t0
    sw $t8, 0($t6)

    lw $t5, 20($t1)
    add $t6, $t5, $t0
    sw $t8, 0($t6)
    jr $ra
