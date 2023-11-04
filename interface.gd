extends Control

@onready var display_text: Label = $Background/Display/Text

var numero_1: String = ""
var numero_2: String = ""
var operador: String = ""
var indice_numero_atual: int = 0

func _ready() -> void:
	display_text.text = "0"

	# Assumindo que todos os botões estão em um grupo chamado 'buttons'
	for button in get_tree().get_nodes_in_group("button"):
		button.pressed.connect(_quando_o_botao_for_pressionado.bind(button.name))


func _quando_o_botao_for_pressionado(nome_do_botao: String) -> void:
	match nome_do_botao:
		"button_reset":
			_reset(true)

		"button_equals":
			_calcular_resultado()

		"button_plus", "button_minus", "button_divide", "button_multiply":
			_mudar_operador(nome_do_botao)

		_:
			if nome_do_botao.begins_with("button_"):
				_adicionar_numero(nome_do_botao.get_slice('_', 1))

func _adicionar_numero(numero: String) -> void:
	if indice_numero_atual == 0:
		numero_1 += numero
		if operador == "":
			display_text.text = numero_1
	elif indice_numero_atual == 1:
		numero_2 += numero
		display_text.text = numero_1 + " " + operador + " " + numero_2

func _mudar_operador(nome_do_botao: String) -> void:
	if numero_1 == "" or operador != "":
		return

	operador = nome_do_botao.get_slice('_', 1)
	indice_numero_atual = 1
	display_text.text = numero_1 + " " + operador

func _calcular_resultado() -> void:
	if numero_1 == "" or numero_2 == "" or operador == "":
		return

	var value_1: float = float(numero_1)
	var value_2: float = float(numero_2)
	var result: float = 0.0

	match operador:
		"plus":
			result = value_1 + value_2
		"minus":
			result = value_1 - value_2
		"divide":
			if value_2 != 0.0:
				result = value_1 / value_2
			else:
				display_text.text = "Erro"
				return
		"multiply":
			result = value_1 * value_2

	display_text.text = str(result)
	_reset()

func _reset(is_reseting: bool = false) -> void:
	numero_1 = ""
	numero_2 = ""
	operador = ""
	indice_numero_atual = 0

	if is_reseting:
		display_text.text = "0"
