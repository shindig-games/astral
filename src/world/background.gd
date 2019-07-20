extends ParallaxBackground

func _physics_process(delta):
	print("yeet")
	#self.transform = self.get_parent().get_node("Player").transform.y
	print(self.transform.z.y)