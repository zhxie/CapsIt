#Persistent
ProgVer = 0.2.107
ProgTitle = CapsIt

#include lib_Init.ahk

if(Arch_KillQQPop)
	SetTimer, KillQQPop, 1000
return

KillQQPop:
	KillQQPop()
return

ViewHistory:
	Msgbox %history%%A_Hour%:%A_Min%:%A_Sec%%A_Tab%...
return

SwitchWheelButton:
	if(!Hotk_SwitchWheelButton)
	{
		Hotk_SwitchWheelButton := 1
		Menu, Tray, Check, Switch XButton && WheelX
	}
	else
	{
		Hotk_SwitchWheelButton := 0
		Menu, Tray, Uncheck, Switch XButton && WheelX
	}
return

EWD_WatchMouse:
	GetKeyState, EWD_LButtonState, LButton, P
	if EWD_LButtonState = U
	{
		SetTimer, EWD_WatchMouse, off
		WinGetPos, EWD_AfterPosX, EWD_AfterPosY,,, ahk_id %EWD_MouseWin%
		if(EWD_AfterPosX = EWD_OriginalPosX AND EWD_AfterPosY = EWD_OriginalPosY)
			Send {LButton}
		return
	}
	GetKeyState, EWD_EscapeState, Escape, P
	if EWD_EscapeState = D
	{
		SetTimer, EWD_WatchMouse, off
		WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
		return
	}
	CoordMode, Mouse
	MouseGetPos, EWD_MouseX, EWD_MouseY
	WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
	SetWinDelay, -1
	WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
	EWD_MouseStartX := EWD_MouseX
	EWD_MouseStartY := EWD_MouseY
return

ProgMenuHandler:
	if(A_ThisMenu = "Prog")
	{
		if(A_ThisMenuItemPos = 1)
			Clipboard := A_ThisMenuItem
		else if(A_ThisMenuItemPos = 3)
		{
			Path := SubStr(A_ThisMenuItem, 5 , StrLen(A_ThisMenuItem) - 4)
			Run, %Path%,,Show
		}
		else if(A_ThisMenuItemPos >= 2 AND A_ThisMenuItemPos <= 5 AND A_ThisMenuItemPos != 3)
			Clipboard := SubStr(A_ThisMenuItem, RegExMatch(A_ThisMenuItem, ": ") + 2, StrLen(A_ThisMenuItem) - RegExMatch(A_ThisMenuItem, ": ") - 1)

		else if(A_ThisMenuItem = "置顶(&A)")
		{
			Sleep, 100
			WindowAlwaysOnTop()
		}
		else if(A_ThisMenuItem = "切换静音(&S)")
		{
			Sleep, 100
			Mute()
		}
		else if(RegExMatch(A_ThisMenuItem, "排除 ") = 1)
		{
			WinGet, ProgName, ProcessName, A
			if(!ExceptionCheck())
				IniWrite, %ProgName%, config.ini, Exception
			else
			{
				IniDelete, config.ini, Exception
				ExceptionProgCount := ExceptionProg.MaxIndex()
				Loop % ExceptionProg.MaxIndex()
				{
					ThisExceptionProg := ExceptionProg[ExceptionProgCount - A_Index + 1]
					if(ExceptionProg[ExceptionProgCount - A_Index + 1] != ProgName)
						IniWrite, %ThisExceptionProg%, config.ini, Exception
				}
			}
			Reload
		}
	}
	if(A_ThisMenu = "ProgSub1")
	{
		if(A_ThisMenuItem = "关闭(&C)")
		{
			Sleep, 10
			WinClose, A
		}
		else if(A_ThisMenuItem = "结束进程(&K)")
		{
			Sleep, 10
			WinGet, ProgPID, PID, A
			Run, %Comspec% /c taskkill /pid %ProgPID%,,Hide
		}
		else if(A_ThisMenuItem = "强制结束进程(&F)")
		{
			Sleep, 10
			WinGet, ProgPID, PID, A
			Run, %Comspec% /c taskkill /pid %ProgPID% /f,,Hide
		}
	}
return

DictMenuHandler:
	if(A_ThisMenuItem = "使用 必应翻译 查询(&B)")
		Define(2, selText)
	if(A_ThisMenuItem = "使用 有道翻译 查询(&Y)")
		Define(1, selText)
	if(A_ThisMenuItem = "使用 Google 翻译 查询(&G)")
	{
		GoogleTranslate(selText)
		WinClose, ahk_class tooltips_class32
	}
	if(A_ThisMenuItem = "复制音标")
	{
		Clipboard := SubStr(selTextPhone[1], StrLen(selTextPhone[1]) - 2, 2)
		WinClose, ahk_class tooltips_class32
	}
	if(A_ThisMenuItem = "复制结果")
	{
		msg := ""
		Loop % selTextExpln.MaxIndex()
			msg := msg . "`n" . selTextExpln[A_Index]
		Clipboard := msg
		WinClose, ahk_class tooltips_class32
	}
	if(A_ThisMenuItem = "复制简明结果")
	{
		Clipboard := ydRecvTrans
		WinClose, ahk_class tooltips_class32
	}
	if(A_ThisMenuItem = "振假名(&F)")
		Define(3, selText)
	if(A_ThisMenuItem = "转换为 英文(&M)" OR A_ThisMenuItem = "转换为 摩尔斯电码(&M)")
		Define(4, selText)
	if(A_ThisMenuItem = "转换为 假名(&J)")
		Define(5, selText)
	if(A_ThisMenuItem = "取消(&C)")
		WinClose, ahk_class tooltips_class32
return

RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
return

#if Caps_Space
	Capslock & Space::SpaceAction()

#if Caps_Clipboard
	Capslock & x::ClipCut()
	Capslock & c::ClipCopy()
	Capslock & v::ClipPaste()
#if Caps_Sniff
	Capslock & f::Sniff()
#if Caps_Define
	Capslock & d::Define(0, "")
#if Caps_Inspector
	Capslock & Shift::ShowProgMenu()
#If MouseIsOver("ahk_class tooltips_class32")
	LButton::WinClose, ahk_class tooltips_class32
	RButton::ShowDictMenu()

#if (GetKeyState("Alt") OR GetKeyState("Ctrl") OR GetKeyState("Shift")) AND Hotk_Fn
	Volume_Mute::F1
	Volume_Down::F2
	Volume_Up::F3
	Media_Prev::F4
	Media_Play_Pause::F5
	Media_Next::F6
	Browser_Search::F9
#if Hotk_SwitchWheelButton AND ExceptionCheck() = 0
	WheelLeft::Send {XButton1}
	WheelRight::Send {XButton2}
	XButton1::Send {WheelLeft}
	XButton2::Send {WheelRight}
#if WinActive("ahk_class Notepad") AND Hotk_NotepadClose
	^w::Send !{F4}
#if WinActive("ahk_class WeChatLoginWndForPC") AND Hotk_WeChatEnter
	Enter::WeChatLogin()
#if Hotk_WindowDrag AND ExceptionCheck() = 0
	#LButton::
		CoordMode, Mouse
		MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
		WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
		WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
		if EWD_WinState = 0
			SetTimer, EWD_WatchMouse, 10
#if Hotk_InclineSwitch AND ExceptionCheck() = 0
	MButton & WheelLeft::Send ^#{Left}
	MButton & WheelRight::Send ^#{Right}

#If MouseIsOver("ahk_class Shell_TrayWnd") AND Hotk_TaskbarWheel
	WheelUp::Remap("WheelUp", Mouse_TaskbarControl)
	WheelDown::Remap("WheelDown", Mouse_TaskbarControl)
	WheelLeft::Remap("WheelLeft", Mouse_TaskbarControl)
	WheelRight::Remap("WheelRight", Mouse_TaskbarControl)
#If !(MousePos(0, 2) = 0) AND (MousePos(0, 1) = 0 OR MousePos(0, 1) =  A_ScreenWidth - 1) AND Hotk_SidesWheel
	WheelLeft::Remap("WheelLeft", Mouse_SidesControl)
	WheelRight::Remap("WheelRight", Mouse_SidesControl)
#If MousePos(0, 2) = 0 AND Hotk_TopWheel
	WheelUp::Remap("WheelUp", Mouse_TopControl)
	WheelDown::Remap("WheelDown", Mouse_TopControl)
	WheelLeft::Remap("WheelLeft", Mouse_TopControl)
	WheelRight::Remap("WheelRight", Mouse_TopControl)