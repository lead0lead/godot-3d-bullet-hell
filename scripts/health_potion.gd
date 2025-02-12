extends Control

@onready var amount_label: Label = $Amount

func update_label(current_amount):
	amount_label.text = str(current_amount)
