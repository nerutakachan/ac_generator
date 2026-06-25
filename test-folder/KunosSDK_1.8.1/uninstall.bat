@ECHO OFF
whoami /PRIV | FIND "SeLoadDriverPrivilege" > NUL
IF not errorlevel 1 GOTO UNINSTALL
powershell -Command Start-Process """%~dp0uninstall""" -Verb Runas
EXIT

:UNINSTALL
RD /s /q "%ProgramFiles(x86)%\KunosSDK"

REG QUERY "HKEY_CLASSES_ROOT\acmanager.kn5\shell\open" > NUL 2>&1
IF ERRORLEVEL 1 GOTO DELDEF
FOR /F "TOKENS=1,2,*" %%A IN ('REG QUERY "HKEY_CLASSES_ROOT\acmanager.kn5\shell\open\command" /ve') DO SET ACMCMD=%%C
REG DELETE "HKEY_CLASSES_ROOT\acmanager.kn5\shell\extract_fbx" /f
REG DELETE "HKEY_CLASSES_ROOT\acmanager.kn5\shell\protect_kn5" /f
REG DELETE "HKEY_CLASSES_ROOT\acmanager.kn5\shell\bakeryoptix_kn5" /f
REG DELETE "HKEY_CLASSES_ROOT\acmanager.kn5\shell\open" /f
REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\open" /f
REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\open\command" /ve /t REG_SZ /d "%ACMCMD:"=\"%" /f

:DELDEF
REG DELETE "HKEY_CLASSES_ROOT\.kn5\shell\extract_fbx" /f
REG DELETE "HKEY_CLASSES_ROOT\.kn5\shell\protect_kn5" /f
REG DELETE "HKEY_CLASSES_ROOT\.kn5\shell\bakeryoptix_kn5" /f
REG DELETE "HKEY_CLASSES_ROOT\.bank\shell\extract" /f
REG DELETE "HKEY_CLASSES_ROOT\.acd\shell\extract" /f
REG DELETE "HKEY_CLASSES_ROOT\Directory\shell\KunosSDK.CompileACD" /f

echo msgbox "アンインストールが完了しました",vbOKOnly,"KunosSDK SETUP" > %TEMP%/kunossdk.vbs & %TEMP%/kunossdk.vbs