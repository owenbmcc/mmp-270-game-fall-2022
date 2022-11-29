extends KinematicBody2D

# controls player movement

# editor settings
export var speed = 100

# member variables
var is_alive = true
var velocity = Vector2()

func _physics_process(delta):
	if is_alive:
		player_update(delta)

func player_update(delta):
	# assume player is not moving
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_action_pressed("move_right"):
#        velocity.x = velocity.x + speed
		velocity.x += speed # shorthand
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= speed
	
	if Input.is_action_pressed("move_down"):
		velocity.y += speed
	
	velocity = move_and_slide(velocity, Vector2.UP)
