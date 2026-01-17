extends Node2D

const PLAYER = preload("res://player.tscn")
const WALL = preload("res://wall.tscn")
const PLATFORM = preload("res://platform.tscn")
const SPIDER = preload("res://spider.tscn")
const FLY = preload("res://fly.tscn")
const DIRT = preload("res://dirt.tscn")
const FD = preload("res://FD.tscn")
const QUEEN = preload("res://queen.tscn")
#const FAN = preload("res://fan.tscn")
var secondToLastPlatform
var lastPlatform
var accel = .33
var max_speed = 12
var distance = 0
var leaf = false
var rock = false
var candy = false
var bug = false
var salt = false
var player = PLAYER.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.position = Vector2(512,384)
	_spawnWall(Vector2(0,768))
	_spawnWall(Vector2(896,768))
	player.dead.connect(_gameOver)
	player.hit.connect(_playerHit)
	Global.game_speed = 0
	
func _gameStart():
	Global.falling = true
	Global.game_speed = 5
	add_child(player)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.falling:
		Global.game_speed = min(Global.game_speed + delta * accel, max_speed)
		$ObstacleTimer.paused = false
	else:
		$ObstacleTimer.paused = true
	distance += delta * Global.game_speed
	if(distance >= 150):
		if Global.falling == true and player:
			_spawnQueen()
			player._toggleCamera()
		Global.falling = false
		if player:
			player.position.y += 5
		
func _spawnQueen():
	var fd = FD.instantiate()
	fd.position = Vector2(0,768)
	add_child(fd)
	var queen = QUEEN.instantiate()
	queen.position = Vector2(0,748)
	add_child(queen)
	
func _gameWon():
	print("game won!!")
	await get_tree().create_timer(2.0).timeout
	Global.falling = false
	get_tree().reload_current_scene()
	
func _changeGameType():
	if leaf:
		_changeGameSpeed(.5)
		accel = .2
	elif rock:
		_changeGameSpeed(2)
		accel = .4
		max_speed = 15
	elif bug:
		player.playerHealth += 3
	elif candy:
		player.candyPower = true
	elif salt:
		player.SPEED += 200
	
func _changeGameSpeed(multi: float):
	Global.game_speed = Global.game_speed * multi
	
func _spawnWall(wallPos: Vector2):
	var wall = WALL.instantiate()
	wall.position = wallPos
	call_deferred("add_child",wall)

func _on_wall_spawn_area_entered(area: Area2D) -> void:
	if(area.is_in_group("wall") and Global.falling):
		_spawnWall(Vector2(area.position.x,768))
		
func _spawnObstacle(ObstaclePosition = null):
	var platform = PLATFORM.instantiate()
	add_child(platform)
	if ObstaclePosition:
		platform.position = ObstaclePosition
	else:
		platform.position = Vector2(128 + 128 * randi_range(0,5),768)
	#edgecase for first spawn
	if !secondToLastPlatform:
		if !lastPlatform:
			lastPlatform = platform
		secondToLastPlatform = lastPlatform
		
	if lastPlatform.position.y != platform.position.y:
		secondToLastPlatform = lastPlatform
	lastPlatform = platform
		
func _spawnSpider():
	var spider = SPIDER.instantiate()
	add_child(spider)
	spider.position = lastPlatform.position + Vector2(0,48)
	spider._shootWeb(secondToLastPlatform.position - spider.position)
	
func _on_wall_spawn_area_exited(area: Area2D) -> void:
	area.queue_free()

func _on_obstacle_timer_timeout() -> void:
	$ObstacleTimer.wait_time = $ObstacleTimer.wait_time
	_spawnObstacle()
	var doClump = randf()
	if(doClump < .1):
		var spawn = Vector2(128 + 128 * randi_range(0,4),768)
		_spawnObstacle(spawn)
		_spawnObstacle(spawn + Vector2(128,0))
	else:
		_spawnObstacle()
	var doEnemy = randf()
	if doEnemy < .25:
		_spawnSpider()
	elif doEnemy < .5:
		_spawnFly()
	elif doEnemy < .75:
		_spawnDirt()
	#elif doEnemy < 1:
		#_spawnFan()

#func _spawnFan():
	#var fan = FAN.instantiate()
	#add_child(fan)
	#var fanPos = randi_range(0,5)
	#fan.position = Vector2(128 + 128 * fanPos, 660)

func _spawnDirt():
	var dirt = DIRT.instantiate()
	add_child(dirt)
	dirt.position = Vector2(128 + 128 * randi_range(0,5),0)

func _spawnFly():
	var fly = FLY.instantiate()
	add_child(fly)
	fly.position = lastPlatform.position - Vector2(0,40)
	fly._firePea()
	
func _playerHit():
	print("player hita")
	#$HUD.updateHealth()
	pass
	
func _gameOver():
	$HUD/GameOverLabel.show()
	await get_tree().create_timer(2.0).timeout
	Global.falling = false
	get_tree().reload_current_scene()

#if someone the player gets to the top
func _on_wall_spawn_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		_gameOver()
	
func _on_wall_spawn_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.tempDespawnHit > 1:
			body.queue_free()
		else: 
			body._addHit()

func _on_dirt_despawn_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.queue_free()
