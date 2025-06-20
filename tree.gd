extends StaticBody3D

@export var resource_type : String = "wood"
@export var resource_amount : int = 3
@export var health : int = 3
@export var drop_prefab : PackedScene

var max_health : int = health

func _ready():
    add_to_group("harvestable")
    max_health = health

func take_damage(damage: int):
    health -= damage
    
    # Проигрываем анимацию получения урона
    $AnimationPlayer.play("hit")
    
    if health <= 0:
        destroy()

func destroy():
    # Создаем дроп
    if drop_prefab:
        var drop = drop_prefab.instantiate()
        get_parent().add_child(drop)
        drop.global_transform = global_transform
        drop.resource_type = resource_type
        drop.resource_amount = resource_amount
    
    # Удаляем ресурс
    queue_free()
