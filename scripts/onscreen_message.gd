extends Control
class_name OnscreenMessage

@onready var animation_player = $AnimationPlayer
enum Types {NEUTRAL, NEGATIVE, POSITIVE, WARNING}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("Enter")
	$MessageTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_message_timer_timeout() -> void:
	animation_player.play("Exit")

func set_text(text):
	$CenterContainer/Control/Label.text = text

func set_type(type):
	
	match type:
		"neutral": 
			$CenterContainer/Control/Label.add_theme_color_override("font_color"
			, Color.WHITE)
		"negative": 
			$CenterContainer/Control/Label.add_theme_color_override("font_color"
			, Color.RED)
		"positive": 
			$CenterContainer/Control/Label.add_theme_color_override("font_color"
			, Color.GREEN)
		"warning": 
			$CenterContainer/Control/Label.add_theme_color_override("font_color"
			, Color.ORANGE)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Exit":
		queue_free()
	else: 
		return
