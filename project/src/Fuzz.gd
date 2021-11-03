extends KinematicBody2D


const SPEED := 1750
const DISTANCE := Vector2(5000,5000)
const FUZZ_ATTACK_DAMAGE := 1


export var health := 3


var velocity := Vector2()


var _is_hurt := false
var _is_attacking := false


onready var player := get_node("../Player")


func _process(_delta):
	if _is_hurt or _is_attacking:
		velocity = Vector2.ZERO
	elif player.position.x <= DISTANCE.x and player.position.y <= DISTANCE.y:
		if player.position.x > position.x:
			velocity.x += SPEED
		if player.position.x < position.x:
			velocity.x -= SPEED
		if player.position.y > position.y:
			velocity.y += SPEED
		if player.position.y < position.y:
			velocity.y -= SPEED
		$AnimatedSprite.play("walk")
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite.play("default")
	if velocity.x < 0:
		$AnimatedSprite.scale.x = 1
	elif velocity.x > 0:
		$AnimatedSprite.scale.x = -1


func _physics_process(delta):
	velocity = move_and_slide(velocity * delta)


func _on_Area2D_area_entered(area):
	if area == player.get_current_weapon():
		take_damage(area.damage)


func attack():
	if not _is_attacking and not _is_hurt:
		$AnimatedSprite.play("attack")
		player.take_damage(FUZZ_ATTACK_DAMAGE)
		_is_attacking = true


func take_damage(damage):
	if not _is_hurt:
		health -= damage
		if health <= 0:
			$AnimatedSprite.play("killed")
			$sound.stream = load("res://assets/Enemies/deathMonsterconverted.wav")
			$sound.play()
		else:
			$sound.stream = load("res://assets/Enemies/hurtMonstertrimmed.wav")
			$sound.play()
			if health == 1:
				$AnimatedSprite.play("hurt 2") 
			else:
				$AnimatedSprite.play("hurt")
		_is_hurt = true


func _on_AnimatedSprite_animation_finished():
	if health <= 0:
		queue_free()
	else:
		_is_hurt = false
		_is_attacking = false


func _on_Area2D_body_entered(body):
	if body == player:
		attack()
