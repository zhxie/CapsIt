; Space action
SpaceAction(){
    global MatchText, AlterText, MatchSuffix
    ClipSaved := ClipboardAll
    selText := getSelText()
    conCalc = 1

    if(!selText)
        selText := getSelText2()

    ; Replace
    Loop % MatchText.Length()
    {
        IfInString, selText, % MatchText[A_Index]
        {
            conCalc = 0
            StringReplace, selText, selText, % MatchText[A_Index], % AlterText[A_Index], All
            Clipboard := selText
        }
    }

    ; Calculation
    if(conCalc)
    {
        if(SubStr(selText, 0) = "=")
        {
            StringReplace, selTextExact, selText, =, , All
            Clipboard := selText eval(selTextExact)
        }
        else
        {
            Clipboard := eval(selText)
        }
    }

    SendInput, ^{v}
    Sleep, 200
    Clipboard := ClipSaved
}

; Clipboard actions
ClipCut(){
    global
    local ClipSaved := ClipboardAll
    Clipboard := ""
    SendInput, ^{x}
    ClipWait, 2, 1
    if(!ErrorLevel)
        ClipAppend := ClipboardAll
    Clipboard := ClipSaved
}

ClipCopy(){
    global
    local ClipSaved := ClipboardAll
    Clipboard := ""
    SendInput, ^{insert}
    ClipWait, 2, 1
    if(!ErrorLevel)
        ClipAppend := ClipboardAll
    Clipboard := ClipSaved
}

ClipPaste(){
    global
    local ClipSaved := ClipboardAll
    Clipboard := ""
    Clipboard := ClipAppend
    SendInput, ^{v}
    Clipboard := ClipSaved
    ClipSaved := ""
}

; Sniff
Sniff(){
    global
    selText := getSelText()
    isselTextExist := 1
    if(!selText)
    {
        selText := getSelText2()
        isselTextExist := 0
    }
    if(!ErrorLevel && selText)
        ClipAppend := ClipSniff(selText)
    return
}

; Define
Define(defmode, text){
    global
    transSpec := [0, 0, 0] ;翻译，音标，查词；有道=1，必应=2
    selTextPhone := []
    selTextPhone2 := []
    selTextExpln := []
    selTextExpln2 := []

    if(!text)
    {
        selText := getSelText()
        isselTextExist := 1
        if(!selText)
        {
            selText := getSelText2()
            isselTextExist := 0
        }
    }
    else
    {
        selText := text
        isselTextExist := 1
    }

    if(!ErrorLevel && selText)
    {
        if(isLang(SubStr(selText, StrLen(selText), 1)) AND !isselTextExist)
            selText := selLastWord(selText)
        TooltipTime(selText . "`n正在查询中……", 5000)

        if(defmode = 0)
        {
            YoudaoDict(selText, selTextPhone, selTextExpln)

            if(ydRecvTrans != "")
                transSpec[1] := 1
            if(selTextPhone.MaxIndex())
                transSpec[2] := 1
            if(selTextExpln.MaxIndex())
                transSpec[3] := 1

            if(!selTextExpln.MaxIndex() OR !selTextPhone.MaxIndex())
            {
                msg = % selText . selTextPhone[1]
                if(selTextExpln.MaxIndex())
                    Loop % selTextExpln.MaxIndex()
                        msg := msg . "`n" . selTextExpln[A_Index]
                ToolTipTime(msg . "`n正在查询中……", 3000)

                BingDict(selText, selTextPhone2, selTextExpln2)

                if(!selTextPhone.MaxIndex())
                {
                    selTextPhone := selTextPhone2
                    if(selTextPhone.MaxIndex())
                        transSpec[2] := 2
                }
                if(!selTextExpln.MaxIndex())
                {
                    selTextExpln := selTextExpln2
                    if(selTextExpln.MaxIndex())
                        transSpec[3] := 2
                }
            }

            msg := selText . selTextPhone[1]
            if(!selTextExpln.MaxIndex())
            {
                if(ydRecvTrans)
                    msg := msg . "`n" . ydRecvTrans
            }
            else
                Loop % selTextExpln.MaxIndex()
                    msg := msg . "`n" . selTextExpln[A_Index]
            ToolTipTime(msg, 3000)
        }
        else if(defmode = 1)
        {
            YoudaoDict(selText, selTextPhone, selTextExpln)

            if(ydRecvTrans != "")
                transSpec[1] := 1
            if(selTextPhone.MaxIndex())
                transSpec[2] := 1
            if(selTextExpln.MaxIndex())
                transSpec[3] := 1

            msg := selText . selTextPhone[1]
            if(!selTextExpln.MaxIndex())
            {
                if(ydRecvTrans)
                    msg := msg . "`n" . ydRecvTrans
            }
            else
                Loop % selTextExpln.MaxIndex()
                    msg := msg . "`n" . selTextExpln[A_Index]
            ToolTipTime(msg, 3000)
        }
        else if(defmode = 2)
        {
            BingDict(selText, selTextPhone, selTextExpln)

            if(selTextPhone.MaxIndex())
                transSpec[2] := 2
            if(selTextExpln.MaxIndex())
                transSpec[3] := 2

            msg := selText . selTextPhone[1]
            if(selTextExpln.MaxIndex())
                Loop % selTextExpln.MaxIndex()
                    msg := msg . "`n" . selTextExpln[A_Index]
            ToolTipTime(msg, 3000)
        }
        else if(defmode = 3)
        {
            selTextExpln.Push(Furigana(selText . ".furi"))

            if(selTextExpln.MaxIndex())
            {
                transSpec[3] := 3
                selTextExpln[1] := SubStr(selTextExpln[1], 1, StrLen(selTextExpln[1]) - 5)
                msg := selText . "`n" . selTextExpln[1]
            }
            ToolTipTime(msg, 3000)
        }
        else if(defmode = 4)
        {
            selTextExpln.Push(en2morse(selText))
            if(selTextExpln.MaxIndex())
            {
                transSpec[3] := 4
                msg := selText . "`n" . selTextExpln[1]
            }
            ToolTipTime(msg, 3000)
        }
        else if(defmode = 5)
        {
            selTextExpln.Push(en2jp(seltext))
            if(selTextExpln.MaxIndex())
            {
                transSpec[3] := 5
                msg := selText . "`n" . selTextExpln[1]
            }
            ToolTipTime(msg, 3000)
        }
    }
    return
}

; Google translate
GoogleTranslate(text){
    if(!text)
    {
        selText := getSelText()
        isselTextExist := 1
        if(!selText)
        {
            selText := getSelText2()
            isselTextExist := 0
        }
    }else{
        selText := text
    }
    if(!ErrorLevel && selText)
    {
        selAction := encode(selText)
        Run, https://translate.google.com/?hl=zh-CN#auto/zh-CN/%selAction%
    }
    return
}

; Set a window always on top
WindowAlwaysOnTop(){
    global ProgTitle
    WinGetTitle, conTitle, A
    WinSet, AlwaysOnTop, toggle, %conTitle%
    WinGet, conAlwaysOnTop, ExStyle, %conTitle%
    if(conAlwaysOnTop & 0x8)
        TrayTip, %ProgTitle%, %conTitle% 已置顶,, 1
    else
        TrayTip, %ProgTitle%, %conTitle% 已取消置顶,, 1
}

; Mute a window
Mute(){
    global ProgTitle
    WinGetTitle, conTitle, A

    DetectHiddenWindows On
    Run sndvol,,Hide
    WinWait, ahk_class #32770
    WinGet, OutputVar, ControlList, ahk_class #32770
    Loop, Parse, OutputVar, "`n"
    {
        ControlGetText, buttonText, %A_LoopField%, ahk_class #32770
        if InStr(buttonText, "静音") AND InStr(buttonText, conTitle)
        {
            ControlClick, %A_LoopField%, ahk_class #32770
            TrayTip, %ProgTitle%, %conTitle% 已切换静音状态,, 1
        }
    }
    WinClose, ahk_class #32770
    DetectHiddenWindows Off
}

; Show program details of a window
ShowProgMenu(){
    global MainText, DescText, FuncText
    WinGet, ProgID, ID, A
    WinGetClass, ProgClass, A
    WinGetTitle, ProgTitle, A
    WinGet, ProgName, ProcessName, A
    WinGet, ProgPath, ProcessPath, A
    ProgPath := SubStr(ProgPath, 1, StrLen(ProgPath) - StrLen(ProgName))
    WinGet, ProgPID, PID, A
    WinGetPos, ProgX, ProgY, ProgWidth, ProgHeight, A
    MouseX0 := MousePos(0, 1)
    MouseY0 := MousePos(0, 2)
    MouseX1 := MousePos(1, 1)
    MouseY1 := MousePos(1, 2)
    WinGet, ProgTransparent, Transparent, A
    if(ProgTransparent = "")
        ProgTransparent := 255
    WinGet, ProgExStyle, ExStyle, A

    Menu, Prog, Add, AvoidError, ProgMenuHandler
    Menu, Prog, DeleteAll
    if(ProgTitle != "")
        Menu, Prog, Add, %ProgTitle%, ProgMenuHandler
    else
    {
        Menu, Prog, Add, N/A, ProgMenuHandler
        Menu, Prog, Disable, N/A
    }
    Menu, Prog, Add, 名称: %ProgName%, ProgMenuHandler
    Menu, Prog, Add, 路径: %ProgPath%, ProgMenuHandler
    Menu, Prog, Add, PID: %ProgPID%, ProgMenuHandler
    Menu, Prog, Add, 类别: %ProgClass%, ProgMenuHandler
    Menu, Prog, Add, 分辨率: %ProgWidth%x%ProgHeight%, ProgMenuHandler
    Menu, Prog, Add, 窗口位置: %ProgX%`, %ProgY%, ProgMenuHandler
    Menu, Prog, Add, 鼠标位置: %MouseX0%`, %MouseY0%(相对屏幕)`, %MouseX1%`, %MouseY1%(相对窗口), ProgMenuHandler
    Menu, Prog, Add
    Menu, Prog, Add, 不透明度: %ProgTransparent%/255, ProgMenuHandler
    Menu, Prog, Add, 置顶(&A), ProgMenuHandler
    if(ProgExStyle & 0x8)
        Menu, Prog, Check, 置顶(&A)
    Menu, Prog, Add, 切换静音(&S), ProgMenuHandler
    Menu, ProgSub1, Add, 关闭(&C), ProgMenuHandler
    Menu, ProgSub1, Add, 结束进程(&K), ProgMenuHandler
    Menu, ProgSub1, Add, 强制结束进程(&F), ProgMenuHandler
    Menu, Prog, Add, 关闭窗口(&C), :ProgSub1
    Menu, Prog, Add
    Menu, Prog, Add, 排除 %ProgName%, ProgMenuHandler
    if(ExceptionCheck() = 1)
    {
        Menu, Prog, Check, 排除 %ProgName%
    }
    Menu, Prog, Show
}
