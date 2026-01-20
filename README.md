# Písmenková hra

![Splashscreen](splashscreen.png)

Interaktivní aplikace pro hru v kategoriích vytvořená v Godot enginu.

**[🎮 Webová verze aplikace](https://pismenkova-hra.nase-trida.cz)**

## Popis

Písmenková hra je zábavná party aplikace inspirovaná klasickou hrou v kategoriích. Aplikace náhodně vylosuje písmeno a kategorii (např. "Město", "Zvíře", "Sportovec"), po kterém následuje časový limit pro vymyšlení odpovědi. Ideální pro hraní s přáteli nebo ve větší skupině.

## Hlavní funkce

- **Náhodné losování písmen a kategorií** - Aplikace postupně losuje písmeno a kategorii s vizuálními a zvukovými efekty
- **Počítání skóre** - Sledování bodů pro dva týmy s možností přičítat body myší nebo klávesnicí
- **Časový limit** - Nastavitelný časovač pro každé kolo (lze vypnout)
- **Zobrazení odpovědi** - Po skončení kola lze zobrazit správnou odpověď
- **Více než 70 kategorií** - Rozmanitý výběr kategorií od geografických pojmů po popkulturní odkazy
- **Jazyková podpora** - Čeština a angličtina
- **Nastavitelné parametry** - Rychlost losování, délka kola, automatické zastavení a další

## Kategorie

Hra obsahuje širokou škálu kategorií:
- Geografie (Město, Řeka, Hora, Země)
- Lidé (Sportovec, Politik, Spisovatel, Herec)
- Příroda (Zvíře, Rostlina, Strom, Ovoce, Zelenina)
- Kultura (Film, Písnička, Kniha, TV Seriál)
- Věda (Chemický prvek, Planeta, Dinosaurus)
- a mnoho dalších...

## Ovládání

### Klávesové zkratky
- **Mezerník / Enter / Num Enter** - Start/Stop losování
- **H** - Zobrazení správné odpovědi (pouze po skončení kola)
- **PageUp** - Přičtení bodů týmu 1 (červený)
- **PageDown** - Přičtení bodů týmu 2 (modrý)

### Tlačítka
- **Hrej/Stop** - Spuštění nebo zastavení losování
- **Team 1 (červený)** - Kliknutím přičtete body prvnímu týmu
- **Team 2 (modrý)** - Kliknutím přičtete body druhému týmu
- **Nastavení** - Otevření modálního okna s nastavením aplikace
  - **Vynulovat bodování** - Reset skóre obou týmů na 0

## Technické informace

### Požadavky
- Godot Engine 4.5 nebo novější
- Rozlišení: 1920x1080 (s canvas stretch módem)

### Herní mechanika

1. **Fáze losování** - Písmena a kategorie se rychle střídají s vizuálními a zvukovými efekty
2. **Zpomalení** - Po stisknutí Stop se losování postupně zpomaluje
3. **Finalizace** - Po zastavení se zobrazí vylosované písmeno a kategorie
4. **Herní kolo** - Spustí se časovač (pokud je aktivní) pro vymýšlení odpovědi
5. **Zobrazení odpovědi** - Po skončení kola lze zobrazit příkladnou správnou odpověď
6. **Počítání bodů** - Po skončení losování/kola lze přičíst body týmům

### Systém skóre

Aplikace podporuje sledování skóre pro dva týmy:
- **Přičítání bodů** - Body lze přičítat po dokončení losování nebo kola (podle nastavení)
- **Dva týmy** - Červený tým (Team 1) a modrý tým (Team 2)
- **Ovládání** - Kliknutím na barevné tlačítko nebo klávesou (PageUp/PageDown)
- **Jednorázové bodování** - Každý tým může získat body maximálně jednou za kolo
- **Oboustranné bodování** - Oba týmy mohou získat body ve stejném kole
- **Perzistence** - Skóre se automaticky ukládá a přetrvává i po restartu aplikace
- **Reset** - Možnost vynulování skóre v nastavení
- **Skrytí** - Skóre lze v nastavení kompletně vypnout a skrýt

### Nastavení aplikace

Aplikace podporuje vlastní nastavení:
- **Přehrávat zvuky** - Zapnutí/vypnutí zvukových efektů
- **Automatické zastavení losování** - Automatické zastavení po nastavené době
- **Zobrazovat body** - Zobrazení/skrytí bodového systému a skóre týmů
- **Zobrazovat odpočet kola** - Zapnutí/vypnutí časového limitu
- **Bez opakování** - Herní mód, kdy každá kombinace písmeno/kategorie je použita max. 1× za session (po vyčerpání všech 1633 kombinací se seznam resetuje)
- **Vynulovat bodování** - Reset skóre obou týmů

Všechna nastavení včetně skóre se ukládají lokálně a přetrvávají mezi spuštěními aplikace.

## Struktura projektu

```
Scripts/
├── Globals/           # Globální systémy (nastavení, zvuky, vizuální efekty)
├── game.gd           # Hlavní herní logika
├── letter.gd         # Logika losování písmen
├── subject.gd        # Logika losování kategorií
├── round.gd          # Logika časového kola
├── answer.gd         # Zobrazení správných odpovědí
├── score.gd          # Systém počítání skóre pro dva týmy
├── menu.gd           # UI menu
└── modal_settings.gd # Nastavení aplikace
```

## Použité nástroje

- **Godot Engine 4.5** - Herní engine pro vývoj aplikace
- **ChatGPT** - Odpovědi byly předgenerované pomocí AI (ChatGPT 5 mini)
- **Zvuky** - [Pixabay](https://pixabay.com/)
- **Písma**: [Caveat Brush](https://fonts.google.com/specimen/Caveat+Brush) a [Titan One](https://fonts.google.com/specimen/Titan+One)
- **Ikony**: [Phosphoricons](https://phosphoricons.com/)
