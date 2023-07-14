extends Node

@export var mob_scene: PackedScene

@onready var player_position = $Player.position
@onready var mob_timer = $MobTimer
@onready var retry = $UI/Retry

# Called when the node enters the scene tree for the first time.
func _ready():
	retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = get_node('SpawnPath/SpawnLocator')
	mob_spawn_location.progress_ratio = randf()
	mob.initialize(mob_spawn_location.position, $Player.position)
	add_child(mob)
	mob.squashed.connect($UI/ScoreLabel._on_mob_squashed.bind())

func _on_player_hit():
	mob_timer.stop() # Replace with function body.
	retry.show()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and retry.visible:
		get_tree().reload_current_scene()
