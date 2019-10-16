!include nsDialogs.nsh

Name "Demo Installer"
InstallDir "c:\tmp\"

Outfile demoInstaller.exe
Requestexecutionlevel user

Page directory
Page Custom nsDialogsPageDemoVar nsDialogsPageDemoVarLeave
Page instfiles

Var /Global DemoVar
Var /Global DemoVarTextBox

;The Dialog to let user input variable value:
Function nsDialogsPageDemoVar
  nsDialogs::Create /NOUNLOAD 1018
  pop $0
  ${NSD_CreateLabel} 5% 20u 80% 12u "* Please input variable value:"
  Pop $0
  
  ${NSD_CreateText} 5% 40u 75% 12u "demoValue"
  Pop $DemoVarTextBox
  nsDialogs::Show

FunctionEnd

;To get what use input in the dialog, we have to put the code in a Function(not in the Section)
Function nsDialogsPageDemoVarLeave
  ${NSD_GetText} $DemoVarTextBox $DemoVar
FunctionEnd

Section
  SetOutPath $INSTDIR
  
  ;The SilentCMD.exe can run a bat file in a hidden way(without a command window shown).
  ;it comes from https://github.com/stbrenner/SilentCMD
  File "SilentCMD.exe"

  ;The batch file that can set variables into current login user's environment.
  File "setEnv.bat"

  ;Execute the setEnv.bat in a hidden way, save the DemoVar into user's enviroment variable. 
  StrCpy $1 "$INSTDIR\SilentCMD.exe $INSTDIR\setEnv.bat $DemoVar"
  ExecWait $1

SectionEnd
