extends Node

@onready var player = $Player
@onready var world = $World
@onready var ui = $UI

func _ready():
    # Инициализация систем
    var upgrade_system = UpgradeSystem.new()
    add_child(upgrade_system)
    upgrade_system.name = "UpgradeSystem"
    
    # Связываем ссылки
    ui.player = player
    ui.upgrade_system = upgrade_system
    
    # Спавн начальных ресурсов
    spawn_initial_resources()

func spawn_initial_resources():
    var tree_scene = preload("res://objects/tree.tscn")
    var rock_scene = preload("res://objects/rock.tscn")
    var iron_scene = preload("res://objects/iron_ore.tscn")
    
    for i in 20:
        var tree = tree_scene.instantiate()
        world.add_child(tree)
        tree.position = Vector3(randf_range(-30, 30), 0, randf_range(-30, 30))
        
        var rock = rock_scene.instantiate()
        world.add_child(rock)
        rock.position = Vector3(randf_range(-30, 30), 0, randf_range(-30, 30))
        
        if i % 5 == 0:  # Меньше железной руды
            var iron = iron_scene.instantiate()
            world.add_child(iron)
            iron.position = Vector3(randf_range(-30, 30), 0, randf_range(-30, 30))
