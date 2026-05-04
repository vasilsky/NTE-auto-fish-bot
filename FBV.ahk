#NoEnv
#SingleInstance Force
SetBatchLines, -1
CoordMode, Pixel, Screen

Global Running := false

Numpad1::
    if (Running) {
        Running := false
        ToolTip, OFF
        Send {A up}{D up}{F up}
        SetTimer, Loop, Off
    } else {
        Running := true
        ToolTip, ON
        SetTimer, Loop, 30
    }
    return

Numpad2:: ExitApp

Loop:
    if (!Running) return

    ; 1. ЖМЁМ F
    Send {f}
    Sleep, 50

    ; 2. ИЩЕМ ЗЕЛЁНУЮ ПОЛОСУ (центр экрана)
    PixelSearch, Gx, Gy, 800, 100, 1700, 140, 0x33DDCC, 50, Fast RGB
    
    if (ErrorLevel == 0) {
        ; 3. НАШЛИ ЗЕЛЁНУЮ — ИЩЕМ ЖЁЛТЫЙ МАРКЕР
        PixelSearch, Mx, My, 800, 100, 1700, 140, 0xFFDD00, 80, Fast RGB
        
        if (ErrorLevel == 0 && Mx > 0) {
            ; Вычисляем центр зоны (Gx + половина ширины ~100px)
            Center := Gx + 100
            
            if (Mx < Center - 20) {
                Send {D down}{A up} ; Маркер слева → тянем вправо
            } else if (Mx > Center + 20) {
                Send {A down}{D up} ; Маркер справа → тянем влево
            } else {
                Send {A up}{D up}   ; В центре → стоим
            }
        } else {
            Send {A up}{D up}
        }
    }
    return