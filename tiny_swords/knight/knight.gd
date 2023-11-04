extends CharacterBody2D


@onready var texture: Sprite2D = get_node("Texture")
@onready var animation: AnimationPlayer = get_node("Animation")
@onready var animation_aux: AnimationPlayer = get_node("AnimationAux")
@onready var attack_area_collision: CollisionShape2D = get_node("AttackArea/Collision")


@export var health: int = 10
@export var move_speed: float = 256.0
@export var attack_damage: int = 1


var can_attack: bool = true
var can_die: bool = false


func _physics_process(_delta: float) -> void:
	if can_attack == false or can_die == true:
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


func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"attack":
			can_attack = true
		"death":
			get_tree().reload_current_scene()


func attack_handler() -> void:
	if Input.is_action_just_pressed("attack") and can_attack:
		can_attack = false
		animation.play("attack")


func handle_flip(direction: Vector2) -> void:
	if direction.x != 0:
		texture.flip_h = direction.x < 0

	if texture.flip_h:
		attack_area_collision.position.x = -60
	else:
		attack_area_collision.position.x = 60


func on_attack_area_body_entered(body) -> void:
	body.update_health(attack_damage)


func update_health(value: int) -> void:
	self.health -= value

	if self.health <= 0:
		can_die = true
		animation.play("death")
		attack_area_collision.set_deferred("disable", true)
		return

	animation_aux.play("hit")



