extends CharacterBody3D

# Настройки движения
@export var move_speed : float = 5.0
@export var sprint_speed : float = 8.0
@export var jump_force : float = 4.5
@export var mouse_sensitivity : float = 0.2

# Настройки добычи ресурсов
@export var harvest_range : float = 2.0
@export var harvest_cooldown : float = 0.5
@export var harvest_damage : int = 1

# Ресурсы игрока
var resources : Dictionary = {
    "wood": 0,
    "stone": 0,
    "iron": 0,
    "gold": 0
}

# Системные переменные
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_speed : float = move_speed
var can_harvest : bool = true
var health : int = 100
var max_health : int = 100

# Ноды
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var raycast := $Neck/Camera3D/RayCast3D
@onready var animation_player := $AnimationPlayer
@onready var harvest_timer := $HarvestTimer

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    harvest_timer.wait_time = harvest_cooldown

func _input(event):
    if event is InputEventMouseMotion:
        rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
        neck.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
        neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
    # Гравитация
    if not is_on_floor():
        velocity.y -= gravity * delta
    
    # Прыжок
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_force
    
    # Бег
    current_speed = sprint_speed if Input.is_action_pressed("sprint") else move_speed
    
    # Движение
    var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    if direction:
        velocity.x = direction.x * current_speed
        velocity.z = direction.z * current_speed
    else:
        velocity.x = move_toward(velocity.x, 0, current_speed)
        velocity.z = move_toward(velocity.z, 0, current_speed)
    
    move_and_slide()
    
    # Добыча ресурсов
    if Input.is_action_pressed("harvest") and can_harvest:
        try_harvest()

func try_harvest():
    if raycast.is_colliding():
        var target = raycast.get_collider()
        if target.is_in_group("harvestable"):
            harvest(target)

func harvest(target: Node3D):
    can_harvest = false
    animation_player.play("axe_swing")
    
    # Наносим "урон" ресурсу
    target.take_damage(harvest_damage)
    
    harvest_timer.start()

func _on_harvest_timer_timeout():
    can_harvest = true

func add_resource(resource_type: String, amount: int):
    if resources.has(resource_type):
        resources[resource_type] += amount
        print("Получено ", amount, " ", resource_type, ". Всего: ", resources[resource_type])
        # Здесь можно добавить визуальный эффект или звук получения ресурса
    else:
        print("Неизвестный тип ресурса: ", resource_type)
