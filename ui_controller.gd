extends Control

@onready var resource_label = $ResourcePanel/ResourceLabel
@onready var health_bar = $HealthPanel/HealthBar
@onready var upgrade_buttons = {
    "axe": $UpgradePanel/AxeUpgradeButton,
    "pickaxe": $UpgradePanel/PickaxeUpgradeButton,
    "backpack": $UpgradePanel/BackpackUpgradeButton
}

var player : Node
var upgrade_system : Node

func _ready():
    player = get_node("/root/Game/Player")
    upgrade_system = get_node("/root/Game/UpgradeSystem")
    
    for button in upgrade_buttons.values():
        button.pressed.connect(_on_upgrade_button_pressed.bind(button.name))

func _process(_delta):
    # Обновляем UI ресурсов
    var resource_text = "Ресурсы:\n"
    for resource in player.resources:
        resource_text += "%s: %d\n" % [resource.capitalize(), player.resources[resource]]
    resource_label.text = resource_text
    
    # Обновляем здоровье
    health_bar.value = (player.health / float(player.max_health)) * 100
    
    # Обновляем кнопки улучшений
    for upgrade_type in upgrade_buttons:
        var button = upgrade_buttons[upgrade_type]
        var upgrade_info = upgrade_system.get_upgrade_info(upgrade_type)
        
        if upgrade_info["level"] <= upgrade_info["costs"].size():
            button.text = "%s (Ур. %d)" % [upgrade_type.capitalize(), upgrade_info["level"]]
            button.disabled = not upgrade_system.can_afford_upgrade(upgrade_type, player.resources)
        else:
            button.text = "%s (Макс.)" % upgrade_type.capitalize()
            button.disabled = true

func _on_upgrade_button_pressed(upgrade_type: String):
    if upgrade_system.purchase_upgrade(upgrade_type, player.resources):
        print("Улучшение куплено: ", upgrade_type)
        # Обновляем соответствующие параметры игрока
        match upgrade_type:
            "axe":
                player.harvest_damage = upgrade_system.upgrades["axe"]["damage"]
            "pickaxe":
                player.harvest_damage = upgrade_system.upgrades["pickaxe"]["damage"]
    else:
        print("Не удалось купить улучшение: ", upgrade_type)
