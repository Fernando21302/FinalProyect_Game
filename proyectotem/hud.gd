extends Control

# Esta función actualiza el texto del nodo 'SpacingValueCoin' para mostrar la cantidad actual de monedas (coin).
func update_count(coin: int):
	$SpacingValueCoin.text = str(coin)
