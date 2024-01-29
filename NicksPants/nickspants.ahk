

gosub Setup

; Create File Menu at the top (Submenu must be created first)
Menu, SubMenu, Add, Save as Default, SaveHandler
;Menu, SubMenu, Add, Settings, SettingsHandler
Menu, SubMenu, Add, About, AboutHandler
Menu, FileMenu, Add, File, :Submenu

; GUI Inputs for rest of interface
Gui, Add, Text,, Key to Press:
Gui, Add, Text,, Seconds between Presses:
Gui, Add, Text,, How long to run? (min, 0 = inf)

Gui, Add, Edit, vkeypress ym w55, %keypressvalue%  ;The ym option starts a new column of controls.
Gui, Add, Edit, Number vtimesecs w55, %timesecsvalue%
Gui, Add, Edit, Number vruntime w55, %runtimevalue%

Gui, Add, Button,, RUN  ; The label ButtonGO will run when the button is pressed.
Gui, Add, Button, x+m, STOP 

Gui, Menu, FileMenu
Gui, Show,, Nick's Pants ; Initialize GUI

return  ; End of auto-execute section. The script is idle until the user does something.



ButtonRUN:
Gui, Submit, NoHide ; Save the input from the user to each control's associated variable.
Sleep, 3000 ; Wait 3 seconds before starting the button presses - so you have time to open your application

minsToSecs := runtime * 60
timesToRun := minsToSecs/timesecs

 if (runtime == 0 || runtime == "") {
	Loop
	{
		Send, %keypress%
		Sleep, (timesecs * 1000)
	}
 } else {
	Loop, %timesToRun%
	{	
		Send, %keypress%
		Sleep, (timesecs * 1000)
	}
 }
 return
 
 
; Reloads the application/stops the script 
ButtonSTOP:
Reload
return


; Saves input values as default to config.ini
SaveHandler:
Gui, Submit, NoHide 
IniWrite, % keypress, assets/config.ini, DefaultValues, key1
IniWrite, % timesecs, assets/config.ini, DefaultValues, key2
IniWrite, % runtime, assets/config.ini, DefaultValues, key3
return


; Generates the UI for the About submenu item
AboutHandler:
Gui, About: New,,About
Gui, About: Add,Text,,For Nick Frisco`nCreated by Meghan Frisco`nFebruary 2022`nI love you :) <3
Gui, About: Add,Picture,h400 w250, assets/icon.png
Gui, About: Show 
return

SettingsHandler:
;Adjust other settings
Gui, Settings: New,,Settings
Gui, Settings: Add,Text,,assets/config.ini path:
Gui, Add, Edit, vconfigpath ym w55, %configpath%  
;Gui, Settings: Show 
return


; Setup Subroutine to retrieve default values/settings and icon
Setup:
I_Icon = icon.png
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%

; Retrieve Default Values
if FileExist("assets/config.ini"){
	IniRead, keypressvalue, assets/config.ini, DefaultValues, key1
	IniRead, timesecsvalue, assets/config.ini, DefaultValues, key2
	IniRead, runtimevalue, assets/config.ini, DefaultValues, key3
;	IniRead, configpath, assets/config.ini, Config, key4
} else {
	FileAppend, [DefaultValues]`n, assets/config.ini
	FileAppend, key1=5`n, assets/config.ini
	FileAppend, key2=11`n, assets/config.ini
	FileAppend, key3=0`n, assets/config.ini
	msgbox, Reload App
	ExitApp
}
return

GuiClose:
    ExitApp
return


