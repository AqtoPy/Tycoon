extends Area3D

@export var resource_type : String = "wood"
@export var resource_amount : int = 1
@export var pickup_range : float = 1.0
@export var float_height : float = 0.5
@export var float_speed : float = 2.0

var time : float = 0.0
var initial_position : Vector3

func _ready():
    initial_position = global_position
    body_entered.connect(_on_body_entered)

func _process(delta):
    time += delta
    # Анимация парения
    global_position.y = initial_position.y + sin(time * float_speed) * float_height

func _on_body_entered(body):
    if body.is_in_group("player"):
        body.add_resource(resource_type, resource_amount)
        queue_free()
