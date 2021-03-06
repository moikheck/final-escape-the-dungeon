extends HSlider


export var audio_bus_name := "Music"


onready var _bus := AudioServer.get_bus_index(audio_bus_name)


func _ready():
	value = db2linear(AudioServer.get_bus_volume_db(_bus))


func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(_bus, linear2db(value))
