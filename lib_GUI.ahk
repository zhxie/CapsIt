MainText := [""]
DescText := [""]

GUIBuild(TextHolder){
    global
    Gui, Destroy
    BackgroundColor = 424242
    QueryColor = 616161
    QueryTextColor = E3E0E3
    ResultColor = 424242
    DefaultColor = 3C4A62
    ResultMainColor = FFFFF8
    ResultDescColor = D9D9D4
    SelectColor = 4F6180
    SelectMainColor = FFFFF8
    SelectDescColor = D9D9D4

    Gui, Color, %BackgroundColor%, %QueryColor%
    Gui, Font, s25 c%QueryTextColor%, Microsoft Yahei
    Gui, Add, Progress, vTextHold Background%QueryColor% x8 y8 w600 h50
    Gui, Add, Text, BackgroundTrans Center x8 y10 w600 h50, %TextHolder%
    ;Gui, Add, Edit, +BackgroundTrans Center x8 y10 w600 h50, %TextHolder%
    yNext = 66

    Loop % MainText.MaxIndex()
    {
        ResultTitle := "Result" . A_Index
        MainTextTitle := "MainText" . A_Index
        DescTextTitle := "DescText" . A_Index
        If(DescText[A_Index] != "")
        {
            yTemp1 := yNext
            yTemp2 := yTemp1 + 6
            yTemp3 := yTemp1 + 28
            Gui, Add, Progress, v%ResultTitle% Background%ResultColor% x8 y%yTemp1% w600 h50
            Gui, Font, s12 c%ResultMainColor%, Microsoft Yahei
            Gui, Add, Text, v%MainTextTitle% BackGroundTrans x18 y%yTemp2% w580, % MainText[A_Index]
            Gui, Font, s9 c%ResultDescColor%, Microsoft Yahei
            Gui, Add, Text, v%DescTextTitle% BackGroundTrans x18 y%yTemp3% w580, % DescText[A_Index]
            yNext := yTemp1 + 50
        }
        else
        {
            yTemp1 := yNext
            yTemp2 := yTemp1 + 6
            yTemp3 := yTemp1 + 6
            Gui, Add, Progress, v%ResultTitle% Background%ResultColor% x8 y%yTemp1% w600 h34
            Gui, Font, s12 c%ResultMainColor%, Microsoft Yahei
            Gui, Add, Text, v%MainTextTitle% BackGroundTrans x18 y%yTemp2% w580, % MainText[A_Index]
            Gui, Font, s9 c%ResultDescColor%, Microsoft Yahei
            Gui, Add, Text, v%DescTextTitle% BackGroundTrans x18 y%yTemp3% w580, % DescText[A_Index]
            yNext := yTemp1 + 34
        }
    }

    yEnd := yNext - 19
    Gui, Show, w611 h%yEnd% xCenter y200, AutoIt Peak
    WinSet, Style, -0xC00000, AutoIt Peak

    SelectFlag := 1
    GuiControl, +Background%SelectColor% +Redraw, Result%SelectFlag%
    GuiControl, +c%SelectMainColor% +Redraw, MainText%SelectFlag%
    GuiControl, +c%SelectDescColor% +Redraw, DescText%SelectFlag%
}


SelectUp(){
	global SelectFlag, DescText, BackgroundColor, ResultColor, DefaultColor, ResultMainColor, ResultDescColor, SelectColor, SelectMainColor, SelectDescColor
	if(SelectFlag > 1)
	{
        GuiControl, +Background%ResultColor% +Redraw, Result%SelectFlag%
        GuiControl, +c%ResultMainColor% +Redraw, MainText%SelectFlag%
        GuiControl, +c%ResultDescColor% +Redraw, DescText%SelectFlag%
		SelectFlag--
        GuiControl, +Background%SelectColor% +Redraw, Result%SelectFlag%
        GuiControl, +c%SelectMainColor% +Redraw, MainText%SelectFlag%
        GuiControl, +c%SelectDescColor% +Redraw, DescText%SelectFlag%
	}
}

SelectDown(){
	global SelectFlag, MainText, DescText, BackgroundColor, ResultColor, DefaultColor, ResultMainColor, ResultDescColor, SelectColor, SelectMainColor, SelectDescColor
	if(SelectFlag < MainText.MaxIndex())
	{
        if(SelectFlag = 1)
        {
            GuiControl, +Background%DefaultColor% +Redraw, Result%SelectFlag%
            GuiControl, +c%ResultMainColor% +Redraw, MainText%SelectFlag%
            GuiControl, +c%ResultDescColor% +Redraw, DescText%SelectFlag%
        }
        else
        {
            GuiControl, +Background%ResultColor% +Redraw, Result%SelectFlag%
            GuiControl, +c%ResultMainColor% +Redraw, MainText%SelectFlag%
            GuiControl, +c%ResultDescColor% +Redraw, DescText%SelectFlag%
        }
        SelectFlag++
        GuiControl, +Background%SelectColor% +Redraw, Result%SelectFlag%
        GuiControl, +c%SelectMainColor% +Redraw, MainText%SelectFlag%
        GuiControl, +c%SelectDescColor% +Redraw, DescText%SelectFlag%
	}
}
