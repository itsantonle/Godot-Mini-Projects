extends Node2D

const ANIMAL = preload("res://Scenes/Animal/Animal.tscn")
@onready var animal_start: Marker2D = $AnimalStart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_animal()

func _enter_tree() -> void:
	SignalHub.on_animal_died.connect(on_die)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#region spawning
func spawn_animal() -> void: 
	var animal: Animal = ANIMAL.instantiate()
	animal.position = animal_start.position
	add_child(animal)
	
#endregion

#region signals
func on_die()-> void: 
	print("death") 
	spawn_animal()
#endregion
