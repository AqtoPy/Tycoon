extends Control
class_name NotificationUI

@onready var label = $Label
@onready var anim = $AnimationPlayer

func show_message(text: String, duration: float = 2.0):
    label.text = text
    anim.play("show")
    await get_tree().create_timer(duration).timeout
    anim.play("hide")
