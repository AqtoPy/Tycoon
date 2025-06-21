extends Control

@onready var resource_labels = {
    "wood": $Resources/WoodLabel,
    "stone": $Resources/StoneLabel,
    "iron": $Resources/IronLabel,
    "cloth": $Resources/ClothLabel
}

@onready var upgrade_buttons = {
    UpgradeSystem.UpgradeType.AXE: $UpgradePanel/AxeButton,
    UpgradeSystem.UpgradeType.PICKAXE: $UpgradePanel/PickaxeButton,
    UpgradeSystem.UpgradeType.HAT: $UpgradePanel/HatButton
}

func _ready():
    var upgrade_system = get_node("/root/UpgradeSystem")
    var player = get_node("/root/Game/Player")
    
    for upgrade_type in upgrade_buttons:
        var button = upgrade_buttons[upgrade_type]
        button.pressed.connect(_on_upgrade_pressed.bind(upgrade_type))
    
    update_ui()

func update_ui():
    var player = get_node("/root/Game/Player")
    var upgrade_system = get_node("/root/UpgradeSystem")
    
    # Обновляем ресурсы
    for resource in resource_labels:
        resource_labels[resource].text = str(player.resources.get(resource, 0))
    
    # Обновляем кнопки
    for upgrade_type in upgrade_buttons:
        var button = upgrade_buttons[upgrade_type]
        var upgrade = upgrade_system.upgrades[upgrade_type]
        
        button.text = "%s (Ур. %d/%d)" % [upgrade.name, upgrade.level, upgrade.max_level]
        button.disabled = not upgrade_system.can_afford_upgrade(upgrade_type, player.resources) or upgrade.level >= upgrade.max_level

func _on_upgrade_pressed(upgrade_type):
    var player = get_node("/root/Game/Player")
    var upgrade_system = get_node("/root/UpgradeSystem")
    
    if upgrade_system.purchase_upgrade(upgrade_type, player):
        update_ui()
        $UpgradeSound.play()
