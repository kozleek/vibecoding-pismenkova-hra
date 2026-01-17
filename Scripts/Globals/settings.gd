extends Node

# ========================
# Systemové nastavení
# ========================

# Index hlavní sběrnice (Master bus). Obvykle je to 0.
const MASTER_BUS_INDEX = 0

# ========================
# Cesty
# ========================

# Cesta k uložení uživatelského nastavení
const SAVEDATA_PATH = "user://savedata.json"
const ANSWERS_PATH = "res://Data/answers.json"
const SCENE_INTRO_PATH = "res://Scenes/intro.tscn"
const SCENA_GAME_PATH = "res://Scenes/game.tscn"

# ========================
# Definice hry
# ========================

# Definice písmen a jejich hodnot podle hry scrabble
const LETTERS_AND_POINTS: Dictionary = {
	'a': 1, 'b': 3, 'c': 2, 'd': 1, 'e': 1,
	'f': 5, 'g': 5, 'h': 2, 'i': 1, 'j': 2,
	'k': 1, 'l': 1, 'm': 2, 'n': 1, 'o': 1,
	'p': 1, 'r': 1, 's': 1, 't': 1, 'u': 2,
	'v': 1, 'y': 2, 'z': 2
}

# Definice témat
# Pole obsahuje UNIKÁTNÍ KLÍČE (ID) pro překlad, nikoliv samotný text.
# Tyto klíče musí být definované v překladovém CSV souboru
const SUBJECTS: Array[String] = [
	"SUB_BAJE_A_POVESTI",
	"SUB_BARVA",
	"SUB_CAST_TELA",	
	"SUB_CINNOST",
	"SUB_DINOSAURUS",
	"SUB_DOPRAVNI_PROSTREDEK",
	"SUB_EMOCE",
	"SUB_FILM",	
	"SUB_HEREC",
	"SUB_HISTORICKA_UDALOST",
	"SUB_HLAVNI_MESTO",
	"SUB_HMYZ",
	"SUB_HORA",
	"SUB_HRACKA",
	"SUB_HUDEBNI_NASTROJ",
	"SUB_CHEMICKY_PRVEK",	
	"SUB_KNIHA",
	"SUB_KOMIX",
	"SUB_KONICEK",
	"SUB_KORENI",
	"SUB_LEK",
	"SUB_LITERALNI_ZANR",
	"SUB_MATERIAL",
	"SUB_MENA",
	"SUB_MISTNOST",
	"SUB_MUZSKE_JMENO",
	"SUB_NABYTEK",
	"SUB_NALADA",
	"SUB_NAPOJE",
	"SUB_NASTROJ",
	"SUB_NEMOC",
	"SUB_OBLECENI",
	"SUB_OBCHODNI_RETEZEC",
	"SUB_OVOCE",
	"SUB_PECIVO",
	"SUB_PISNICKA",
	"SUB_PLAZ",
	"SUB_PLANETA",
	"SUB_POCASI",
	"SUB_POCITACOVA_HRA",
	"SUB_POHADKOVA_POSTAVA",
	"SUB_POLITIK",
	"SUB_POTRAVINA",
	"SUB_POVOLANI",
	"SUB_PROFESE",
	"SUB_PTAK",
	"SUB_REKA",
	"SUB_ROSTLINA",
	"SUB_SAVEC",
	"SUB_SKOLNI_POMUCKA",
	"SUB_SKOLNI_PREDMET",
	"SUB_SKLADATEL",
	"SUB_SKUPINA",
	"SUB_SPISOVATEL",
	"SUB_SPORT",
	"SUB_SPORTOVEC",
	"SUB_SPORTOVNI_TYM",
	"SUB_SPORTOVNI_VYBAVENI",
	"SUB_STAT",
	"SUB_STROM",
	"SUB_SUPERHRDINA",
	"SUB_TECHNOLOGIE",
	"SUB_TRADICE",
	"SUB_TV_SERIAL",
	"SUB_VEDEC",
	"SUB_VELICINA",
	"SUB_VLASTNOST",
	"SUB_ZDRAVOTNI_POTREBY",
	"SUB_ZELENINA",
	"SUB_ZENSKE_JMENO",
	"SUB_ZVIRE",
]

# ========================
# Nastavení prostředí
# ========================

# Ztlumený zvuk
var is_sound_enabled: bool = true
# Ztlumena řeč
var is_mic_enabled: bool = true
# Povoleni autostop funcionality
var is_autostop_enabled: bool = false
# Rozsah náhodných bodů pro písmena
var points_range: Vector2i = Vector2i(1, 5)
# Zobrazovat hodnoty pismen?
var is_points_visible: bool = true
# Povolit odpocet kola?
var is_round_enabled: bool = true

# Skóre týmů
var team1_score: int = 0
var team2_score: int = 0

# Rychlost losování
var spin_wait_time: float = 0.05
# Faktor zpomalení losování
var slowdown_factor: float = 1.2
# Hraniční hodnota pro zastavení losování
var slowdown_stop_speed: float = 0.3
# Čas pro autostop
var autostop_wait_time: float = 5.0
# Délka času na odpovědi (sec)
var round_wait_time: float = 5.0
