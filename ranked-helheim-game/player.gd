extends RigidBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D

# check if player is on ground or not
func is_grounded() -> bool:
	return raycast.is_colliding()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_grounded():
		animation.play("jumping")
	else:
		animation.play("default")
