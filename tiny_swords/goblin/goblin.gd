extends CharacterBody2D

@onready var animation: AnimationPlayer = get_node("Animation")

var player_ref: CharacterBody2D = null

@export var move_speed: float = 192.0
@export var distance_threshold: float = 60.0


func _physics_process(_delta: float) -> void:
	if player_ref == null:
		animate()
		return

	var direction: Vector2 = global_position.direction_to(player_ref.global_position)
	var distance: float = global_position.distance_to(player_ref.global_position)

	print(distance)

	if distance < distance_threshold:
		animation.play("attack")
		return

	velocity = direction * move_speed
	move_and_slide()
	animate()


func animate() -> void:
	if velocity != Vector2.ZERO:
		animation.play("run")
	else:
		animation.play("idle")


func on_detection_area_body_entered(body):
	player_ref = body
	print(body)


func on_detection_area_body_exited(_body):
	player_ref = null
