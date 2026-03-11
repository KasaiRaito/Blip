extends Node

signal on_player_health_change(current_health: float, max_health : float)
signal on_player_rewind_change(current_rewind: float, max_rewind: float)

signal on_player_room_entered(room: LevelRoom)

signal on_player_death
signal on_player_enter_room

signal on_enemy_death
signal on_room_creared
signal on_coin_picked
signal on_portal_reached
