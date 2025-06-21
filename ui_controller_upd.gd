extends Control

@onready var upgrade_buttons = {
    UpgradeSystem.UpgradeID.AXE: $UpgradePanel/AxeUpgradeButton,
    UpgradeSystem.UpgradeID.PICKAXE: $UpgradePanel/PickaxeUpgradeButton
}

@onready var player = get_node("/root/Game/Player")
@onready var upgrade_system = get_node("/root/Game/UpgradeSystem")

func _ready():
    upgrade_system.upgrade_purchased.connect(_on_upgrade_purchased)
    _update_all_buttons()

func _on_upgrade_button_pressed(upgrade_id: UpgradeSystem.UpgradeID):
    if upgrade_system.purchase_upgrade(upgrade_id, player.resources):
        _play_upgrade_effect(upgrade_buttons[upgrade_id])

func _on_upgrade_purchased(_upgrade_id: UpgradeSystem.UpgradeID, _new_level: int):
    _update_all_buttons()
    $Notification.show_message("Улучшение куплено!")

func _update_all_buttons():
    for upgrade_id in upgrade_buttons:
        _update_button(upgrade_id)

func _update_button(upgrade_id: UpgradeSystem.UpgradeID):
    var button = upgrade_buttons[upgrade_id]
    var info = upgrade_system.get_upgrade_info(upgrade_id)
    
    if info.is_empty():
        button.visible = false
        return
    
    # Основная информация
    button.text = "%s (Ур. %d/%d)" % [info.name, info.level, info.max_level]
    
    # Описание стоимости
    var cost_text = "Стоимость:\n"
    for resource in info.cost:
        cost_text += "%s: %d\n" % [resource.capitalize(), info.cost[resource]]
    
    # Описание эффектов
    var effect_text = "Текущий эффект: %.1f\n" % info.value
    if info.level < info.max_level:
        effect_text += "Следующий уровень: %.1f" % info.next_value
    else:
        effect_text += "Макс. уровень"
    
    button.tooltip_text = "%s\n\n%s\n\n%s" % [
        info.description,
        cost_text,
        effect_text
    ]
    
    # Состояние кнопки
    button.disabled = not upgrade_system.can_afford_upgrade(upgrade_id, player.resources) or info.level >= info.max_level

func _play_upgrade_effect(button: Button):
    var tween = create_tween()
    tween.tween_property(button, "modulate", Color.GOLD, 0.2)
    tween.tween_property(button, "modulate", Color.WHITE, 0.2)
