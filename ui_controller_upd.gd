extends Control

@onready var upgrade_buttons = {
    UpgradeSystem.UpgradeType.AXE: $UpgradePanel/AxeButton,
    UpgradeSystem.UpgradeType.PICKAXE: $UpgradePanel/PickaxeButton
}

@onready var player = get_node("/root/Game/Player")
@onready var upgrade_system = get_node("/root/Game/UpgradeSystem")

func _ready():
    upgrade_system.upgrade_purchased.connect(_on_upgrade_purchased)
    for upgrade_type in upgrade_buttons:
        var button = upgrade_buttons[upgrade_type]
        button.pressed.connect(_on_upgrade_button_pressed.bind(upgrade_type))
    update_upgrade_buttons()

func _on_upgrade_button_pressed(upgrade_type: UpgradeSystem.UpgradeType):
    if upgrade_system.purchase_upgrade(upgrade_type, player.resources):
        update_upgrade_buttons()

func _on_upgrade_purchased(upgrade_type: UpgradeSystem.UpgradeType, new_level: int):
    var upgrade_name = UpgradeSystem.UpgradeType.keys()[upgrade_type]
    show_notification("Улучшено %s до уровня %d" % [upgrade_name, new_level])
    update_upgrade_buttons()

func update_upgrade_buttons():
    for upgrade_type in upgrade_buttons:
        var button = upgrade_buttons[upgrade_type]
        var info = upgrade_system.get_upgrade_info(upgrade_type)
        
        button.text = "%s (Ур. %d/%d)" % [
            info.name,
            info.level,
            info.max_level
        ]
        
        var cost_text = ""
        for resource in info.cost:
            cost_text += "%s: %d\n" % [resource.capitalize(), info.cost[resource]]
        
        button.tooltip_text = cost_text
        button.disabled = not upgrade_system.can_afford_upgrade(upgrade_type, player.resources) or info.level >= info.max_level

func show_notification(text: String):
    $NotificationLabel.text = text
    $NotificationAnimation.play("show_notification")
