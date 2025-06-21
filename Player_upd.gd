extends CharacterBody3D

# Добавляем экспортируемые переменные для UI
@export var resource_label: Label
@export var upgrade_buttons: Array[Button]

# Ресурсы игрока
var resources = {
    "wood": 0,
    "stone": 0,
    "iron": 0,
    "gold": 0
}

# Ссылка на систему улучшений
var upgrade_system: UpgradeSystem

func _ready():
    # Получаем систему улучшений автоматически
    upgrade_system = get_node("/root/UpgradeSystem")
    update_ui()

func add_resource(resource_type: String, amount: int):
    if resources.has(resource_type):
        resources[resource_type] += amount
        update_ui()
        # Визуальный эффект
        show_resource_popup(resource_type, amount)

func update_ui():
    # Обновляем отображение ресурсов
    resource_label.text = "Дерево: %d\nКамень: %d\nЖелезо: %d\nЗолото: %d" % [
        resources.wood,
        resources.stone,
        resources.iron,
        resources.gold
    ]
    
    # Обновляем кнопки улучшений
    update_upgrade_buttons()

func update_upgrade_buttons():
    for i in range(upgrade_buttons.size()):
        var upgrade_id = i
        var button = upgrade_buttons[i]
        var upgrade_info = upgrade_system.get_upgrade_info(upgrade_id)
        
        button.text = "%s (Ур. %d)" % [upgrade_info.name, upgrade_info.level]
        button.disabled = not upgrade_system.can_afford_upgrade(upgrade_id, resources)

func apply_upgrade_effects():
    # Правильное получение системы улучшений
    var axe_level = upgrade_system.current_levels[UpgradeSystem.UpgradeID.AXE]
    var pickaxe_level = upgrade_system.current_levels[UpgradeSystem.UpgradeID.PICKAXE]
    
    # Применяем эффекты
    $HarvestComponent.damage_multipliers["wood"] = 1.0 + (axe_level - 1) * 0.5
    $HarvestComponent.damage_multipliers["stone"] = 1.0 + (pickaxe_level - 1) * 0.5
