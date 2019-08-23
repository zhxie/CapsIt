; Block pop-up ad of QQ
KillQQPop(){
    global ProgTitle, QQPopTitle, NotiLevel
    IfWinExist, ahk_class TXGuiFoundation
	{
		WinGetPos, Xpos, Ypos, Width, Height
		if((Width > 280 && Width < 400) && (Height > 170 && Height < 300))
		{
			WinGetTitle, Title
			; White list check
			if (StrLen(Title)!= 0 AND Title!= "QQ" AND Title!= "QQ登录安全提醒" AND Title!="TXMenuWindow" AND Title!="TXDragWindow" AND Title!= "腾讯新闻" AND !(Title~="会话") AND !(Title~="@") AND !(Title~="("))
			{
				WinClose
				Sleep, 100
				keep("QQ系统消息 " Title " 已被关闭", 1)
			}
		}
	}
    return
}

; SmartDetect(){
; 	global SmartDetectItem, isSmartDetectNow
; 	WinGetClass, foreWindow, A
; 	if(foreWindow = "CabinetWClass")
; 	{
; 		SmartDetectItem := getExplorerPath()
; 		isSmartDetectNow := 1
; 	}
; 	else if(foreWindow = "Chrome_WidgetWin_1")
; 	{
; 		SmartDetectItem := getBrowserUrl("Chrome_WidgetWin_1")
; 		isSmartDetectNow := 1
; 	}
; 	else
; 		isSmartDetectNow := 0
; }