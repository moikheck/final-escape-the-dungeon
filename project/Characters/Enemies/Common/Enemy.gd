extends KinematicBody2D


const KEY_OFFSET := 48


export var health := 1
export var max_health := 3
export var attack_strength :=2
export var speed := 2500
export var distance_range := 400
export var velocity_buffer := 500


var velocity := Vector2()
var previous_velocity := Vector2.ZERO


var _is_hurt := false
var _is_attacking := false
var _is_paused := false


func _process(_delta):
	var player_position = get_parent().get_player_position()
	if _is_hurt or _is_attacking:
		velocity = Vector2.ZERO
	elif not _is_paused and abs(player_position.x - position.x) <= distance_range and abs(player_position.y - position.y) <= distance_range:
		previous_velocity = velocity
		if player_position.x > position.x:
			velocity.x += speed
		if player_position.x < position.x:
			velocity.x -= speed
		if player_position.y > position.y:
			velocity.y += speed
		if player_position.y < position.y:
			velocity.y -= speed
		$AnimatedSprite.play("walk")
		if name == 'Boss':
			get_parent().play_boss_ambient()
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite.play("default")
	if previous_velocity.x > velocity_buffer or previous_velocity.x < -velocity_buffer:
		if velocity.x < 0:
			$AnimatedSprite.scale.x = 1
		elif velocity.x > 0:
			$AnimatedSprite.scale.x = -1


func _physics_process(delta):
	velocity = move_and_slide(velocity * delta)


func attack(player):
	if not _is_attacking and not _is_hurt:
		_is_attacking = true
		$AnimatedSprite.play("attack")
		player.take_damage(attack_strength)


func take_damage(damage):
	if not _is_hurt:
		health -= damage
		$sound.stream = load("res://Characters/Enemies/Common/deathMonsterconverted.wav")
		$sound.play()
		if health <= 0:
			$AnimatedSprite.play("killed")
			if max_health == 15:
				spawn_hat()
				spawn_key()
		elif health <= max_health / 3.0:
			$AnimatedSprite.play("hurt 2")
		else:
			$AnimatedSprite.play("hurt")
		if damage == 0:
			var particles = load("res://Characters/Player/Bows/ArrowParticles.tscn").instance()
			particles.texture = load("res://Characters/Enemies/Common/stun_particle.png")
			particles.position = position
			particles.emitting = true
			get_parent().call_deferred("add_child", particles)
		_is_hurt = true


func pause(value):
	_is_paused = value


func spawn_hat():
	var hat = load("res://Levels/Main/Items/Item.tscn").instance()
	hat.set_item("Hat", "null")
	hat.position = position
	get_parent().call_deferred("add_child", hat)


func spawn_key():
	var key = load("res://Levels/Main/Items/Item.tscn").instance()
	key.set_item("Key", "null")
	key.position = position
	key.position.y = position.y + KEY_OFFSET
	get_parent().call_deferred("add_child", key)


func _on_Area2D_area_entered(area):
	if area.name == 'PlayerWeapon':
		take_damage(area.damage)


func _on_AnimatedSprite_animation_finished():
	if health <= 0:
		queue_free()
	else:
		_is_hurt = false
		_is_attacking = false


func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		attack(body)
