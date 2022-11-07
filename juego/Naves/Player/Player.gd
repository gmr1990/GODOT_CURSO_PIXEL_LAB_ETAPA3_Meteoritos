extends RigidBody2D

class_name Player

# Enums
enum ESTADO {SPAWN, VIVO, INVENCIBLE, MUERTO}



## Atributos Export
export var potencia_motor:int = 10
export var potencia_rotacion:int = 2
export var estela_maxima:int = 150


## Atributos
var estado_actual:int = ESTADO.SPAWN

var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

# Atributos Onready
onready var colisionador:CollisionShape2D = $CollisionShape2D

onready var canion:Canion = $Canion
onready var laser:RayoLaser = $LaserBeam2D
onready var estela:Estela = $EstelaPuntoInicio/Trail2D
onready var motor_sfx:Motor = $MotorSFX


## Metodos
func _ready() -> void:
	controlador_estados(estado_actual)
	## TODO: Quitqr, solo DEBUG
	## controlador_estados(ESTADO.VIVO)


func _unhandled_input(event: InputEvent) -> void:
	if not esta_input_activo():
		return
	# Veo si se presiona tecla de Disparo Rayo
	if event.is_action_pressed("disparo_secundario"):
		laser.set_is_casting(true)
		
	if event.is_action_released("disparo_secundario"):
		laser.set_is_casting(false)
	
	#Control ll Estela y sonido de motor
	if event.is_action_pressed("mover_adelante"):
		estela.set_max_points(estela_maxima)
		motor_sfx.sonido_on()
	elif event.is_action_pressed("mover_atras"):
		estela.set_max_points(0)
		motor_sfx.sonido_on()
	
	if (event.is_action_released("mover_adelante")
		or event.is_action_released("mover_atras")):
			motor_sfx.sonido_off()
				

# warning-ignore:unused_argument
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	
			
		
# warning-ignore:unused_argument
func _process(delta: float) -> void:
	player_input()
	
			
## Metodos Custom

func controlador_estados(nuevo_estado: int) ->void:
	match nuevo_estado:
		ESTADO.SPAWN:
			colisionador.set_deferred("disable",true)
			canion.set_puede_disparar(false)
		ESTADO.VIVO:
			colisionador.set_deferred("disable",false)
			canion.set_puede_disparar(true)
		ESTADO.INVENCIBLE:
			colisionador.set_deferred("disable",true)
		ESTADO.MUERTO:
			colisionador.set_deferred("disable",true)
			canion.set_puede_disparar(true)
			Eventos.emit_signal("nave_destruida, global_position")
			queue_free()
			
			printerr ("Error de estado")
		
	estado_actual = nuevo_estado
	
#Destruir player por enemigo
func destruir() -> void:
	controlador_estados(ESTADO.MUERTO)
	
	
func esta_input_activo() ->bool:
	if estado_actual in [ESTADO.MUERTO, ESTADO.SPAWN]:
		return false
		
	return true
		
			
func player_input() -> void:
	if not esta_input_activo():
		return
		
	# Empuje
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(potencia_motor, 0)
	elif Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-potencia_motor, 0)
	#Rotacion
	if Input.is_action_pressed("rotar_antihorario"):
		dir_rotacion -=1
	elif Input.is_action_pressed("rotar_horario"):
		dir_rotacion +=1
		
		
	#Disparo
	if Input.is_action_pressed("disparo_principal"):
		canion.set_esta_disparando(true)
				
	if Input.is_action_just_released("disparo_principal"):
		canion.set_esta_disparando(false)
		

## Se;ales Internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlador_estados(ESTADO.VIVO)
		
