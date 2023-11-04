extends CharacterBody2D

const ATTACK_AREA: PackedScene = preload("res://tiny_swords/goblin/enemy_attack_area.tscn")
const OFFSET: Vector2 = Vector2(0, 31)

@onready var animation: AnimationPlayer = get_node("Animation")
@onready var animation_aux: AnimationPlayer = get_node("AnimationAux")
@onready var texture: Sprite2D = get_node("Texture")

var player_ref: CharacterBody2D = null
var can_die: bool = false

@export var health: int = 3
@export var move_speed: float = 192.0
@export var distance_threshold: float = 60.0


func _physics_process(_delta: float) -> void:
	if can_die == true:
		return

	if player_ref == null or player_ref.can_die == true:
		velocity = Vector2.ZERO
		animate()
		return

	var direction: Vector2 = global_position.direction_to(player_ref.global_position)
	var distance: float = global_position.distance_to(player_ref.global_position)

	if distance < distance_threshold:
		animation.play("attack")
		return

	velocity = direction * move_speed
	move_and_slide()
	animate()
	handle_flip(direction)


func spawn_attack_area() -> void:
	var attack_area = ATTACK_AREA.instantiate()
	attack_area.position = OFFSET
	add_child(attack_area)


func animate() -> void:
	if velocity != Vector2.ZERO:
		animation.play("run")
	else:
		animation.play("idle")


func on_detection_area_body_entered(body):
	player_ref = body


func on_detection_area_body_exited(_body):
	player_ref = null


func update_health(value: int) -> void:
	self.health -= value

	if self.health <= 0:
		can_die = true
		animation.play("death")
		return

	animation_aux.play("hit")


func on_animation_finished(anim_name: String) -> void:
	if anim_name == "death":
		queue_free()


func handle_flip(direction: Vector2) -> void:
	if direction.x < 0:
		texture.flip_h = true
	else:
		texture.flip_h = false
