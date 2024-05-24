extends CharacterBody2D


#region var
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D

var conqueror = null
var block = null
var speed = 128
var direction : Vector2
var target = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	conqueror = input_.conqueror
	block = input_.block
	
	init_basic_setting()


func init_basic_setting() -> void:
	position = Vector2(-100, -100)#block.get_global_position()
	
	Global.rng.randomize()
	var angle = Global.rng.randf_range(0, PI * 2)
	direction = Vector2.from_angle(angle)
	#sprite.frame = conqueror.god.index
#endregion


func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

