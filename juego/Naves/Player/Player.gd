extends RigidBody2D

class_name Player

## Atributos Export
export var potencia_motor:int = 10
export var potencia_rotacion:int = 2


## Atributos
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

## Metodos
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	
			
		
func _process(delta: float) -> void:
	player_input()
	
## Metodos Custom
func player_input() -> void:
	# Empuje
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(potencia_motor, 0)
	elif Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-potencia_motor, 0)
		
	if Input.is_action_pressed("rotar_antihorario"):
		dir_rotacion -=1
	elif Input.is_action_pressed("rotar_horario"):
		dir_rotacion +=1

	
	
	
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
