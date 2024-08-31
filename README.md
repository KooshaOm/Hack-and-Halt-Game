# Hack-and-Halt-Game

## Project Overview
**Hack-and-Halt-Game** is an innovative 2D, two-player game implemented on the Intel DE1-SoC Board. The game leverages the hardware’s capabilities to deliver a rich, interactive experience involving a human character and a rogue AI. The human must navigate a facility to collect power-ups, enhance speed, and ultimately solve a binary puzzle to defeat the AI. Meanwhile, the AI employs strategies to hinder the human's progress by placing gates and causing blackouts.

### Key Features
- **Human Character:**
  - **Movement:** Controlled via the WASD keys on a PS2 keyboard.
  - **Power-ups:** Collects three power-ups scattered throughout the map to increase speed.
  - **Endgame Challenge:** After collecting all power-ups, a 10-bit binary code is displayed on the LEDs. The human must use the switches to match this code within the time limit to win.

- **AI Character:**
  - **Gate Placement:** Can place gates to block paths. The placement is indicated by a cyan marker, which turns red when confirmed.
  - **Blackout Ability:** Temporarily makes power-ups invisible to the human character. This ability has a 30-second cooldown.
  - **Game Balance:** Gate placement and blackout abilities are balanced with cooldown periods to ensure fair play.

- **Gameplay Mechanics:**
  - **Timer:** Both players have a 120-second timer to complete their objectives.
  - **Speed Increase:** The human character’s speed increases with each collected power-up, making the AI’s task more challenging as the game progresses.
  - **Endgame Scenarios:** The game features distinct end screens for both winning and losing conditions, enhancing the overall user experience.

## Technical Details
### Technologies Used
- **Programming Languages:** Verilog for hardware design.
- **Hardware:** Intel DE1-SoC Board for implementation.
- **Software:** Quartus Prime for compiling Verilog code.

### Components
- **VGA Display:**
  - Displays the game map and animations.
  - **Implementation:** Modified VGA adapter with double buffering to improve visual performance.

- **PS2 Keyboard:**
  - Used for human character movement.
  - **Implementation:** Developed PS2 keyboard module to read and interpret WASD inputs.

- **LEDs and Switches:**
  - **LEDs:** Display the 10-bit binary code that the human must match.
  - **Switches:** Used to input the binary code during the endgame phase.

- **Gate Placement and Blackout Mechanisms:**
  - **Gate Placement:** AI can place gates on predefined locations using a two-button system to select and confirm gate positions.
  - **Blackout Mechanism:** A button is used to activate a blackout effect, making power-ups invisible for a few seconds.

## Installation and Setup
### Prerequisites
- **Intel DE1-SoC Board**
- **Quartus Prime Software** (for compiling Verilog code)
- **PS2 Keyboard**

### Setup Instructions
1. **Hardware Setup:**
   - Connect the Intel DE1-SoC board to your PC.
   - Connect the PS2 keyboard to the board.

2. **Software Setup:**
   - Open Quartus Prime and load the Verilog project files.
   - Compile the Verilog code to generate the necessary configuration files.

3. **Deployment:**
   - Transfer the compiled files to the Intel DE1-SoC board.
   - Once the transfer is complete, press the run button in Quartus Prime to start the game.

4. **Game Start:**
   - The game will automatically load the map and start the 120-second timer on the HEX displays.

## Usage Instructions
### Controls
- **Human Character:** 
  - **Movement:** Use WASD keys on the PS2 keyboard to move the character up, down, left, and right.

- **AI Character:** 
  - **Gate Placement:** Use two buttons to cycle through gate locations and confirm placement with a third button.
  - **Blackout:** Use the fourth button to activate the blackout effect, with a 30-second cooldown.

### Gameplay
- **Objective for Human Character:** Collect all three power-ups and enter the displayed binary pin using switches before the timer runs out.
- **Objective for AI Character:** Prevent the human from collecting all power-ups and completing the pin entry by placing gates and using blackouts strategically.

## Examples and Demos
- **Video Demo:** [Watch the Gameplay Video](#) *(Replace with actual video link or instructions for video upload)*
- **Screenshots:**
  - ![Game Screenshot](#) *(Include actual screenshots here)*
  - ![Endgame Screen](#) *(Include any endgame screens showing win/loss conditions)*

## Testing
- **Testing Process:**
  - Compile the Verilog code using Quartus Prime.
  - Deploy the code to the DE1-SoC board and start the game.
  - Play through the game to verify functionality, including movement, power-up collection, gate placement, and binary pin entry.
  - Address any compilation errors or gameplay issues as reported by Quartus Prime or observed during play.

## Contribution
- **Note:** This project is a personal and educational endeavour. Contributions from others are not accepted.

## Licensing
- **License:** This project is intended for educational purposes only and is not licensed for public use or distribution.

## Contact Information
- **Author:** Koosha Omidian
- **Email:** Koosha.omidian@mail.utoronto.ca

## Acknowledgments
- **Verilog Modules:** The project includes 13 Verilog files, each responsible for different aspects of the game’s functionality.

## Future Improvements
- **Visual Enhancements:** Implement double buffering to further smooth out visuals and increase resolution for better graphics.
- **Audio Features:** Add sound effects and additional visual elements to enrich the game experience.
- **Extended Content:** Introduce new maps with varied power-ups and gate configurations to increase replayability and engagement.

## Challenges and Solutions
- **VGA Compatibility:** Overcame the challenge of adapting the VGA adapter to support higher resolutions through extensive research and modification.
- **PS2 Keyboard Integration:** Successfully implemented PS2 drivers by studying documentation on PS2 communication protocols, enabling precise control of the human character.

---
