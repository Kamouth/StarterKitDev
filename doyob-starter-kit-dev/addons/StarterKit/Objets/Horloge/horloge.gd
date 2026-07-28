extends Node3D

@export var tickPeriodMillseconds : int = 1000;
@export var tickSample : AudioStream;

var lastTickMsec : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Time.get_ticks_msec() - lastTickMsec > tickPeriodMillseconds:
		Tick()
	

func Tick():
	lastTickMsec = Time.get_ticks_msec()
	if $AudioStreamPlayer3D.playing == false:
		$AudioStreamPlayer3D.play()
