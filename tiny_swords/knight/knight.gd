extends CharacterBody2D

@onready var animation: AnimationPlayer = get_node("Animation")
@onready var texture: Sprite2D = get_node("Texture")

@export var move_speed: float = 256.0

var can_attack: bool = true


func _physics_process(_delta: float) -> void:
	if can_attack == false:
		if animation.is_playing() == false:
			can_attack = true
		return

	var direction: Vector2 = get_direction()

	move(direction)
	handle_flip(direction)
	animate()
	attack_handler()


func move(direction: Vector2) -> void:
	velocity = direction * move_speed
	move_and_slide()


func get_direction() -> Vector2:
	return Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()


func animate() -> void:
	if velocity != Vector2.ZERO:
		animation.play("run")
		return

	animation.play("idle")


func attack_handler() -> void:
	if Input.is_action_just_pressed("attack") and can_attack:
		can_attack = false
		animation.play("attack")


func handle_flip(direction: Vector2) -> void:
	if direction.x != 0:
		texture.flip_h = direction.x < 0
