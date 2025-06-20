extends Node

# Уровни улучшений
var upgrades = {
    "axe": {
        "level": 1,
        "damage": 1,
        "costs": [
            {"wood": 10, "stone": 5},
            {"wood": 20, "stone": 10, "iron": 2},
            {"wood": 30, "stone": 15, "iron": 5}
        ]
    },
    "pickaxe": {
        "level": 1,
        "damage": 1,
        "costs": [
            {"wood": 5, "stone": 10},
            {"wood": 10, "stone": 20, "iron": 3},
            {"wood": 15, "stone": 30, "iron": 8}
        ]
    },
    "backpack": {
        "level": 1,
        "capacity": 100,
        "costs": [
            {"wood": 15, "stone": 5},
            {"wood": 30, "stone": 10, "iron": 3},
            {"wood": 50, "stone": 20, "iron": 10}
        ]
    }
}

func can_afford_upgrade(upgrade_type: String, player_resources: Dictionary) -> bool:
    if not upgrades.has(upgrade_type):
        return false
    
    var current_level = upgrades[upgrade_type]["level"]
    if current_level >= upgrades[upgrade_type]["costs"].size():
        return false
    
    var cost = upgrades[upgrade_type]["costs"][current_level - 1]
    
    for resource in cost:
        if player_resources.get(resource, 0) < cost[resource]:
            return false
    
    return true

func purchase_upgrade(upgrade_type: String, player_resources: Dictionary) -> bool:
    if not can_afford_upgrade(upgrade_type, player_resources):
        return false
    
    var current_level = upgrades[upgrade_type]["level"]
    var cost = upgrades[upgrade_type]["costs"][current_level - 1]
    
    # Вычитаем ресурсы
    for resource in cost:
        player_resources[resource] -= cost[resource]
    
    # Улучшаем
    upgrades[upgrade_type]["level"] += 1
    
    # Применяем улучшение
    match upgrade_type:
        "axe", "pickaxe":
            upgrades[upgrade_type]["damage"] += 1
        "backpack":
            upgrades[upgrade_type]["capacity"] += 50
    
    return true

func get_upgrade_info(upgrade_type: String) -> Dictionary:
    if upgrades.has(upgrade_type):
        return upgrades[upgrade_type].duplicate()
    return {}
