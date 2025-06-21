extends Node
class_name UpgradeSystem

enum UpgradeID {
    AXE,
    PICKAXE,
    BACKPACK
}

var current_levels = {
    UpgradeID.AXE: 1,
    UpgradeID.PICKAXE: 1
}

const UPGRADE_DATA = [
    { # AXE
        "name": "Топор",
        "cost": {"wood": 10, "stone": 5},
        "cost_increase": {"wood": 5, "stone": 2}
    },
    { # PICKAXE
        "name": "Кирка",
        "cost": {"stone": 15, "iron": 3},
        "cost_increase": {"stone": 8, "iron": 1}
    }
]

func get_upgrade_info(upgrade_id: int) -> Dictionary:
    var level = current_levels.get(upgrade_id, 1)
    return {
        "name": UPGRADE_DATA[upgrade_id].name,
        "level": level,
        "cost": calculate_cost(upgrade_id, level)
    }

func calculate_cost(upgrade_id: int, level: int) -> Dictionary:
    var cost = {}
    for resource in UPGRADE_DATA[upgrade_id].cost:
        cost[resource] = UPGRADE_DATA[upgrade_id].cost[resource] + (level - 1) * UPGRADE_DATA[upgrade_id].cost_increase.get(resource, 0)
    return cost

func can_afford_upgrade(upgrade_id: int, player_resources: Dictionary) -> bool:
    var cost = calculate_cost(upgrade_id, current_levels.get(upgrade_id, 1))
    for resource in cost:
        if player_resources.get(resource, 0) < cost[resource]:
            return false
    return true

func purchase_upgrade(upgrade_id: int, player_resources: Dictionary) -> bool:
    if not can_afford_upgrade(upgrade_id, player_resources):
        return false
    
    var cost = calculate_cost(upgrade_id, current_levels.get(upgrade_id, 1)))
    for resource in cost:
        player_resources[resource] -= cost[resource]
    
    current_levels[upgrade_id] += 1
    return true
