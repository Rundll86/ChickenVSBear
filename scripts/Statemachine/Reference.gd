class_name Reference

var data: Variant = null

func _init(initialData: Variant):
	data = initialData

func setData(newData: Variant):
	data = newData
func getData() -> Variant:
	return data
