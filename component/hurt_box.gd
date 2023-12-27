extends Area2D

@export var health_component: HealthComponent

signal hurt_signal(damage: Damage)

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area2D) -> void:
	print(owner.name + "is hit by "+ area.owner.name)
	if not area is HitBox:
		return
	var hitbox := area as HitBox
	if health_component:
		health_component.take_damge(hitbox.damage)
	var damage_instantce: Damage = Damage.new()
	damage_instantce.amount = hitbox.damage
	# 设置伤害来源为Owner
	damage_instantce.source = hitbox.owner
	damage_instantce.hit_only_once = hitbox.hit_only_once
	hurt_signal.emit(damage_instantce)
	
