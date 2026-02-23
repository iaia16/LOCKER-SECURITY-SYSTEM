# Encryption Code Application for Locker Security

## Overview
This project implements a digital control block responsible for managing a secure 3-character hexadecimal cipher to lock and unlock a cabinet. Developed for the Nexys A7 FPGA, the system provides a user-friendly interface using a Seven-Segment Display (SSD) and LED signaling.

## Functional Specifications
* **Secure Locking:** Users set a 3-digit code using UP and DOWN buttons to cycle through characters 0-F.
* **Status Signaling:**
  * `FREE_OCCUPIED_LED`: Signals if the cabinet is free (OFF) or busy/locked (ON).
  * `ENTER_CHARACTER_LED`: Lights up during the code entry process.
* **SSD Feedback:** The current character is displayed on the SSD; confirmed characters remain visible in their respective positions.
* **Validation Logic:** During unlocking, the system compares the entered code against the stored cipher. If they match, the locker unlocks; otherwise, it remains secured.
* **System Reset:** A global RESET button returns the system to its initial IDLE state at any time.

## Technical Design
The system architecture utilizes a Control Unit (CU) and Execution Unit (EU) approach to separate state logic from data operations.

### Core Modules:
1. **Control Unit (CU):** Manages a 15-state Finite State Machine (FSM), including IDLE, STORE_DIGIT, LOCKED_STATE, and COMPARE.
2. **Execution Unit (EU):** Stores the 3-digit cipher and performs the comparison for validation.
3. **Debouncer:** Cleans signals from mechanical buttons to prevent multiple unintended activations.
4. **Frequency Divider:** Converts the 100 MHz system clock to a frequency suitable for human interaction.
5. **SSD Unit:** Manages the multiplexing of the 7-segment display via Anode and Cathode control.

### Diagram
<img width="1025" height="1273" alt="image" src="https://github.com/user-attachments/assets/33bd8c0b-d819-471a-8eaf-b401e169251c" />

## State Machine Logic
The system transitions through 15 distinct states to manage security:

| State | Description |
| :--- | :--- |
| **IDLE** | Initial state; locker is free and awaiting user interaction. |
| **ADD_DIGIT_X_UNLOCKED** |User inputs the Xth digit (1-3) to set the initial cipher. |
| **STORE_DIGIT_X_UNLOCKED** |Stores the Xth digit and prepares for the next position. |
| **LOCKED_STATE** |Cipher is stored; system is secured and `FREE_OCCUPIED_LED` is ON. |
| **ADD_DIGIT_X_LOCKED** |User inputs the Xth digit (1-3) to attempt an unlock. |
| **STORE_DIGIT_X_LOCKED** |Captures the input digit for comparison. |
| **COMPARE** |Compares the newly entered code with the stored cipher. |

## User Manual
1. **Locking:** Press ADD_DIGIT. Use UP/DOWN to select the first character, then press ADD_DIGIT to confirm. Repeat for three digits. After the final press, the SSD clears and the FREE_OCCUPIED LED turns ON.
2. **Unlocking:** Press ADD_DIGIT to start entry. Re-enter the 3-digit code. If the PIN matches the stored code, the FREE_OCCUPIED LED turns OFF.

## Hardware Requirements
* **FPGA Board:** Nexys A7.
* **Input Buttons:** `ADD_DIGIT`, `CNT_UP`, `CNT_DOWN`.
* **Input Switch:** `RESET`.
* **Clock:** `CLK` (100 MHz).
* **Outputs:** 2 Status LEDs, 7-Segment Display (Anode/Cathode).
