extends CharacterBody2D

var target = Vector2.ZERO
var speed = 10.0
var width = 0
var width_default = 0
var decay = 0.02
var tween
var time_highlight = 1
var time_highlight_size = 1

func _ready():
	width = $CollisionShape2D.get_shape().size.x
	width_default = width
	target = Vector2(Global.VP.x / 2, Global.VP.y - 80)

func _physics_process(_delta):
	target.x = clamp(target.x, width/2, Global.VP.x - width/2)
	position = target
	if $Images/Highlight.modulate.a > 0:
		$Images/Highlight.modulate.a -= decay
	for c in $Powerups.get_children():
		c.payload()

func _input(event):
	if event is InputEventMouseMotion:
		target.x += event.relative.x

func hit(_ball):
	var Paddle_Sound = get_node("/root/Game/Paddle_Sound")
	Paddle_Sound.play
	$Images/Highlight.modulate.a = 1.0
	$SmallStar.emitting = true
	if tween:
		tween.kill()
	tween = create_tween().set_parallel(true)
	$Images/Highlight.modulate.a = 1.0
	tween.tween_property($Images/Highlight, "modulate:a", 0, time_highlight)
	$Images/Highlight.scale = Vector2(1.5,1.5)
	tween.tween_property($Images/Highlight, "scale", Vector2(1,1), time_highlight_size).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	

func powerup(payload):
	for c in $Powerups.get_children():
		if c.type == payload.type:
			c.queue_free()
	$Powerups.call_deferred("add_child", payload)
