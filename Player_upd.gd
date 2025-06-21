extends CharacterBody3D

@export var tool_models: Dictionary = {
    "axe": $ToolAnchor/AxeModel,
    "pickaxe": $ToolAnchor/PickaxeModel,
    "hat": $Head/HatModel
}

var resources = {
    "wood": 0,
    "stone": 0,
    "iron": 0,
    "cloth": 0
}

var speed_multiplier: float = 1.0
var base_speed: float = 5.0

func _ready():
    var upgrade_system = get_node("/root/UpgradeSystem")
    upgrade_system.upgrade_purchased.connect(_on_upgrade_purchased)
    upgrade_system.tool_model_changed.connect(_on_tool_model_changed)

func equip_hat(model_path: String):
    if model_path == null:
        tool_models["hat"].visible = false
        return
    
    var new_hat = load(model_path).instantiate()
    tool_models["hat"].queue_free()
    tool_models["hat"] = new_hat
    $Head.add_child(new_hat)
    new_hat.visible = true

func _on_upgrade_purchased(upgrade_type, new_level):
    var upgrade_system = get_node("/root/UpgradeSystem")
    match upgrade_type:
        UpgradeSystem.UpgradeType.HAT:
            speed_multiplier = 1.0 + 0.1 * new_level
        UpgradeSystem.UpgradeType.AXE:
            $HarvestComponent.tree_damage = 1.0 + 0.3 * (new_level - 1)
        UpgradeSystem.UpgradeType.PICKAXE:
            $HarvestComponent.rock_damage = 1.0 + 0.4 * (new_level - 1)

func _on_tool_model_changed(tool_type, model_index):
    var upgrade_system = get_node("/root/UpgradeSystem")
    var model_path = upgrade_system.upgrades[tool_type].model_paths[model_index]
    
    var new_model = load(model_path).instantiate()
    var tool_name = "axe" if tool_type == UpgradeSystem.UpgradeType.AXE else "pickaxe"
    
    tool_models[tool_name].queue_free()
    tool_models[tool_name] = new_model
    $ToolAnchor.add_child(new_model)

func _physics_process(delta):
    var move_speed = base_speed * speed_multiplier
    # ... остальная логика движения
