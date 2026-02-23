# Encryption Code Application for Locker Security
**Digital Systems Design Project**

## Overview
[cite_start]This project implements a digital control block responsible for managing a secure 3-character hexadecimal cipher to lock and unlock a cabinet[cite: 22, 67]. [cite_start]Developed for the **Nexys A7 FPGA**, the system provides a user-friendly interface using a Seven-Segment Display (SSD) and LED signaling[cite: 68, 361].

## Functional Specifications
* [cite_start]**Secure Locking:** Users set a 3-digit code using `UP` and `DOWN` buttons to cycle through characters `0-F`[cite: 27, 28].
* [cite_start]**Status Signaling:** * `FREE_OCCUPIED_LED`: Signals if the cabinet is free (OFF) or busy/locked (ON)[cite: 24, 85].
    * [cite_start]`ENTER_CHARACTER_LED`: Lights up during the code entry process[cite: 26, 89].
* [cite_start]**SSD Feedback:** The current character is displayed on the SSD; confirmed characters remain visible in their respective positions[cite: 29, 31, 32].
* [cite_start]**Validation Logic:** During unlocking, the system compares the entered code against the stored cipher[cite: 38]. [cite_start]If they match, the locker unlocks; otherwise, it remains secured[cite: 39, 40].
* [cite_start]**System Reset:** A global `RESET` button returns the system to its initial IDLE state at any time[cite: 35, 78].

## Technical Design
[cite_start]The system architecture utilizes a **Control Unit (CU)** and **Execution Unit (EU)** approach to separate state logic from data operations[cite: 97].

### Core Modules:
1. [cite_start]**Control Unit (CU):** Manages a 15-state Finite State Machine (FSM), including `IDLE`, `STORE_DIGIT`, `LOCKED_STATE`, and `COMPARE`[cite: 153, 308, 348].
2. [cite_start]**Execution Unit (EU):** Stores the 3-digit cipher and performs the comparison for validation[cite: 155, 156].
3. [cite_start]**Debouncer:** Cleans signals from mechanical buttons to prevent multiple unintended activations[cite: 138, 139].
4. [cite_start]**Frequency Divider:** Converts the 100 MHz system clock to a frequency suitable for human interaction (approx. 1 kHz)[cite: 147].
5. [cite_start]**SSD Unit:** Manages the multiplexing of the 7-segment display via Anode and Cathode control[cite: 158, 160].



## User Manual
1. **Locking:** Press `ADD_DIGIT`. Use `UP/DOWN` to select the first character, then press `ADD_DIGIT` to confirm. [cite_start]Repeat for three digits[cite: 42, 43, 44]. [cite_start]After the final press, the SSD clears and the `FREE_OCCUPIED` LED turns ON[cite: 33].
2. [cite_start]**Unlocking:** Press `ADD_DIGIT` to start entry[cite: 36]. Re-enter the 3-digit code. If correct, the `FREE_OCCUPIED` LED turns OFF[cite: 39].

## Hardware Requirements
* [cite_start]**FPGA Board:** Nexys A7.
* [cite_start]**Inputs:** `ADD_DIGIT`, `CNT_UP`, `CNT_DOWN`, `RESET`, and `CLK`.
* [cite_start]**Outputs:** 2 Status LEDs, 7-Segment Display (Anode/Cathode).


---
