extends CharacterBody2D

const SPEED = 300.0
const RUNNING_SPEED = 500.0
const JUMP_VELOCITY = -400.0
const QUICKDROP_SPEED = 400.0

var is_running = false

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D

func _ready() -> void:
	animation.play("default")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		#quickdrop here when player presses S so it imitates brawlhalla
		if Input.is_key_pressed(KEY_S):
			velocity.y = QUICKDROP_SPEED

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A))
	
	is_running = false
	if direction:
		if Input.is_key_pressed(KEY_L):
			velocity.x = direction * RUNNING_SPEED
			is_running = true
		else:
			velocity.x = direction * SPEED
		animation.flip_h = direction < 0 # flip user
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	if not is_on_floor():
		# jumping animation is wacky
		if velocity.y < 0:
			animation.play("jumping")
		elif raycast.is_colliding():
			animation.play("landing")
		else:
			animation.play("falling")
	elif is_running:
		animation.play("running")
	elif direction: # check if direction is more than 0 or true
		animation.play("walking")
	else:
		animation.play("default")
