extends Node

class_name UpgradeSystem

signal upgrade_purchased(upgrade_type, new_level)

enum UPGRADE_TYPES {
    AXE,
    PICKAXE,
    BACKPACK,
    MAGNET
}

var upgrades = {
    UPGRADE_TYPES.AXE: {
        "name": "Топор",
        "level": 1,
        "max_level": 5,
        "cost_func": func(lvl): return {"wood": 10 + lvl*5, "stone": 5 + lvl*3},
        "effect_func": func(lvl): return 1 + lvl*0.5  # Множитель урона
    },
    UPGRADE_TYPES.PICKAXE: {
        "name": "Кирка", 
        "level": 1,
        "max_level": 5,
        "cost_func": func(lvl): return {"stone": 15 + lvl*8, "iron": 3 + lvl*2},
        "effect_func": func(lvl): return 1 + lvl*0.6
    }
}

func can_afford_upgrade(upgrade_type: UPGRADE_TYPES, player_resources: Dictionary) -> bool:
    var upgrade = upgrades[upgrade_type]
    if upgrade.level >= upgrade.max_level:
        return false
    
    var cost = upgrade.cost_func.call(upgrade.level)
    for resource in cost:
        if player_resources.get(resource, 0) < cost[resource]:
            return false
    return true

func purchase_upgrade(upgrade_type: UPGRADE_TYPES, player_resources: Dictionary) -> bool:
    if not can_afford_upgrade(upgrade_type, player_resources):
        return false
    
    var upgrade = upgrades[upgrade_type]
    var cost = upgrade.cost_func.call(upgrade.level)
    
    # Оплата
    for resource in cost:
        player_resources[resource] -= cost[resource]
    
    # Улучшение
    upgrade.level += 1
    emit_signal("upgrade_purchased", upgrade_type, upgrade.level)
    return true

func get_upgrade_info(upgrade_type: UPGRADE_TYPES) -> Dictionary:
    return upgrades[upgrade_type].duplicate()
