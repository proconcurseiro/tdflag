extends KinematicBody

const GRAVIDADE = -30
const PULO_VELOCIDADE = 12
const CORRER_VELOCIDADE = 8

var sensibilidade_mouse = 0.002  # radians/pixel
var velocidade_atual = Vector3()
var pulo = false

onready var camera = $pivot/camera
onready var rotation_helper = $pivot


func get_input():
	pulo = false
	if Input.is_action_just_pressed("pulo"):
		pulo = true
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("avancar"):
		input_dir += -camera.global_transform.basis.z.slide(Vector3(0,1,0))
	if Input.is_action_pressed("recuar"):
		input_dir += camera.global_transform.basis.z.slide(Vector3(0,1,0))
	if Input.is_action_pressed("lateral_esquerda"):
		input_dir += -camera.global_transform.basis.x.slide(Vector3(0,1,0))
	if Input.is_action_pressed("lateral_direita"):
		input_dir += camera.global_transform.basis.x.slide(Vector3(0,1,0))
	input_dir = input_dir.normalized()
	return input_dir
	
#func _input(event):
#	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#		rotation_helper.rotate_x(deg2rad(event.relative.y * sensibilidade_mouse))
#		self.rotate_y(deg2rad(event.relative.x * sensibilidade_mouse * -1))
#
#		var camera_rot = rotation_helper.rotation_degrees
#		camera_rot.x = clamp(camera_rot.x, -70, 70)
#		rotation_helper.rotation_degrees = camera_rot
		
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion:
		rotation_helper.rotate_x(-event.relative.y * sensibilidade_mouse)
		rotate_y(-event.relative.x * sensibilidade_mouse)
		rotation_helper.rotation.x = clamp(rotation_helper.rotation.x, deg2rad(-80), deg2rad(-80.001))
		
func _physics_process(delta):
	velocidade_atual.y += GRAVIDADE * delta
	var desired_velocity = get_input() * CORRER_VELOCIDADE

	velocidade_atual.x = desired_velocity.x
	velocidade_atual.z = desired_velocity.z
	velocidade_atual = move_and_slide(velocidade_atual, Vector3.UP, true)
	if pulo and is_on_floor():
		velocidade_atual.y = PULO_VELOCIDADE
