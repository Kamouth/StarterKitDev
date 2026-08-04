extends Node3D

@export var occlusion : float = 0.0
@export var audioPlayer : AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdateOcclusion()
	audioPlayer.max_distance = 30.0 - 9.0 * occlusion
	# print(occlusion)

func UpdateOcclusion():
	occlusion = AmbientOcclusionSampler.compute_occlusion(
	get_world_3d(),
	global_position,
	Vector3.MODEL_FRONT,
	8.0,
	128
)
