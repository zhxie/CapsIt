; Load configuration
IniRead, IniVer, config.ini, Program, Version
IniRead, Arch_KillQQPop, config.ini, AddOn, KillQQPop
IniRead, Hotk_Fn, config.ini, AddOn, Fn
IniRead, Hotk_SwitchWheelButton, config.ini, AddOn, SwitchWheelButton
IniRead, Hotk_NotepadClose, config.ini, AddOn, NotepadClose
IniRead, Hotk_WeChatEnter, config.ini, AddOn, WeChatEnter
IniRead, Hotk_WindowDrag, config.ini, AddOn, WindowDrag
IniRead, Hotk_InclineSwitch, config.ini, AddOn, InclineSwitch
IniRead, Hotk_WheelOnEdge, config.ini, AddOn, WheelOnEdge
IniRead, Caps_Space, config.ini, Capslock, Action
IniRead, Caps_Clipboard, config.ini, Capslock, Clipboard
IniRead, Caps_Sniff, config.ini, Capslock, Sniff
IniRead, Caps_Define, config.ini, Capslock, Define
IniRead, Caps_Inspector, config.ini, Capslock, Inspector
IniRead, YoudaoAPIKey, config.ini, API, Youdao
IniRead, YahooJPAPI, config.ini, API, YahooJP
IniRead, SniffSection, config.ini, Sniff
IniRead, AlterSection, config.ini, Alter
IniRead, ExceptionSection, config.ini, Exception

#include lib_Browser.ahk
#include lib_Json.ahk
#include lib_XML.ahk
#include lib_Foundation.ahk
;#include lib_GUI.ahk
#include lib_Automation.ahk
#include lib_Capslock.ahk

MatchText := []
AlterText := []
SniffName := []
SniffContent := []
ExceptionProg := []
AppendMenu := []
AppendProg := []

YoudaoAPIOrg := IniKeyParseAssign(YoudaoAPIKey, 1)
YoudaoAPI := IniKeyParseAssign(YoudaoAPIKey, 2)
IniSectionParse(SniffSection, SniffName, SniffContent)
IniSectionParse(AlterSection, MatchText, AlterText)
ExceptionProg := StrSplit(ExceptionSection, "`n")

Hotk_TopWheel = Floor(Hotk_WheelOnEdge / 100)
Hotk_SidesWheel = Floor((Hotk_WheelOnEdge - 100 * Hotk_TopWheel) / 10)
Hotk_TaskbarWheel = Hotk_WheelOnEdge - 100 * Hotk_TopWheel - 10 * Hotk_SidesWheel

if(A_IsCompiled = 1)
{
	Menu, Tray, Add, %ProgTitle% %ProgVer%, ViewHistory
	Menu, Tray, Disable, %ProgTitle% %ProgVer%
}
else
{
	Menu, Tray, Add, %ProgTitle% %ProgVer%[DEV], ViewHistory
	Menu, Tray, Disable, %ProgTitle% %ProgVer%[DEV]
}
Menu, Tray, Add, View History[0], ViewHistory
if(A_IsCompiled = 1)
	Menu, Tray, Default, View History[0]
Menu, Tray, Disable, View History[0]
Menu, Tray, Add
Menu, Tray, Add, Switch XButton && WheelX, SwitchWheelButton
if(Hotk_SwitchWheelButton)
	Menu, Tray, Check, Switch XButton && WheelX
Menu, Tray, Add
Menu, Tray, NoStandard
Menu, Tray, Standard
