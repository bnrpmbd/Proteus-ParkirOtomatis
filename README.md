# Sistem Parkir Otomatis (Automatic Parking System) — Proteus Simulation

**Sistem Parkir Otomatis** (Automatic Parking System) is a simulated prototype for an embedded parking controller implemented in 8051 assembly (`.a51`) and validated using Proteus (ISIS). The system models common parking-lot behaviors: vehicle detection, barrier/gate control, occupancy counting, user feedback (LED / 7-seg / LCD), and basic safety/time logic. This repository is ideal as a demonstrator for embedded systems coursework, control logic, and Proteus-based validation.

---

## Preview / Project scope
- Firmware is provided as 8051 assembly source (`.a51`) that can be assembled into a HEX file and loaded into an 8051 MCU model in Proteus.  
- The Proteus schematic simulates sensors (IR/ultrasonic/loop), gate actuator (relay/MOSFET/servo), display modules, and virtual instruments for debugging.

---

## Key features
- **Vehicle detection** — simulated sensor input (IR/ultrasonic or loop sensor) to detect vehicle arrival/departure.  
- **Gate / barrier control** — microcontroller-driven actuator control for opening/closing a barrier with timing and safety checks.  
- **Occupancy counting** — increments/decrements current-occupancy counter and enforces capacity limits.  
- **User feedback** — status indicators via LEDs, 7-segment display, or optional LCD for showing available slots or messages.  
- **Access logic** — simple entry/exit state machine with debounce and anti-bounce handling.  
- **Safety/timeouts** — configurable timeouts to avoid stuck-open/stuck-closed states and limit actuator runtime.  
- **Proteus testbench** — includes virtual oscilloscope/logic analyzer/virtual terminal to observe signals and state transitions during simulation.  
- **Assembly-level firmware** — compact `.a51` source suitable for teaching low-level I/O, timers, and state machines.

---

## Technologies
- **Firmware:** 8051 assembly (`.a51`) — targetting generic 8051/AT89 family.  
- **Simulation:** Proteus (ISIS) for circuit modeling and behavioral validation.  
- **Toolchain:** Keil uVision (recommended) or any compatible 8051 assembler that produces Intel HEX.


---

## How to build HEX from `.a51` (Keil uVision)
1. Open Keil uVision (or other 8051 assembler).  
2. Create a new project and add `Sistem_Parkir_Otomatis.a51`.  
3. Select the target device (generic 8051 or the specific AT89/variant you emulate).  
4. Configure project options (clock frequency/crystal) to match Proteus MCU model.  
5. Build/Compile the project — Keil will output a `.hex` file (Intel HEX format).  
6. Note the HEX path for use in Proteus (Program File property of the MCU).

> If you use another assembler, ensure it outputs Intel HEX compatible with Proteus.

---

## How to run the simulation in Proteus
1. Open Proteus ISIS and load the project schematic (`.dsn` / `.pdsprj`) or create a schematic matching the project components.  
2. Place the 8051 MCU component and double-click to load the generated `.hex` file (Program File).  
3. Add simulated sensors (e.g., IR sensor, ultrasonic module model, or logic input toggle) and the actuator (relay, MOSFET + motor model, or servo).  
4. Connect LEDs, 7-segment displays, or LCD modules used to show occupancy/state.  
5. Optionally add Virtual Instruments: Logic Analyzer, Oscilloscope, Virtual Terminal for messages.  
6. Power the circuit (VCC/GND) and start the simulation (`Run`).  
7. Trigger sensor inputs manually (logic toggles) or use signal generators to simulate vehicle arrival/exit and observe system behavior: barrier movement, counter changes, and status updates.  
8. Iterate: update assembly source, rebuild HEX, reload in Proteus, and re-run.

---

## Troubleshooting tips
- **MCU does not run / program not loaded:** ensure `.hex` file is correctly assigned and the MCU model matches the target device family.  
- **Timing seems wrong:** set the MCU clock/crystal frequency in both Keil and Proteus to the same value so timers behave as expected.  
- **Sensor never triggers:** check wiring and logic levels in the schematic; use a logic probe or logic toggle to simulate the sensor signal.  
- **Actuator does not respond:** verify driver stage (relay/MOSFET) connections and power rails; some Proteus motor models require proper power supply objects.  
- **Counter inconsistent / bounces:** ensure debounce routine in firmware is active; use longer debounce windows for noisy simulated sensors when needed.  
- **Proteus simulation errors:** check component models are available and library references are correct; inspect Proteus error console.

---

## Limitations & notes
- This project is a **simulation**; real-world deployment requires attention to power electronics (motor drivers, supply filtering), mechanical design, safety (emergency stops), and EMC/grounding practices.  
- Assembly firmware is intentionally simple for didactic clarity; migrating to C (or a higher-level MCU) is recommended for complex features.  
- Sensor models in Proteus are approximations—real sensors will require calibration and robust signal conditioning.

---

## Suggested next steps / improvements
- Migrate firmware to C (Keil/SDCC) and target modern microcontrollers (ARM Cortex-M, AVR, ESP32).  
- Add secure access control (RFID, barcode, or ticketing integration).  
- Implement network telemetry (occupancy dashboard) for remote monitoring (MQTT / HTTP).  
- Add payment or reservation logic, license-plate recognition (vision module), or dynamic routing for multi-level lots.  
- Move from simulation to a hardware prototype: design a PCB, select actual sensors, and bench-test with motor drivers and mechanical barriers.

---

## License
You may use and modify this code for learning and prototyping. For redistribution or commercial use, add an explicit license (e.g., MIT) to the repository.

---

## Contact
If you need help building the HEX, configuring Proteus, or would like example schematic screenshots to include in this README, open an issue or contact me via GitHub profile/email.

