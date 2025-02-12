extends Object

#Esto no devuelve automáticamente el enum, pero permite acceder a él de manera organizada.
#Cuando defines un enum dentro de una clase, el enum se convierte en una propiedad de la clase.

class_name GameEnums  # Esto hace que se pueda importar fácilmente

class State:
	enum {
		IDLE,
		DRIVE,
		SINGLE,
		BOX
	}

class HudState:
	enum {
		MAIN_MENU,
		PLAYING,
		PAUSED,
		SHOP,
		GAME_OVER,
		LOADING,
		RESUME
	}


class PlayerAnimation:
	pass
	
