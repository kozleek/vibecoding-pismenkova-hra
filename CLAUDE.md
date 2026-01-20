# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Písmenková hra (Letter Game) is an interactive party game built with Godot Engine 4.5 for playing category-based word games. The game randomly draws letters and categories (e.g., "City", "Animal", "Athlete") with a time limit for coming up with answers. This is a Czech/English bilingual application designed for 1920x1080 resolution with canvas stretch mode.

## Development Commands

### Running the Project
Open the project in Godot Editor 4.5 or newer and press F5 to run, or use the Play button in the editor.

### Exporting Builds
The project is configured to export for:
- **macOS**: Universal architecture (x86_64 + ARM64)
- **Windows**: x86_64 architecture

Export presets are already configured in `export_presets.cfg`. Use Godot Editor's Project > Export menu to build for target platforms.

## Architecture

### Core Game Loop
The game operates through a state machine with these phases:

1. **Spinning Phase** (`is_spinning`): Letters and subjects rapidly cycle with visual/audio effects
2. **Stopping Phase** (`is_stopping`): Gradual slowdown after user stops the spin
3. **Finalize Phase** (`is_finalize`): Final letter and subject are revealed
4. **Round Phase** (`is_round_active`): Optional timer for answering (configurable)
5. **Answer Display**: Shows pre-generated correct answer

The main game controller (`Scripts/game.gd`) coordinates these phases through signals and timers.

### Autoload Singletons (Global Systems)

These autoloaded nodes are accessible globally throughout the project:

- **`Helpers`** (`Scripts/Globals/helpers.gd`): Utility functions
- **`Settings`** (`Scripts/Globals/settings.gd`): Game configuration constants and runtime settings
  - Defines `LETTERS_AND_POINTS` dictionary, `SUBJECTS` array with translation keys
  - Contains paths: `SAVEDATA_PATH`, `ANSWERS_PATH`, `SCENE_*_PATH`
  - Runtime settings: spin timing, round duration, autostop, points visibility, no-repeat mode
- **`UserData`** (`Scripts/Globals/user_data.gd`): Saves/loads user preferences to `user://savedata.json`
- **`Visuals`** (`Scripts/Globals/visuals.gd`): Visual effects (screen shake, pop animations, background colors)
- **`Audio`** (`Scripts/Globals/audio.gd`): Sound management via AudioServer

### Core Game Components

Each component is a class with its own scene and script:

- **`Letter`** (`Scripts/letter.gd`): Manages letter cycling and display
  - Shuffles from `Settings.LETTERS_AND_POINTS` dictionary
  - Handles letter drawing on timer ticks with sound effects
  - Manages optional points display based on settings

- **`Subject`** (`Scripts/subject.gd`): Manages category cycling
  - Uses translation keys from `Settings.SUBJECTS` array
  - All category names are localized via `tr()` function

- **`Round`** (`Scripts/round.gd`): Handles timed round countdown
  - Shows progress bar and remaining time
  - Emits `signal_round_finished` when time expires
  - Controlled by `Settings.is_round_enabled` and `Settings.round_wait_time`

- **`Answer`** (`Scripts/answer.gd`): Displays correct answers
  - Loads pre-generated answers from `Data/answers.json`
  - Answers were generated using ChatGPT 5 mini

- **`Game`** (`Scripts/game.gd`): Main controller orchestrating all components
  - Manages game state through boolean flags
  - Coordinates timers: `timer_spin` for letter/subject cycling, `timer_autostop` for auto-stop
  - Listens to signals from components and menu

### Key Game Mechanics

**Slowdown System**: When stopping, `timer_spin.wait_time` multiplies by `Settings.slowdown_factor` (1.2) on each tick until reaching `Settings.slowdown_stop_speed` (0.3s), creating a slot-machine-like deceleration effect.

**State Dependencies**: The play button availability depends on current phase:
- During spin: Shows "Stop" and is enabled
- After finalize with rounds disabled: Shows "Play" and is enabled
- After finalize with rounds enabled: Shows "Play" but disabled until round ends
- During round: Button remains disabled

**No-Repeat Mode**: When enabled (`Settings.is_no_repeat_enabled`), each letter-category combination can only appear once per session:
- Tracks used combinations in `game.used_combinations` array (format: "LETTER_SUB_CATEGORY")
- After finalize, checks if combination was already used
- If used, automatically generates new unused combination
- When all 1,633 combinations (23 letters × 71 categories) are exhausted, resets the list and starts over
- Implementation in `game._handle_no_repeat_mode()` and `game._generate_new_combination()`

**Keyboard Controls**:
- Space/Enter/NumEnter: Start/Stop spinning (bound to `spinning` input action)
- H key: Show answer when round is finished (bound to `answer` input action)

### Translation System

The app uses Godot's built-in internationalization:
- Translation source: `translations.csv` (CSV format with translation keys)
- Compiled translations: `translations.cs.translation` (Czech), `translations.en.translation` (English)
- All subject names use translation keys prefixed with `SUB_` (e.g., `SUB_MESTO`, `SUB_ZVIRE`)
- UI text uses keys prefixed with `UI_` (e.g., `UI_SEC` for seconds)
- Access via `tr("KEY_NAME")` function

### Data Files

- **`Data/answers.json`**: Pre-generated answers for all letter+category combinations
  - Structure: `{ "category_key": { "letter": "answer" } }`
  - Used by Answer component to display example correct answers

- **`user://savedata.json`**: User preferences (sound, autostop, points range, round settings)
  - Automatically saved/loaded via UserData singleton
  - Located in Godot's user data directory (platform-specific)

### Settings Persistence

User settings are saved as JSON with these fields:
- `is_sound_enabled`, `is_mic_enabled`, `is_autostop_enabled`
- `points_min`, `points_max` (Vector2i components)
- `is_points_visible`, `is_round_enabled`, `is_no_repeat_enabled`
- `team1_score`, `team2_score`

## Project Structure Notes

- **Scripts/**: All GDScript files organized by function
  - **Globals/**: Autoloaded singleton scripts
  - Root level: Scene-specific scripts (game.gd, menu.gd, letter.gd, etc.)
- **Scenes/**: `.tscn` scene files matching script names
- **Data/**: JSON data files
- **Assets/**: Audio, fonts, icons, and other resources
- **Styles/**: UI styling resources
- **Themes/**: Godot theme files

## Important Implementation Details

### Signal Flow
Game phases are coordinated through signals:
- `Game.signal_spin_start` → Components reset and hide/show UI elements
- `Game.signal_spin_stop` → Components begin slowdown
- `Game.signal_spin_finalize` → Components reveal final state, play effects
- `Round.signal_round_finished` → Game re-enables play button and help button

### Timer Coordination
- `timer_spin`: Fires repeatedly during spinning, calling `letter.draw_letter()` and `subject.draw_subject()`
- `timer_autostop`: One-shot timer that auto-stops spinning after `Settings.autostop_wait_time`
- `timer_round`: Countdown timer for answer phase
- `timer_round_step`: 1-second ticker for updating remaining time display

### Visual Effects
The `Visuals` singleton provides reusable effects:
- `screen_shake(node, intensity, duration, repeat)`: Camera shake effect on any node
- `pop_animation(node, factor, duration, repeat)`: Scale pop effect using tweens
- `change_background_color(node)`: Generates random purple/pink gradient backgrounds
- All effects use Godot's Tween system

### Scene Management
Main scenes are referenced in Settings constants:
- Menu/intro flow uses `SCENE_INTRO_PATH` and `SCENA_GAME_PATH`
- Scene transitions should use these constants for consistency

## Godot-Specific Patterns

- **Class Names**: Major components use `class_name` directive (Game, Letter, Subject, Round) for type-safe references
- **@onready**: Node references use `@onready var` for initialization after scene tree is ready
- **Signals**: Custom signals follow `signal_*` naming convention
- **Packed Types**: Use `PackedStringArray`, `Vector2i` for Godot-specific data types
- **FileAccess**: For JSON operations, use `FileAccess.open()` with explicit close
- **Translation**: Always use `tr()` for user-facing strings to support Czech/English

## Coding Guidelines and Best Practices

### Naming Conventions

Follow Godot's official style guide strictly:

- **Variables and Functions**: Use `snake_case` for all variables, functions, and parameters
  - Good: `answer_container`, `current_letter`, `load_answers()`
  - Bad: `answerContainer`, `currentLetter`, `loadAnswers()`
- **Constants**: Use `UPPER_SNAKE_CASE` for constants
  - Example: `LETTERS_AND_POINTS`, `ANSWERS_PATH`
- **Private Functions**: Prefix internal/private functions with underscore `_`
  - Private: `_load_answers()`, `_shuffle_letters()`, `_get_answer()`
  - Public API: `show_answer()`, `hide_answer()`, `get_current_letter()`
- **Signals**: Use `signal_*` prefix for custom signals
  - Example: `signal_spin_start`, `signal_round_finished`

### Code Organization

- **Remove Unused Code**: Eliminate unused variables, functions, or imports
  - Prefer local variables over instance variables when data isn't shared across methods
  - Example: Replace instance `current_answer: String` with local `var answer_text` if only used in one function
- **Function Visibility**: Mark functions as private (with `_` prefix) if they are only used internally
  - Public functions form the component's API and may be called from other scripts
  - Private functions are implementation details

### Comments and Documentation

Write comments in **Czech** for better team understanding:

- **File-level comments**: Describe what the component does
- **Variable documentation**: Explain data structures and their purpose
  ```gdscript
  # Dictionary s předgenerovanými odpověďmi ve struktuře: { "SUB_KEY": { "A": "odpověď", "B": ... } }
  var answers: Dictionary = {}
  ```
- **Section headers**: Use decorative separators for logical sections
  ```gdscript
  # ========================
  # Načtení předgenerovaných odpovědí
  # ========================
  ```
- **Inline comments**: Explain non-obvious logic, decisions, and edge cases
  ```gdscript
  # Kontrola existence souboru s odpověďmi
  if not FileAccess.file_exists(path):
      push_warning("Answer file not found at path: %s" % path)
      return
  ```

### Error Handling

Implement robust error handling for all I/O operations and external dependencies:

- **File Operations**: Always check if file exists and if `FileAccess.open()` returns non-null
  ```gdscript
  if not FileAccess.file_exists(path):
      push_warning("Answer file not found at path: %s" % path)
      return

  var file = FileAccess.open(path, FileAccess.READ)
  if file == null:
      push_error("Failed to open file: %s. Error: %s" % [path, FileAccess.get_open_error()])
      return
  ```
- **JSON Parsing**: Validate parse results and check data types
  ```gdscript
  var json = JSON.new()
  var parse_result = json.parse(json_text)
  if parse_result != OK:
      push_error("Failed to parse JSON. Error at line %d: %s" % [json.get_error_line(), json.get_error_message()])
      return

  if typeof(json.data) != TYPE_DICTIONARY:
      push_error("JSON root must be a Dictionary, got: %s" % type_string(typeof(json.data)))
      return
  ```
- **Logging Levels**:
  - `push_warning()`: For non-critical issues (missing optional files, deprecated features)
  - `push_error()`: For critical failures that prevent functionality
  - Include context in error messages (file paths, error codes, line numbers)
- **Early Returns**: Use early returns to handle error cases and reduce nesting
- **Resource Cleanup**: Always close files explicitly with `file.close()` after reading/writing

### Code Quality

- **Type Hints**: Always use type hints for function parameters and return values
  ```gdscript
  func get_answer(subject: String, letter: String) -> String:
  ```
- **Defensive Programming**: Validate assumptions and handle edge cases
  - Check if dictionary keys exist before accessing: `if answers.has(subject):`
  - Validate data types before processing
  - Return safe defaults (empty strings, empty arrays) instead of null when appropriate
- **Single Responsibility**: Each function should do one thing well
- **DRY Principle**: Avoid code duplication - extract common logic into helper functions
