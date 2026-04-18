extends Node

# Globally accessible enums go here

enum CardType {MONSTER, ACTION, OBJECT, CHARACTER, LOCATION, DEATH}
enum MonsterType {UNDEAD, MINION, ELEMENTAL, CELESTIAL, INFERNAL, HERO}
enum Element {EARTH, AIR, FIRE, WATER, DARK, LIGHT, NULL}
enum CardTags {INGREDIENT, DEATH, EQUIPMENT, ATTACK, DEFENSE, CONSUMABLE, SPELL, BUFF, DEBUFF, SPECIAL}


func enum_string(value, type):
	return type.keys()[value]
