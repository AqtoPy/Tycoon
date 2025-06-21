extends Node
class_name UpgradeSystem

signal upgrade_purchased(upgrade_type, new_level)
signal tool_model_changed(tool_type, level)

enum UpgradeType {
    AXE,
    PICKAXE,
    HAT
}

var upgrades = {
    UpgradeType.AXE: {
        "name": "Топор",
        "level": 1,
        "max_level": 10,
        "base_cost": {"wood": 10, "stone": 5},
        "cost_increase": {"wood": 5, "stone": 2},
        "effect": 1.0,
        "effect_increase": 0.3,
        "model_paths": [
            "res://models/tools/axe_lvl1.tscn",
            "res://models/tools/axe_lvl4.tscn",
            "res://models/tools/axe_lvl7.tscn",
            "res://models/tools/axe_lvl10.tscn"
        ]
    },
    UpgradeType.PICKAXE: {
        "name": "Кирка",
        "level": 1,
        "max_level": 10,
        "base_cost": {"stone": 15, "iron": 3},
        "cost_increase": {"stone": 8, "iron": 1},
        "effect": 1.0,
        "effect_increase": 0.4,
        "model_paths": [
            "res://models/tools/pickaxe_lvl1.tscn",
            "res://models/tools/pickaxe_lvl4.tscn",
            "res://models/tools/pickaxe_lvl7.tscn",
            "res://models/tools/pickaxe_lvl10.tscn"
        ]
    },
    UpgradeType.HAT: {
        "name": "Шапка",
        "level": 0,
        "max_level": 5,
        "base_cost": {"wood": 20, "cloth": 5},
        "cost_increase": {"wood": 10, "cloth": 3},
        "effect": 0.0,
        "effect_increase": 0.1,
        "models": [
            null,
            "res://models/hats/hat1.tscn",
            "res://models/hats/hat2.tscn",
            "res://models/hats/hat3.tscn",
            "res://models/hats/hat4.tscn",
            "res://models/hats/hat5.tscn"
        ]
    }
}

func get_upgrade_info(upgrade_type: UpgradeType) -> Dictionary:
    var info = upgrades[upgrade_type].duplicate()
    info.erase("model_paths")
    info.erase("models")
    return info

func can_afford_upgrade(upgrade_type: UpgradeType, resources: Dictionary) -> bool:
    var upgrade = upgrades[upgrade_type]
    if upgrade.level >= upgrade.max_level:
        return false
    
    var cost = {}
    for resource in upgrade.base_cost:
        cost[resource] = upgrade.base_cost[resource] + (upgrade.level - 1) * upgrade.cost_increase.get(resource, 0)
    
    for resource in cost:
        if resources.get(resource, 0) < cost[resource]:
            return false
    return true

func purchase_upgrade(upgrade_type: UpgradeType, player: Node) -> bool:
    if not can_afford_upgrade(upgrade_type, player.resources):
        return false
    
    var upgrade = upgrades[upgrade_type]
    var cost = {}
    for resource in upgrade.base_cost:
        cost[resource] = upgrade.base_cost[resource] + (upgrade.level - 1) * upgrade.cost_increase.get(resource, 0)
        player.resources[resource] -= cost[resource]
    
    upgrade.level += 1
    emit_signal("upgrade_purchased", upgrade_type, upgrade.level)
    
    # Проверяем нужно ли менять модель
    if upgrade_type in [UpgradeType.AXE, UpgradeType.PICKAXE]:
        var model_index = min(upgrade.level / 3, upgrade.model_paths.size() - 1)
        emit_signal("tool_model_changed", upgrade_type, model_index)
    elif upgrade_type == UpgradeType.HAT and upgrade.level > 0:
        player.equip_hat(upgrade.models[upgrade.level])
    
    return true
