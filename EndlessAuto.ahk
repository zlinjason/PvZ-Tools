#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================
;  PvZ Replanted - Master Script
; ============================================================

; --- SETTINGS & STATE ---
global GameSpeed      := 1.0  ; Default starting speed
global TargetInGame   := 6750 ; Desired 6.75-second interval
global running        := false
global currentPair    := 1 
global pairs          := [[1,2],[3,4],[5,6],[7,8],[9,10]]
global ClickDelay     := 75   ; Delay for seed picking

; --- Target positions ---
TopX      := {x: 1350, y: 490}
BottomX   := {x: 1350, y: 880}
InstantTarget := {x: 1300, y: 490}
PoolTarget := {x: 1300, y: 630}

; --- Cob Cannon click positions ---
Cannons := Map(
     1, {x: 1000, y: 330}, 2, {x: 1000, y: 930},
     3, {x: 1000, y: 450}, 4, {x: 1000, y: 810},
     5, {x: 1000, y: 570}, 6, {x: 1000, y: 690},
     7, {x: 780 , y: 570}, 8, {x: 780 , y: 690},
     9, {x: 560, y: 570}, 10, {x: 560, y: 690}
)

; --- Seed Picking Grid (1920x1080) ---
SeedGrid := Map(
    1,  {x: 400, y: 700}, ; Blover
    2,  {x: 400, y: 800}, ; Coffee Bean
    3,  {x: 700, y: 450}, ; Ice-shroom
    4,  {x: 100, y: 575}, ; Lily Pad
    5,  {x: 800, y: 450}, ; Doom-shroom
    6,  {x: 300, y: 800}, ; Kernel-pult
    7,  {x: 800, y: 925}, ; Cob Cannon
    8,  {x: 600, y: 575}, ; Spikeweed
    9,  {x: 700, y: 925}, ; Spikerock
    10, {x: 800, y: 575}, ; Tall-nut
)

PickOrder := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

; ============================================================
;  HOTKEYS
; ============================================================

; Tab: Cycle Speed
~Tab:: {
    global GameSpeed
    if (GameSpeed = 1.0)
        GameSpeed := 1.5
    else if (GameSpeed = 1.5)
        GameSpeed := 2.0
    else if (GameSpeed = 2.0)
        GameSpeed := 2.5
    else
        GameSpeed := 1.0
    
    ToolTip "SPEED: " GameSpeed "x"
    SetTimer () => ToolTip(), -2000
}

; F1: Start/Resume Cob Cannon Loop
F1:: {
    global running
    if (running)
        return
    running := true
    ToolTip "RUNNING - Speed: " GameSpeed "x | Pair: " currentPair
    SetTimer MainLoop, -1
}

; F2: Pause Cob Cannon Loop
F2:: {
    global running
    running := false
    ToolTip "PAUSED at Pair " currentPair
    SetTimer () => ToolTip(), -2000
}

; F3: Plant Ice-shroom Sequence (Manual Trigger)
F3:: {
    global GameSpeed, InstantTarget
    ToolTip "Planting Ice-shroom..."
    
    Click 425, 90 ; Plant Ice-shroom
    Sleep 100
    Click InstantTarget.x, InstantTarget.y
    
    Sleep 2500 / GameSpeed ; Scaled wait
    
    Click 325, 90 ; Coffee Bean Activation
    Sleep 100
    Click InstantTarget.x, InstantTarget.y
    
    ToolTip "Ice-shroom Activated"
    SetTimer () => ToolTip(), -2000

    Sleep 100
}

; F4: Plant Blover (Manual Trigger)
F4:: {
    global GameSpeed, InstantTarget
    ToolTip "Planting Blover..."
    
    Click 215, 90
    Sleep 100
    Click InstantTarget.x, InstantTarget.y
    
    ToolTip "Blover Activated"
    SetTimer () => ToolTip(), -2000

    Sleep 100
}

; F5: Plant Doom-shroom Sequence (Manual Trigger)
F5:: {
    global GameSpeed, PoolTarget
    ToolTip "Planting Doom-shroom..."
    
    Click 525, 90 ; Plant Lily Pad
    Sleep 100
    Click PoolTarget.x, PoolTarget.y

    Sleep 100

    Click 630, 90 ; Plant Doom-shroom
    Sleep 100
    Click PoolTarget.x, PoolTarget.y
    
    Sleep 100
    
    Click 325, 90 ; Coffee Bean Activation
    Sleep 100
    Click PoolTarget.x, PoolTarget.y
    
    ToolTip "Doom-shroom Activated"
    SetTimer () => ToolTip(), -2000

    Sleep 100
}

; F11: Auto-Pick Seeds (Resets Speed to 1.0)
F11:: {
    global GameSpeed, running
    running := false 
    GameSpeed := 1.0 
    
    ToolTip "Auto-Picking Seeds (Speed Reset to 1.0)..."
    for index in PickOrder {
        pos := SeedGrid[index]
        Click pos.x, pos.y
        Sleep ClickDelay
    }
    ToolTip "Selection Complete! Press 'LET'S ROCK!'"
    SetTimer () => ToolTip(), -3000
}

; F12: Stop (Reset Pair AND Speed)
F12:: {
    global running, currentPair, GameSpeed
    running := false
    currentPair := 1
    GameSpeed := 1.0
    ToolTip "STOPPED - Progress & Speed Reset"
    SetTimer () => ToolTip(), -2000
}

; Ctrl+LButton: Coordinate Finder
^LButton:: {
    MouseGetPos &xpos, &ypos
    MsgBox "Cursor Position:`nX: " xpos "`nY: " ypos
}

; ============================================================
;  LOGIC FUNCTIONS
; ============================================================

FireCannon(cannonNum) {
    global Cannons, TopX, BottomX, GameSpeed
    cannon := Cannons[cannonNum]
    target := (Mod(cannonNum, 2) = 1) ? TopX : BottomX

    Click cannon.x, cannon.y
    Sleep 200 / GameSpeed
    Click target.x, target.y
    Sleep 100 / GameSpeed
}

MainLoop() {
    global running, GameSpeed, TargetInGame, currentPair, pairs
    
    while running {
        pair := pairs[currentPair]
        startTime := A_TickCount

        FireCannon(pair[1])
        Sleep 200 / GameSpeed
        FireCannon(pair[2])

        currentPair := (currentPair >= pairs.Length) ? 1 : currentPair + 1

        while (A_TickCount - startTime < (TargetInGame / GameSpeed)) {
            if !running
                return 
            Sleep 10
        }
    }
}