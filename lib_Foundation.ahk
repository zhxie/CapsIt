getSelText(){
    ClipSaved := ClipboardAll
    Clipboard := ""
    SendInput, ^{insert}
    ClipWait, 0.1
    if(!ErrorLevel)
    {
        selText := Clipboard
        Clipboard := ClipSaved
        StringRight, lastChar, selText, 1
        if(Asc(lastChar)!=10) ;如果最后一个字符是换行符，就认为是在IDE那复制了整行，不要这个结果
            return selText
        else
            return SubStr(selText, 1, StrLen(selText) - 2)
    }
    Clipboard := ClipSaved
    return
}

getSelText2(){
    SendInput, +{Home}
    Sleep, 10
    return getSelText()
}

sendText(stext){
    ClipSaved := ClipboardAll
    Sleep, 10
    Clipboard := stext
    SendInput, ^{v}
    Sleep, 200
    Clipboard := ClipSaved
}

selLastWord(text){
    word := StrSplit(text, " ")
    return word[word.MaxIndex()]
}

getLastWord2(){
    SendInput, {Right}
    Sleep, 10
    SendInput, !+{Left}
    Sleep, 10
    return getSelText()
}

encode(string){
    formatInteger := A_FormatInteger
    SetFormat, IntegerFast, H
    VarSetCapacity(utf8, StrPut(string, "UTF-8"))
    Loop % StrPut(string, &utf8, "UTF-8") - 1
    {
        byte := NumGet(utf8, A_Index-1, "UChar")
        encoded .= byte > 127 ? "%" Substr(byte, 3) : Chr(byte)
    }
    SetFormat, IntegerFast, %formatInteger%
    return encoded
}

eval(exp){
	transform, exp, deref, %exp%
	; make everything lowercase, set constants to uppercase
	exp:=format("{:l}", exp)
	exp:=regExReplace(exp, "i)(E|LN2|LN10|LOG2E|LOG10E|PI|SQRT1_2|SQRT2)", "$U1")
	exp:=regExReplace(exp, "i)(abs|acos|asin|atan|atan2|ceil|cos|exp|floor"
	. "|log|max|min|pow|random|round|sin|sqrt|tan"
	. "|E|LN2|LN10|LOG2E|LOG10E|PI|SQRT1_2|SQRT2)", "Math.$1")
    obj:=ComObjCreate("HTMLfile")
    obj.write("<body><script>document.body.innerText=eval('" exp "');</script>")
    return inStr(cabbage:=obj.body.innerText, "body") ? "?" : cabbage
}

string2array(string){
    array := []
    Loop % StrLen(string)
    {
        thisWord := SubStr(string, A_Index, 1)
        array.Push(thisWord)
    }
    return array
}

array2string(array, start, length){
    string := ""
    Loop, %length%
    {
        string .= array[start + A_Index - 1]
    }
    return string
}

isLang(char){
    if((char >= "a" AND char <= "z") OR (char >= "A" AND char <= "Z") OR (char >= "0" AND char <= "9"))
        return 1
    else
        return 0
}

isNotLang(char){
    return -isLang(char) + 1
}

isArrayLang(array, start, length){
    Loop, %length%
    {
        if(isLang(array[start + A_Index - 1]) = 0)
        {
            return 0
        }
    }
    return 1
}

isMatch(char, match){
    if(char = match)
        return 1
    else
        return 0
}

isArrayMatch(array, start, length, match){
    string := ""
    Loop, %length%
    {
        string .= array[start + A_Index - 1]
    }
    if(string = match)
        return 1
    else
        return 0
}

SubArray(array, start, length){
    subarray := []
    Loop, %length%
    {
        subarray.Push(array[start + A_Index - 1])
    }
    return subarray
}

SubArrayMax(array, start){
    return SubArray(array, start, array.MaxIndex() - start + 1)
}

keep(string, mode){
    global history, isLog
    static historyCount := 0

    if(mode)
    {
        historyCount++
        if(historyCount = 1)
            Menu, Tray, Enable, View History[0]
        historyCountFormer := historyCount - 1
        Menu, Tray, Rename, View History[%historyCountFormer%], View History[%historyCount%]
        history := history A_Hour ":" A_Min ":" A_Sec A_Tab string "`r`n"
    }
}

IniSectionParse(string, name, value){
    IniSectionKey := StrSplit(string, "`n")
    Loop, % IniSectionKey.MaxIndex()
    {
        IniSectionKeyNow := StrReplace(IniSectionKey[A_Index], "=", "嫕",, 1)
        StringSplit, IniSectionKeySplit, IniSectionKeyNow, 嫕
        name.Push(IniSectionKeySplit1)
        value.Push(IniSectionKeySplit2)
    }
}

IniKeyParse(string, value){
    IniSectionKeyValue := StrSplit(string, "`,")
    Loop, % IniSectionKeyValue.MaxIndex()
    {
        IniSectionKeyValueNow := IniSectionKeyValue[A_Index]
        value.Push(IniSectionKeyValueNow)
    }
}

IniKeyParseAssign(string, order){
    IniSectionKeyValue := StrSplit(string, "`,")
    return IniSectionKeyValue[order]
}

IniKeyParsePair(string, value1, value2){
    IniSectionKeyValue := StrSplit(string, "`,")
    Loop, % IniSectionKeyValue.MaxIndex()
    {
        IniSectionKeyValueNow := IniSectionKeyValue[A_Index]
        if(Mod(A_Index, 2) = 1)
            value1.Push(IniSectionKeyValueNow)
        else
            value2.Push(IniSectionKeyValueNow)
    }
}

en2jp(string){
    jp := ["し","ち","つ","きゃ","きゅ","きょ","しゃ","しゅ","しょ","ちゃ","ちゅ","ちょ","にゃ","にゅ","にょ","ひゃ","ひゅ","ひょ","みゃ","みゅ","みょ","りゃ","りゅ","りょ","ぎゃ","ぎゅ","ぎょ","びゃ","びゅ","びょ","ぴゃ","ぴゅ","ぴょ","シ","チ","ツ","キャ","キュ","キョ","シャ","シュ","ショ","チャ","チュ","チョ","ニャ","ニュ","ニョ","ヒャ","ヒュ","ヒョ","ミャ","ミュ","ミョ","リャ","リュ","リョ","ギャ","ギュ","ギョ","ビャ","ビュ","ビョ","ピャ","ピュ","ピョ","じゃ","じゅ","じょ","が","ぎ","ぐ","げ","ご","ざ","じ","ず","ぜ","ぞ","だ","じ","づ","で","ど","ば","び","ぶ","べ","ぼ","ぱ","ぴ","ぷ","ぺ","ぽ","か","き","く","け","こ","さ","す","せ","そ","た","て","と","な","に","ぬ","ね","の","は","ひ","ふ","へ","ほ","ま","み","む","め","も","や","ゆ","よ","ら","り","る","れ","ろ","わ","ゐ","ゑ","を","ん","ジャ","ジュ","ジョ","ガ","ギ","グ","ゲ","ゴ","ザ","ジ","ズ","ゼ","ゾ","ダ","ジ","ヅ","デ","ド","バ","ビ","ブ","ベ","ボ","パ","ピ","プ","ペ","ポ","カ","キ","ク","ケ","コ","サ","ス","セ","ソ","タ","テ","ト","ナ","ニ","ヌ","ネ","ノ","ハ","ヒ","フ","ヘ","ホ","マ","ミ","ム","メ","モ","ヤ","ユ","ヨ","ラ","リ","ル","レ","ロ","ワ","ヰ","ヱ","ヲ","ン","あ","い","う","え","お","ア","イ","ウ","エ","オ","ー"]
    eng := ["shi","chi","tsu","kya","kyu","kyo","sya","syu","syo","cya","cyu","cyo","nya","nyu","nyo","hya","hyu","hyo","mya","myu","myo","rya","ryu","ryo","gya","gyu","gyo","bya","byu","byo","pya","pyu","pyo","Shi","Chi","Tsu","Kya","Kyu","Kyo","Sya","Syu","Syo","Cya","Cyu","Cyo","Nya","Nyu","Nyo","Hya","Hyu","Hyo","Mya","Myu","Myo","Rya","Ryu","Ryo","Gya","Gyu","Gyo","Bya","Byu","Byo","Pya","Pyu","Pyo","jya","jyu","jyo","ga","gi","gu","ge","go","za","ji","zu","ze","zo","da","di","du","de","do","ba","bi","bu","be","bo","pa","pi","pu","pe","po","ka","ki","ku","ke","ko","sa","su","se","so","ta","te","to","na","ni","nu","ne","no","ha","hi","fu","he","ho","ma","mi","mu","me","mo","ya","yu","yo","ra","ri","ru","re","ro","wa","wi","wu","wo","n","Jya","Jyu","Jyo","Ga","Gi","Gu","Ge","Go","Za","Ji","Zu","Ze","Zo","Da","Di","Du","De","Do","Ba","Bi","Bu","Be","Bo","Pa","Pi","Pu","Pe","Po","Ka","Ki","Ku","Ke","Ko","Sa","Su","Se","So","Ta","Te","To","Na","Ni","Nu","Ne","No","Ha","Hi","Fu","He","Ho","Ma","Mi","Mu","Me","Mo","Ya","Yu","Yo","Ra","Ri","Ru","Re","Ro","Wa","Wi","Wu","Wo","N","a","i","u","e","o","A","I","U","E","O","-"]
    Loop % eng.Length()
    {
        StringCaseSense On
        StringReplace, string, string, % eng[A_Index], % jp[A_Index], All
        StringCaseSense Locale
    }
    return string
}

en2morse(string){
    morse := [".-", "-...", "-.-.", "-..", ".", "..-.", "--."
            , "....", "..", ".---", "-.-", ".-..", "--", "-."
            , "---", ".--.", "--.-", ".-.", "...", "-"
            , "..-", "...-", ".--", "-..-", "-.--", "--.."
            , ".----", "..---", "...--", "....-", "....."
            , "-....", "--...", "---..", "----.", "-----"
            , ".-.-.-", "---...", "--..--", "-.-.-."
            , "..--..", "-...-", ".----.", "-..-."
            , "-.-.--", "-....-", "..--.-", ".-..-."
            , "-.--.", "-.--.-", "...-..-", ".-..."
            , ".--.-.", ".-.-.", "/"]
    lang := ["a", "b", "c", "d", "e", "f", "g"
            , "h", "i", "j", "k", "l", "m", "n"
            , "o", "p", "q", "r", "s", "t"
            , "u", "v", "w", "x", "y", "z"
            , "1", "2", "3", "4", "5"
            , "6", "7", "8", "9", "0"
            , ".", "`:", "`,", "`;"
            , "?", "=", "'", "/"
            , "!", "-", "_", """"
            , "(", ")", "$", "&"
            , "@", "+", A_Space]
    stringReturn := ""
    stringPos := 0
    StringLeft, stringFirst, string, 1
    if(stringFirst = "." OR stringFirst = "-")
    {
        stringSplit := StrSplit(string, A_Space)
        Loop % stringSplit.Length()
        {
            stringNow := stringSplit[A_Index]
            Loop % morse.Length()
            {
                if(stringNow = morse[A_Index])
                    stringReturn := stringReturn . lang[A_Index]
            }
        }
    }
    else
    {
        Loop, % StrLen(string)
        {
            stringNow := SubStr(string, A_Index, 1)
            Loop % lang.Length()
            {
                if(stringNow = lang[A_Index])
                    stringReturn := stringReturn . morse[A_Index]
            }
            if(A_Index != StrLen(string))
                stringReturn := stringReturn . A_Space
        }
    }
    return stringReturn
}

MouseIsOver(WinTitle){
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

MousePos(mode, axis){
    if(mode = 1)
    {
        CoordMode, Mouse, Window
    }
    else if(mode = 2)
    {
        CoordMode, Mouse, Client
    }
    else
        CoordMode, Mouse, Screen
    MouseGetPos, xpos, ypos
    if(axis = 1)
    {
        return xpos
    }
    else if(axis = 2)
    {
        return ypos
    }
    else
        return
}

MouseOnEdge(WinTitle){
    WinGetPos, ProgX, ProgY, ProgWidth, ProgHeight, %WinTitle%
    MouseX := MousePos(0, 1)
    MouseY := MousePos(0, 2)
    if((MouseX <= ProgX + 10) AND (MouseX >= ProgX)) OR (MouseX <= ProgX + ProgWidth) AND (MouseX >= ProgX + ProgWidth - 10)
        rt += 1
    if((MouseY <= ProgY + 10) AND (MouseY >= ProgY)) OR (MouseY <= ProgY + ProgHeight) AND (MouseY >= ProgY + ProgHeight - 10)
        rt += 2
    return rt
}

Remap(key, code){
	if(key = "WheelUp")
		if(code = 1)
			Send {Volume_Up}
		else if(code = 2)
            Send #{Tab}
		else if(code = 3)
			Send ^+{Tab}
	if(key = "WheelDown")
		if(code = 1)
			Send {Volume_Down}
		else if(code = 2)
            Send #{d}
		else if(code = 3)
			Send ^{Tab}
	if(key = "WheelLeft")
		if(code = 1)
			Send {Media_Prev}
		else if(code = 2)
			Send ^#{Left}
	if(key = "WheelRight")
		if(code = 1)
			Send {Media_Next}
		else if(code = 2)
			Send ^#{Right}
    if(key = "MButton")
        if(code = 1)
            Send {Volume_Mute}
}

ExceptionCheck(){
    global ExceptionProg
    Loop % ExceptionProg.MaxIndex()
    {
        If(WinActive("ahk_exe " . ExceptionProg[A_Index]))
            return 1
    }
    return 0
}

ClipSniffMatch(array, match){
    if(array2string(array, 1, StrLen(match)) = match)
        return 1
    else
        return 0
}
ClipSniffMatchAndExtend(array, match, extend){
    back := ""
    if(isArrayMatch(array, 1, StrLen(match), match) AND isNotLang(array[StrLen(match) + extend + 1]))
        if(isArrayLang(array, 1 + StrLen(match), extend))
        {
            back .= match
            back .= array2string(array, StrLen(match) + 1, extend)
            return back
        }
    else
        return 0
}
ClipSniffLangAndExtend(array, extend){
    if(isArrayLang(array, 1, extend))
        return array2string(array, 1, extend)
    else
        return 0
}
ClipSniffLangAndExtendUntil(array){
    back := ""
    Loop % array.MaxIndex()
    {
        if(isLang(array[A_Index]))
            back .= array[A_Index]
        else
            break
    }
    return back
}
ClipSniff(string){
    global SniffContent
    back := 0
    array := string2array(string)

    Loop % SniffContent.MaxIndex()
    {
        SniffFind := []
        SniffPatt := []
        SniffFeed := []
        thisSniffContent := StrSplit(SniffContent[A_Index], ",")
        Loop, 2
            SniffFeed.Push(thisSniffContent[A_Index])
        Loop % thisSniffContent.MaxIndex() / 2 - 1
        {
            SniffFind.Push(thisSniffContent[2 * A_Index + 1])
            SniffPatt.Push(thisSniffContent[2 * A_Index + 2])
        }
        back := ClipSniffJudge(ClipSniffCore(array, SniffFind, SniffPatt), SniffFeed)
        if(back)
            break
    }
    return back
}
ClipSniffCore(array, caseFind, casePatt){ ;待优化
    MatchPattern := ""
    caseType := []
    Loop % casePatt.MaxIndex()
    {
        if(caseFind[A_Index] != "" AND !casePatt[A_Index])
            caseType.Push(1) ;M
        if(caseFind[A_Index] != "" AND casePatt[A_Index])
            caseType.Push(2) ;M&E
        if(caseFind[A_Index] = "" AND casePatt[A_Index])
            caseType.Push(3) ;L&E
        if(caseFind[A_Index] = "" AND !casePatt[A_Index])
            caseType.Push(4) ;L&EU
    }

    i := 1
    While(1 <= array.MaxIndex())
    {
        type := caseType[i]
        if(type = 1)
        {
            if(ClipSniffMatch(array, caseFind[i]))
            {
                array := SubArrayMax(array, StrLen(caseFind[i]))
                i++
                continue
            }
        }
        if(type = 2)
        {
            if(ClipSniffMatchAndExtend(array, caseFind[i], casePatt[i]))
            {
                MatchPattern .= "#" . ClipSniffMatchAndExtend(array, caseFind[i], casePatt[i])
                array := SubArrayMax(array, StrLen(caseFind[i]) + casePatt[i] + 1)
                i++
                continue
            }
        }
        if(type = 3)
        {
            if(ClipSniffLangAndExtend(array, casePatt[i]))
            {
                MatchPattern .= "#" . ClipSniffLangAndExtend(array, casePatt[i])
                array := SubArrayMax(array, casePatt[i])
                i++
                continue
            }
        }
        if(type = 4)
        {
            if(ClipSniffLangAndExtendUntil(array))
            {
                MatchPattern .= "#" . ClipSniffLangAndExtendUntil(array)
                array := SubArrayMax(array, StrLen(ClipSniffLangAndExtendUntil(array)) + 1)
                i++
                continue
            }
        }
        if(i > casePatt.MaxIndex())
            break
        array := SubArrayMax(array, 2)
    }
    return MatchPattern
}
ClipSniffJudge(pattern, feed){
    if(pattern = "")
        return 0
    else
    {
        SniffItem := StrSplit(pattern, "#")
        FeedTitle := feed[1]
        FeedContent := StrReplace(feed[2], "%s", "%s", FeedCount)
        Loop, %FeedCount%
        {
            FeedContent := StrReplace(FeedContent, "%s", SniffItem[A_Index + 1],, 1)
        }
        return FeedContent
    }
}

ToolTipTime(content, duration){
    ToolTip, %content%
    SetTimer, RemoveToolTip, Delete
    SetTimer, RemoveToolTip, %duration%
}

Furigana(sentence){
    global YahooJPAPI
    oHttp := ComObjCreate("WinHttp.Winhttprequest.5.1")
    oHttpString = https://jlp.yahooapis.jp/FuriganaService/V1/furigana?appid=%YahooJPAPI%&sentence=%sentence%
    oHttp.open("GET", oHttpString)
    try oHttp.send()
    try FuriganaRecv := SubStr(oHttp.responseText, 260, StrLen(oHttp.responseText) - 273)
    if(SubStr(FuriganaRecv, 1, 1) = "<")
    {
        x := new xml(FuriganaRecv)
        Loop
        {
            if((x.getChildren("/Result/WordList/Word[" . A_Index . "]", "element")).MaxIndex() != 1)
                rt .= x.getText("/Result/WordList/Word[" . A_Index . "]/Furigana")
            else
                rt .= x.getText("/Result/WordList/Word[" . A_Index . "]/Surface")
            if(SubStr(rt, StrLen(rt) - 4, StrLen(rt)) = ".furi")
                break
        }
        return rt
    }
}

YoudaoDict(word, sPhone, sExpln){
    global YoudaoAPIOrg, YoudaoAPI, ydRecvTrans
    wordEncoded := encode(word)
    oHttp := ComObjCreate("WinHttp.Winhttprequest.5.1")
    oHttpString = http://fanyi.youdao.com/openapi.do?keyfrom=%YoudaoAPIOrg%&key=%YoudaoAPI%&type=data&doctype=json&version=1.1&q=%wordEncoded%
    oHttp.open("GET", oHttpString)
    try oHttp.send()
    try ydRecv = % oHttp.responseText
    if(SubStr(ydRecv, 1, 1) = "{")
    {
        ydRecvParsed := JSON.Load(ydRecv)
        trans := Format("{}", ydRecvParsed.translation[1])
        if(trans = word)
            trans := ""
        ydRecvPhone := Format("{}", ydRecvParsed.basic.phonetic)
        if(ydRecvPhone)
            sPhone.Push(" (" . ydRecvPhone . ")")
        Loop % ydRecvParsed.basic.explains.MaxIndex()
            sExpln.push(ydRecvParsed.basic.explains[A_Index])
    }
    ydRecvTrans := trans
}

BingDict(word, sPhone, sExpln){
    wordEncoded := encode(word)
    oHttp := ComObjCreate("WinHttp.Winhttprequest.5.1")
    oHttpString = http://xtk.azurewebsites.net/BingDictService.aspx?Word=%wordEncoded%
    oHttp.open("GET", oHttpString)
    try oHttp.send()
    try bdtRecv = % oHttp.responseText
    if(SubStr(bdtRecv, 1, 1) = "{")
    {
        bdtRecvParsed := JSON.Load(bdtRecv)
        bdtRecvPhoneA := Format("{}", bdtRecvParsed.pronunciation.AmE)
        if(bdtRecvPhoneA)
            sPhone.Push(" (" . bdtRecvPhoneA . ")")
        bdtRecvPhoneB := Format("{}", bdtRecvParsed.pronunciation.BrE)
        if(bdtRecvPhoneB)
            sPhone.Push(" (" . bdtRecvPhoneB . ")")
        Loop % bdtRecvParsed.defs.MaxIndex()
        {
            thisdef := bdtRecvParsed.defs[A_Index].pos
            thisdef .= " "
            thisdef .= bdtRecvParsed.defs[A_Index].def
            sExpln.Push(thisdef)
        }
    }
}

ShowDictMenu(){
    global transSpec, selText
    SetTimer, RemoveToolTip, Delete
    SetTimer, RemoveToolTip, 10000
    Menu, Dict, Add, AvoidError, DictMenuHandler
    Menu, Dict, DeleteAll

    if(transSpec[3] = 1)
        transEngine := "有道词典"
    else if(transSpec[3] = 2)
        transEngine := "必应词典"
    else if(transSpec[3] = 3)
        transEngine := "Yahoo! 日本"
    else if(transSpec[3] = 4)
        transEngine := "摩尔斯电码转换"
    else if(transSpec[3] = 5)
        transEngine := "假名转换"
    else if(transSpec[1] = 1)
        transEngine := "有道翻译"
    else
        transEngine := "未找到结果"

    if(transEngine != "未找到结果")
        Menu, Dict, Add, 查询引擎 -> %transEngine%, DictMenuHandler
    else
    {
        Menu, Dict, Add, 未找到结果, DictMenuHandler
        Menu, Dict, Disable, 未找到结果
    }
    Menu, Dict, Add

    if(transSpec[2])
        Menu, Dict, Add, 复制音标, DictMenuHandler
    if(transSpec[3])
    {
        Menu, Dict, Add, 复制结果, DictMenuHandler
        Menu, Dict, Default, 复制结果
    }
    if(transSpec[1])
    {
        Menu, Dict, Add, 复制简明结果, DictMenuHandler
        Menu, Dict, Default, 复制简明结果
    }
    if(transSpec[1] OR transSpec[2] OR transSpec[3])
        Menu, Dict, Add

    if(transSpec[3] != 1)
        Menu, Dict, Add, 使用%A_Space%有道翻译%A_Space%查询(&Y), DictMenuHandler
    if(transSpec[3] != 2)
        Menu, Dict, Add, 使用%A_Space%必应翻译%A_Space%查询(&B), DictMenuHandler
    Menu, Dict, Add, 使用%A_Space%Google%A_Space%翻译%A_Space%查询(&G), DictMenuHandler
    Menu, Dict, Add, 振假名(&F), DictMenuHandler
    Menu, Dict, Add
    if(SubStr(selText, 1, 1) = "." OR SubStr(selText, 1, 1) = "-")
        Menu, Dict, Add, 转换为%A_Space%英文(&M), DictMenuHandler
    else
        Menu, Dict, Add, 转换为%A_Space%摩尔斯电码(&M), DictMenuHandler
    Menu, Dict, Add, 转换为%A_Space%假名(&J), DictMenuHandler
    Menu, Dict, Add
    Menu, Dict, Add, 取消(&C), DictMenuHandler
    Menu, Dict, Show
}

WeChatLogin(){
    CoordMode, Mouse, Window
    WinActivate, ahk_class WeChatLoginWndForPC
    ControlClick, x175 y350
}

getExplorerPath(){
    for window in ComObjCreate("Shell.Application").Windows
    try FullPath := window.Document.Folder.Self.Path
    return FullPath
}

getBrowserUrl(browser_class){
	WinGetClass, sClass, A
	if(sClass = browser_class)
		return GetBrowserURL_ACC(sClass)
}