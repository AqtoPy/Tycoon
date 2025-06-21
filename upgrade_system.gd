extends Node

class_name UpgradeSystem

signal upgrade_purchased(upgrade_type, new_level)

enum UpgradeType {
    AXE,
    PICKAXE,
    BACKPACK,
    MAGNET
}

var upgrades = {
    UpgradeType.AXE: {
        "name": "Топор",
        "level": 1,
        "max_level": 5,
        "cost": {"wood": 10, "stone": 5},
        "cost_increase": {"wood": 5, "stone": 3},
        "effect": 1.0,
        "effect_increase": 0.5
    },
    UpgradeType.PICKAXE: {
        "name": "Кирка",
        "level": 1,
        "max_level": 5,
        "cost": {"stone": 15, "iron": 3},
        "cost_increase": {"stone": 8, "iron": 2},
        "effect": 1.0,
        "effect_increase": 0.6
    }
}

func get_upgrade_cost(upgrade_type: UpgradeType) -> Dictionary:
    var upgrade = upgrades[upgrade_type]
    var cost = {}
    for resource in upgrade.cost:
        cost[resource] = upgrade.cost[resource] + (upgrade.level - 1) * upgrade.cost_increase.get(resource, 0)
    return cost

func can_afford_upgrade(upgrade_type: UpgradeType, player_resources: Dictionary) -> bool:
    if upgrade_type >= UpgradeType.size():
        return false
    
    var upgrade = upgrades[upgrade_type]
    if upgrade.level >= upgrade.max_level:
        return false
    
    var cost = get_upgrade_cost(upgrade_type)
    for resource in cost:
        if player_resources.get(resource, 0) < cost[resource]:
            return false
    return true

func purchase_upgrade(upgrade_type: UpgradeType, player_resources: Dictionary) -> bool:
    if not can_afford_upgrade(upgrade_type, player_resources):
        return false
    
    var cost = get_upgrade_cost(upgrade_type)
    for resource in cost:
        player_resources[resource] -= cost[resource]
    
    upgrades[upgrade_type].level += 1
    upgrades[upgrade_type].effect += upgrades[upgrade_type].effect_increase
    emit_signal("upgrade_purchased", upgrade_type, upgrades[upgrade_type].level)
    return true

func get_upgrade_info(upgrade_type: UpgradeType) -> Dictionary:
    return {
        "name": upgrades[upgrade_type].name,
        "level": upgrades[upgrade_type].level,
        "max_level": upgrades[upgrade_type].max_level,
        "cost": get_upgrade_cost(upgrade_type),
        "effect": upgrades[upgrade_type].effect
    }
