class_name AmbientOcclusionSampler
extends RefCounted

static func compute_occlusion(
		world: World3D,
		position: Vector3,
		normal: Vector3,
		radius: float = 5.0,
		ray_count: int = 64,
		collision_mask: int = 0xFFFFFFFF
	) -> float:

	var space_state = world.direct_space_state

	var occlusion := 0.0

	var basis := Basis()
	basis = basis.looking_at(normal, Vector3.UP)

	# Evite un problème si la normale est verticale
	if abs(normal.dot(Vector3.UP)) > 0.99:
		basis = Basis().looking_at(normal, Vector3.RIGHT)

	for i in ray_count:

		# Répartition de Fibonacci sur une hémisphère
		var dir = _fibonacci_hemisphere(i, ray_count)

		# Oriente selon la normale
		dir = basis * dir

		var query := PhysicsRayQueryParameters3D.create(
			position + normal * 0.02,
			position + dir * radius
		)

		query.collision_mask = collision_mask

		var result = space_state.intersect_ray(query)

		if result.is_empty():
			continue

		var d = position.distance_to(result.position)

		# 1 si très proche, 0 à la distance max
		var contribution = 1.0 - clamp(d / radius, 0.0, 1.0)

		occlusion += contribution

	return clamp(occlusion / ray_count, 0.0, 1.0)


static func _fibonacci_hemisphere(i: int, count: int) -> Vector3:

	const PHI = 1.61803398875

	var u = float(i) / float(count)
	var theta = TAU * (float(i) / PHI - floor(float(i) / PHI))

	# z entre 0 et 1 => hémisphère supérieur
	var z = u
	var r = sqrt(max(0.0, 1.0 - z * z))

	return Vector3(
		cos(theta) * r,
		z,
		sin(theta) * r
	).normalized()
