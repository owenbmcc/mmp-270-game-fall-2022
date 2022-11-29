extends KinematicBody2D

# physics settings for player
export var use_gravity = true
export var speed = 100
export var gravity = 800
export var jump_force = 400
export var wall_jump_enabled = false

# member variables 
var velocity = Vector2()
var is_alive = true # to allow scene to run without character updating
var is_moving = true # animate without moving
var is_jumping = false # track if jumping for landing sound

signal player_hit # signal if player is hit by obstacle
signal player_dies

func _ready():
	if not is_on_floor() and use_gravity:
		is_jumping = true

# this function will run every time the game engine updates physics
func _physics_process(delta):
	if is_alive and is_moving:
		movement_update(delta)
		animation_update()

func movement_update(delta):
	velocity.x = 0 # start by assuming player is not moving
	if not use_gravity:
		velocity.y = 0
	
	# capture user input
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	if Input.is_action_pressed("move_right"):
		velocity.x += speed

	if not use_gravity:
		if Input.is_action_pressed("move_up"):
			velocity.y -= speed
		if Input.is_action_pressed("move_down"):
			velocity.y += speed
	
	# apply player velocity
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# apply gravity to player
	if use_gravity:
		velocity.y += gravity * delta
		# detect landing before jump starts
		if is_jumping and (is_on_floor() or is_on_wall()):
			is_jumping = false
			$LandSound.play()
	
		# jump input
		var can_jump = is_on_floor() or (wall_jump_enabled and is_on_wall())
		if Input.is_action_just_pressed("jump") and can_jump:
			velocity.y -= jump_force
			is_jumping = true
			$AnimatedSprite.frame = 0
			$JumpSound.play()
		
		# if player falls below screen
		if is_alive and position.y > get_viewport().size.y * 2:
			is_alive = false
			dies()
			emit_signal("player_hit", is_alive) # player is dead -- change to remove life

func animation_update():	
	if not is_on_floor() and use_gravity:
		$AnimatedSprite.play("Jump")
	elif abs(velocity.x) > 1 || (not use_gravity and velocity.length_squared() > 1):
		$AnimatedSprite.play("Walk")
	else:
		$AnimatedSprite.play("Idle")

	# change sprite direction
	if velocity.x < -1:
		$AnimatedSprite.flip_h = true
	if velocity.x > 1:
		$AnimatedSprite.flip_h = false

func enemy_collision():
	is_alive = false # player movement suspended before determining state
	$AnimatedSprite.play('Hit')
	$HitSound.play()

# after hit animation, test if player is still alive
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'Dies':
		emit_signal('player_dies')
		
	
	if $AnimatedSprite.animation == 'Hit':
		is_alive = true
		emit_signal("player_hit", is_alive) # don't know if player should die yet

# called by scene manager if player out of lives
func dies():
	is_alive = false
	get_tree().reload_current_scene()
	$AnimatedSprite.play('Dies')
	$DiesSound.play()
	
func start_dialog():
	is_moving = false
	$AnimatedSprite.play('Idle')

func end_dialog():
	is_moving = true
