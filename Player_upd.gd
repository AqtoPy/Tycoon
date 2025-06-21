func apply_upgrade_effects():
    var axe_info = UpgradeSystem.get_upgrade_info(UpgradeSystem.UpgradeID.AXE)
    var pickaxe_info = UpgradeSystem.get_upgrade_info(UpgradeSystem.UpgradeID.PICKAXE)
    
    # Применяем бонусы к добыче
    $HarvestComponent.tree_damage_multiplier = axe_info.value
    $HarvestComponent.rock_damage_multiplier = pickaxe_info.value
