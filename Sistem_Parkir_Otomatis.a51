; ===============================================
; SISTEM PARKIR OTOMATIS - AT89C51
; Sensor Infrared + Servo + 7-Segment Counter
; ===============================================

ORG 0000H
JMP MAIN

; Interrupt Vectors
ORG 0003H       ; INT0 Interrupt
JMP INT0_ISR
ORG 000BH       ; Timer0 Interrupt
JMP TIMER0_ISR

; Main Program Initialization
ORG 0030H
MAIN:
    MOV SP, #5FH        ; Initialize stack pointer
    MOV P2, #0FFH       ; Non-aktifkan display (output high untuk common anode)
	MOV 30H, #0         ; Reset vehicle counter (address 30H)
	
    ; Tampilkan angka 0 saat inisialisasi
    MOV A, #0
    MOV P2, A
    
    ; Configure Timer0 for PWM (20ms period)
    MOV TMOD, #01H      ; Timer0 Mode 1 (16-bit)
    CLR P1.0            ; Initialize servo pin low
    
    ; Configure INT0 for edge detection
    SETB IT0            ; Falling-edge triggered
    SETB EX0            ; Enable INT0 interrupt
	SETB EA             ; Global interrupt enable
	
    ; Initialize PWM variables for 8MHz crystal
    MOV 31H, #0         ; PWM state (0=pulse, 1=gap)
    ; Timer values for 12MHz crystal (Timer increment every 1µs)
    MOV 32H, #0FBH      ; High byte for 1.5ms (90°) - 64786 (1500 counts)  
    MOV 33H, #2FH       ; Low byte for 1.5ms
    MOV 34H, #0FAH      ; High byte for 2ms (180°) - 64536 (2000 counts)
    MOV 35H, #34H       ; Low byte for 2ms
    ; Gap period calculation: 20ms - pulse = ~18.5ms
    MOV 36H, #0DBH       ; High byte for 18.5ms gap - 56286 (18500 counts)
    MOV 37H, #0DEH       ; Low byte for gap
	
; Main Loop
MAIN_LOOP:
    JNB P3.2, NO_VEHICLE   ; Check sensor state
    
    ; Vehicle detected (set 180° position)
    ACALL SERVO_180
    ACALL DELAY_20MS        ; Wait one PWM cycle
    SJMP MAIN_LOOP

NO_VEHICLE:
    ; No vehicle (set 90° position)  
    ACALL SERVO_90
    ACALL DELAY_20MS        ; Wait one PWM cycle
    SJMP MAIN_LOOP

; Servo control routines
SERVO_90:
    CLR ET0                 ; Disable timer interrupt first
    CLR TR0                 ; Stop timer
    SETB P1.0               ; Start pulse
    MOV TH0, 32H            ; Load 1ms timer values
    MOV TL0, 33H
    CLR 31H                 ; Set state to pulse
    SETB ET0                ; Enable Timer0 interrupt
    SETB TR0                ; Start timer
    RET

SERVO_180:
    CLR ET0                 ; Disable timer interrupt first
    CLR TR0                 ; Stop timer
    SETB P1.0               ; Start pulse
    MOV TH0, 34H            ; Load 1.5ms timer values
    MOV TL0, 35H
    CLR 31H                 ; Set state to pulse
    SETB ET0                ; Enable Timer0 interrupt
    SETB TR0                ; Start timer
    RET

; Simple delay for 20ms (one PWM cycle)
DELAY_20MS:
    MOV R6, #20             ; 20ms delay
	
DELAY_1MS:
    MOV R7, #133            ; Inner loop for 1ms at 8MHz
DELAY_LOOP:
    DJNZ R7, DELAY_LOOP
    DJNZ R6, DELAY_1MS
    RET

; INT0 Interrupt Service Routine
INT0_ISR:
    PUSH ACC                ; Save accumulator
    PUSH PSW
	
; Debouncing 5ms
    MOV R0, #5
DELAY_5MS:
    MOV R1, #250
    DJNZ R1, $
    DJNZ R0, DELAY_5MS
    
    ; Validasi sinyal tetap LOW
    JB P3.2, EXIT_ISR
	
	INC 30H                 ; Increment vehicle count
    MOV A, 30H
    CJNE A, #10, DISPLAY    ; Reset if count=10
    MOV 30H, #0
    MOV A, #0               ; Set A to 0 for display
DISPLAY:
    MOV P2, A               ; Output BCD value to IC 7447
EXIT_ISR:
    POP ACC
	POP PSW
    RETI

; Timer0 Interrupt Service Routine (PWM Generator)
TIMER0_ISR:
    CLR TR0                 ; Stop timer
    CLR TF0                 ; Clear overflow flag
    
    JB 31H, END_CYCLE       ; Jump if currently in gap period

; Currently in pulse period, switch to gap
START_GAP:
    CLR P1.0                ; End pulse
    MOV TH0, 36H            ; Load 18.5ms gap period
    MOV TL0, 37H
    SETB 31H                ; Set state to gap
    SETB TR0               ; Restart timer
    RETI

; End of PWM cycle
END_CYCLE:
    CLR ET0                 ; Disable timer interrupt
    CLR 31H                 ; Reset state for next cycle
    RETI

END