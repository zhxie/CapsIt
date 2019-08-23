# CapsIt

Shortcut toolbox using Caps Lock.

**This is an early work that contains stale code and is not recommended for reading or use.**

**This work has been discontinued.**

## Configuration

Please refer to the following example to create a configuration file `config.ini` in the directory.

```ini
[Program]
; Version of program and configuration
Version=0.2.107
[AddOn]
; Block pop-up ad of QQ
KillQQPop=1
; Switch function key with F-key when Ctrl, Alt or Shift pressed
Fn=1
; Switch wheel button left and right with XButton1 and XButton2
SwitchWheelButton=0
; Close notepad with Ctrl+W
NotepadClose=1
; Automatically press log in when wechat.exe starts
WeChatEnter=1
; Drag window with Win pressed
WindowDrag=1
; Press wheel and incline to left or right to switch desktop
InclineSwitch=0
; Press wheel left or right to switch desktop when mouse is at the edge
WheelOnEdge=0
[Capslock]
; Execute action like calculation
Action=1
; A secondary clipboard with Caps Lock
Clipboard=1
; Sniff
Sniff=1
; Define
Define=1
; Inspect program details
Inspector=1
[API]
; Youdao API
Youdao=[org],[key]
; Yahoo JP API
YahooJP=[key]
[Sniff]
Tmall=天猫,https://detail.tmall.com/item.htm?id=%s,detail,0,tmall,0,?,0,id=,0,,0
Taobao=淘宝,https://item.taobao.com/item.htm?id=%s,item,0,taobao,0,?,0,id=,0,,0
JD=京东,https://item.jd.com/%s.html,item,0,jd,0,/,0,,0
Weibo=微博,https://weibo.com/%s/%s,weibo,0,/,0,,0,,0
BaiduNetDisk=百度网盘,https://pan.baidu.com/s/%s,1,7
bilibili=哔哩哔哩,https://www.bilibili.com/video/a%s,av,0,,0
[Alter]
; Replace phrase
~=～
@gmail=@gmail.com
“=「
”=」
[Exception]
; Disable CapsIt in applications below
Photoshop.exe
```