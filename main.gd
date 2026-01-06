extends Node2D

const PLAYER = preload("res://player.tscn")
const WALL = preload("res://wall.tscn")
const PLATFORM = preload("res://platform.tscn")
const SPIDER = preload("res://spider.tscn")
const FLY = preload("res://fly.tscn")
const DIRT = preload("res://dirt.tscn")
const FAN = preload("res://fan.tscn")
var secondToLastPlatform
var lastPlatform
var accel = .8
var max_speed = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = PLAYER.instantiate()
	player.position = Vector2(512,384)
	add_child(player)
	_spawnWall(Vector2(0,768))
	_spawnWall(Vector2(896,768))
	player.hit.connect(_gameOver)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.falling:
		Global.game_speed = min(Global.game_speed + delta * accel, max_speed)
		$ObstacleTimer.paused = false
	else:
		$ObstacleTimer.paused = true
	
func _spawnWall(wallPos: Vector2):
	var wall = WALL.instantiate()
	wall.position = wallPos
	call_deferred("add_child",wall)

func _on_wall_spawn_area_entered(area: Area2D) -> void:
	if(area.is_in_group("wall")):
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
	_spawnObstacle()
	var doClump = randi_range(0,1)
	if(doClump):
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
	elif doEnemy < 1:
		_spawnFan()

func _spawnFan():
	var fan = FAN.instantiate()
	add_child(fan)
	var fanPos = randi_range(0,5)
	fan.position = Vector2(128 + 128 * fanPos, 0)

func _spawnDirt():
	var dirt = DIRT.instantiate()
	add_child(dirt)
	dirt.position = Vector2(128 + 128 * randi_range(0,5),0)

func _spawnFly():
	var fly = FLY.instantiate()
	add_child(fly)
	fly.position = lastPlatform.position - Vector2(0,40)
	fly._firePea()

func _gameOver():
	print("player died")

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
