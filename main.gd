extends Node

@export var mob_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mob_timer_timeout():
	# create a new instance of the mob scene
	var mob = mob_scene.instantiate()
	
	#choose a random location on the spawn path
	# store a reference in the spawn location node
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# give it a random offset
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	#spawn the mob by adding it to the main scene
	add_child(mob)
