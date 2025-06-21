extends Node
class_name UpgradeSystem

signal upgrade_purchased(upgrade_id, new_level)

enum UpgradeID {
    AXE,
    PICKAXE,
    BACKPACK,
    MAGNET
}

var upgrades_data = {
    UpgradeID.AXE: {
        "name": "Топор",
        "description": "Увеличивает урон по деревьям",
        "max_level": 5,
        "base_cost": {"wood": 10, "stone": 5},
        "cost_increase": {"wood": 5, "stone": 2},
        "base_value": 1.0,
        "value_increase": 0.5
    },
    UpgradeID.PICKAXE: {
        "name": "Кирка", 
        "description": "Увеличивает урон по камням",
        "max_level": 5,
        "base_cost": {"stone": 15, "iron": 3},
        "cost_increase": {"stone": 8, "iron": 1},
        "base_value": 1.0,
        "value_increase": 0.6
    }
}

var current_levels = {
    UpgradeID.AXE: 1,
    UpgradeID.PICKAXE: 1
}

func get_upgrade_info(upgrade_id: UpgradeID) -> Dictionary:
    if not upgrades_data.has(upgrade_id):
        return {}
    
    var data = upgrades_data[upgrade_id]
    var level = current_levels.get(upgrade_id, 1)
    
    # Рассчитываем текущую стоимость
    var current_cost = {}
    for resource in data.base_cost:
        var base = data.base_cost[resource]
        var increase = data.cost_increase.get(resource, 0)
        current_cost[resource] = base + (level - 1) * increase
    
    return {
        "id": upgrade_id,
        "name": data.name,
        "description": data.description,
        "level": level,
        "max_level": data.max_level,
        "cost": current_cost,
        "value": data.base_value + (level - 1) * data.value_increase,
        "next_value": data.base_value + level * data.value_increase if level < data.max_level else 0
    }

func can_afford_upgrade(upgrade_id: UpgradeID, resources: Dictionary) -> bool:
    var info = get_upgrade_info(upgrade_id)
    if info.is_empty() or info.level >= info.max_level:
        return false
    
    for resource in info.cost:
        if resources.get(resource, 0) < info.cost[resource]:
            return false
    return true

func purchase_upgrade(upgrade_id: UpgradeID, resources: Dictionary) -> bool:
    if not can_afford_upgrade(upgrade_id, resources):
        return false
    
    var info = get_upgrade_info(upgrade_id)
    for resource in info.cost:
        resources[resource] -= info.cost[resource]
    
    current_levels[upgrade_id] += 1
    emit_signal("upgrade_purchased", upgrade_id, current_levels[upgrade_id])
    return true
