extends CharacterBody3D


@export var speed = 10
@export var jump_vel = 20
@export var bounce_impulse = 16
@export var lerp_val = 10

@onready var pivot = $Pivot
@onready var animation_player = $AnimationPlayer

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	fall(delta)
	jump()
	squash_mobs()
	move(delta)

func fall(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

func move(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		animation_player.speed_scale = 4
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-velocity.x, -velocity.z), delta * lerp_val)
	else:
		animation_player.speed_scale = 1
	move_and_slide()

func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_vel

func squash_mobs():
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if (collision.get_collider() == null):
			continue
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				velocity.y = bounce_impulse
