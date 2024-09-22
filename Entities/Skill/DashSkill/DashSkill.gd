extends BaseSkill

#获取技能触发的效果
func apply()->void:
	SkillDataManager.emit_signal("onDash")
