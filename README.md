# Hack-and-Halt-Game

## Project Overview
Hack-and-Halt-Game is a pioneering 2D multiplayer game designed for the Intel DE1-SoC Board. It creatively utilizes the board's hardware to deliver an engaging experience where a human player navigates a facility to collect power-ups and solve binary puzzles, while a rogue AI character attempts to thwart their progress with strategic gate placements and blackouts.

## Key Features

- **Human Character**:
  - **Movement**: Controlled via WASD keys on a PS2 keyboard.
  - **Power-ups**: Collect three scattered power-ups to enhance speed.
  - **Endgame Challenge**: Solve a 10-bit binary code displayed on LEDs using switches within a time limit.

- **AI Character**:
  - **Gate Placement**: Blocks paths with gates, indicated by a cyan marker that turns red upon confirmation.
  - **Blackout Ability**: Temporarily renders power-ups invisible with a 30-second cooldown.

- **Gameplay Mechanics**:
  - **Timer**: Both players have 120 seconds to achieve their goals.
  - **Speed Increase**: Human character's speed increases with each collected power-up, escalating the AI’s challenge.
  - **Endgame Scenarios**: Features distinct win/loss screens for an immersive experience.

## Technical Details

- **Technologies Used**:
  - **Programming Languages**: Verilog for hardware design.
  - **Hardware**: Intel DE1-SoC Board.
  - **Software**: Quartus Prime for compiling Verilog code.

- **Components**:
  - **VGA Display**: Enhanced with double buffering for smoother visuals.
  - **PS2 Keyboard**: Custom module for interpreting WASD inputs.
  - **LEDs and Switches**: Display binary code and input during the endgame.

## Installation and Setup

- **Prerequisites**:
  - Intel DE1-SoC Board
  - Quartus Prime Software
  - PS2 Keyboard

- **Setup Instructions**:
  1. Connect the Intel DE1-SoC board to your PC and the PS2 keyboard.
  2. Open Quartus Prime, load, and compile the Verilog project files.
  3. Transfer the compiled files to the board and start the game by pressing the run button in Quartus Prime.

## Usage Instructions

### Controls

#### Human Character
- **Movement Controls:**
  - **`W`**: Move Up
  - **`A`**: Move Left
  - **`S`**: Move Down
  - **`D`**: Move Right
  - **Description:** These keys on the PS2 keyboard allow the human character to navigate through the facility. Each key corresponds to a specific direction, enabling smooth and precise movement.

#### AI Character
- **Gate Placement and Management:**
  - **Pushbuttons `0` & `1`:**
    - **Function:** Cycle through potential gate locations on the map.
    - **Description:** Use these buttons to navigate through predefined locations where gates can be placed. This helps the AI decide where to block paths.
  - **Pushbutton `2`:**
    - **Function:** Confirm gate placement.
    - **Description:** Press this button to finalize the placement of a gate. The marker will change from cyan to red, indicating that the gate is now active and will block the human character's path.
  - **Pushbutton `3`:**
    - **Function:** Activate blackout effect.
    - **Description:** Temporarily makes power-ups invisible to the human character. This ability has a 30-second cooldown to ensure balanced gameplay and strategic use.

### Gameplay
- **Human Character:** Collect all three power-ups scattered across the map and solve the 10-bit binary code displayed on the LEDs using switches before time runs out.
- **AI Character:** Use strategic placement of gates and blackouts to prevent the human character from achieving their objectives within the 120-second time limit.

## Examples and Demos

- **Video Demo**: [Watch the Gameplay Video](#) (Include actual video link)
- **Screenshots**:
  - ![Game Screenshot](#) (Include actual screenshot)
  - ![Endgame Screen](#) (Include actual endgame screenshot)

## Contribution

This project represents a personal and educational endeavour. Contributions from others are not accepted at this time.

## Licensing

This project is for educational purposes only and is not licensed for public distribution.

## Contact Information

- **Author**: Koosha Omidian
- **Email**: Koosha.omidian@mail.utoronto.ca

## Acknowledgments

- **Verilog Modules**: 13 Verilog files addressing various game functionalities.

## Future Improvements

- **Visual Enhancements**: Implement higher resolution graphics and further smooth visual performance.
- **Audio Features**: Integrate sound effects and additional visual elements.
- **Extended Content**: Develop new maps and varied power-ups for increased replayability.

## Challenges and Solutions

- **VGA Compatibility**: Adapted VGA adapter for higher resolutions through in-depth research and modifications.
- **PS2 Keyboard Integration**: Implemented drivers by studying PS2 communication protocols for accurate control.
