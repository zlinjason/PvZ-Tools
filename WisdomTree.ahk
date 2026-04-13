#Requires AutoHotkey v2.0

; ===================== CONFIGURATION =====================

targetWindow := "PvZ Replanted"

; For 1080p resolution window, these are the coordinates for each click
; Coordinates for each click (x, y)
click1x := 80,      click1y := 80       ; tree food
click2x := 950,     click2y := 600      ; feed tree
click3x := 1775,    click3y := 115      ; shop
click4x := 750,     click4y := 750      ; previous
click5x := 1000,    click5y := 600      ; tree food
click6x := 810,     click6y := 660      ; yes
click7x := 1000,    click7y := 950      ; go back

; Delays in milliseconds (1000 ms = 1 second)
delay1 := 250   ; Delay after click 1
delay2 := 3000   ; Delay after click 2
delay3 := 1000   ; Delay after click 3
delay4 := 500   ; Delay after click 4
delay5 := 250   ; Delay after click 5
delay6 := 250   ; Delay after click 6
delay7 := 1000   ; Delay after click 7

; How many times to repeat the entire outer sequence
outerLoops := 136

; =========================================================

F1:: RunSequence()   ; Press F1 to start
F2:: ExitApp         ; Press F2 to quit

RunSequence() {
    global

    ; Check if window exists
    if !WinExist(targetWindow) {
        MsgBox("Window not found: " targetWindow)
        return
    }

    ; Bring the window to focus
    WinActivate(targetWindow)
    WinWaitActive(targetWindow, , 2)  ; Wait up to 2 seconds for it to be active

    Loop outerLoops {
        outerNum := A_Index
        ToolTip("Outer loop " outerNum " of " outerLoops)

        ; click1 + click2, repeated 10 times (use tree food)
        Loop 10 {
            Click(click1x, click1y)
            Sleep(delay1)
            Click(click2x, click2y)
            Sleep(delay2)
        }

        ; click 3 + click4 (go to shop)
            Click(click3x, click3y)
            Sleep(delay3)
            Click(click4x, click4y)
            Sleep(delay4)

        ; click3+click4+click5+click6, repeated 10 times (buy tree food)
        Loop 10 {
            Click(click5x, click5y)
            Sleep(delay5)
            Click(click6x, click6y)
            Sleep(delay6)
        }

        ; click7 (go back)
        Click(click7x, click7y)
        Sleep(delay7)
    }

    MsgBox("Done!")
}