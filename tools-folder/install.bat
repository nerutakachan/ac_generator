@ECHO OFF
whoami /PRIV | FIND "SeLoadDriverPrivilege" > NUL
IF NOT ERRORLEVEL 1 GOTO INSTALL
ECHO 管理者権限で再起動します…
powershell -Command Start-Process """%~dp0install""" -Verb Runas
EXIT

:INSTALL
ECHO インストールしています…
RD /s /q "%ProgramFiles(x86)%\KunosSDK\extractor" > NUL 2>&1
XCOPY "%~dp0lib" "%ProgramFiles(x86)%\KunosSDK\" /E /R /Y /K /C

:DELETEOLD
REG DELETE "HKEY_CLASSES_ROOT\.kn5\shell\extract_obj" /f > NUL 2>&1
REG DELETE "HKEY_CLASSES_ROOT\acmanager.kn5\shell\preview" /f > NUL 2>&1

:ACMDEFCHECK
REG QUERY "HKEY_CLASSES_ROOT\acmanager.kn5\shell\open" > NUL 2>&1
IF ERRORLEVEL 1 GOTO ACMCHECK
ECHO ContentManagerがインストールされているため、拡張機能としてインストールを続行します…
FOR /F "TOKENS=1,2,*" %%A IN ('REG QUERY "HKEY_CLASSES_ROOT\acmanager.kn5\shell\open\command" /ve') DO SET ACMCMD=%%C
REG DELETE "HKEY_CLASSES_ROOT\acmanager.kn5\shell\open" /f
REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\open" /ve /t REG_SZ /d "プレビュー(&P)" /f
REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\open" /v "Icon" /t REG_SZ /d "%ProgramFiles(x86)%\KunosSDK\kunossdk.exe,0" /f
REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\open\command" /ve /t REG_SZ /d "%ACMCMD:"=\"%" /f

:ACMCHECK
REG QUERY "HKEY_CLASSES_ROOT\acmanager.kn5" > NUL 2>&1
IF ERRORLEVEL 1 GOTO REGKN5DEF
REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\extract_fbx" /ve /t REG_SZ /d "FBXに展開(&E)" /f
REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\extract_fbx" /v "Icon" /t REG_SZ /d "%ProgramFiles(x86)%\KunosSDK\kunossdk.exe,0" /f
REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\extract_fbx\command" /ve /t REG_SZ /d "\"%ProgramFiles(x86)%\KunosSDK\kunossdk.exe\" \"%%1\" " /f

REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\protect_kn5" /ve /t REG_SZ /d "KN5をプロテクト(&P)" /f
REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\protect_kn5" /v "Icon" /t REG_SZ /d "%ProgramFiles(x86)%\KunosSDK\kunossdk.exe,0" /f
REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\protect_kn5\command" /ve /t REG_SZ /d "\"%ProgramFiles(x86)%\KunosSDK\kunossdk.exe\" \"%%1\" --protect" /f

REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\bakeryoptix_kn5" /ve /t REG_SZ /d "VAOデータを生成(&V)" /f
REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\bakeryoptix_kn5" /v "Icon" /t REG_SZ /d "%ProgramFiles(x86)%\KunosSDK\kunossdk.exe,0" /f
REG ADD "HKEY_CLASSES_ROOT\acmanager.kn5\shell\bakeryoptix_kn5\command" /ve /t REG_SZ /d "\"%ProgramFiles(x86)%\KunosSDK\bakeryoptix.exe\" \"%%1\" " /f
GOTO REGACD

:REGKN5DEF
REG ADD "HKEY_CLASSES_ROOT\.kn5" /ve /t REG_SZ /d "Assetto Corsa 3D File" /f
REG ADD "HKEY_CLASSES_ROOT\.kn5\shell" /f
REG ADD "HKEY_CLASSES_ROOT\.kn5\shell\extract_fbx" /ve /t REG_SZ /d "FBXに展開(&E)" /f
REG ADD "HKEY_CLASSES_ROOT\.kn5\shell\extract_fbx" /v "Icon" /t REG_SZ /d "%ProgramFiles(x86)%\KunosSDK\kunossdk.exe,0" /f
REG ADD "HKEY_CLASSES_ROOT\.kn5\shell\extract_fbx\command" /ve /t REG_SZ /d "\"%ProgramFiles(x86)%\KunosSDK\kunossdk.exe\" \"%%1\" " /f

REG ADD "HKEY_CLASSES_ROOT\.kn5\shell\protect_kn5" /ve /t REG_SZ /d "KN5をプロテクト(&P)" /f
REG ADD "HKEY_CLASSES_ROOT\.kn5\shell\protect_kn5" /v "Icon" /t REG_SZ /d "%ProgramFiles(x86)%\KunosSDK\kunossdk.exe,0" /f
REG ADD "HKEY_CLASSES_ROOT\.kn5\shell\protect_kn5\command" /ve /t REG_SZ /d "\"%ProgramFiles(x86)%\KunosSDK\kunossdk.exe\" \"%%1\" --protect" /f

REG ADD "HKEY_CLASSES_ROOT\.kn5\shell\bakeryoptix_kn5" /ve /t REG_SZ /d "VAOデータを生成(&V)" /f
REG ADD "HKEY_CLASSES_ROOT\.kn5\shell\bakeryoptix_kn5" /v "Icon" /t REG_SZ /d "%ProgramFiles(x86)%\KunosSDK\kunossdk.exe,0" /f
REG ADD "HKEY_CLASSES_ROOT\.kn5\shell\bakeryoptix_kn5\command" /ve /t REG_SZ /d "\"%ProgramFiles(x86)%\KunosSDK\bakeryoptix.exe\" \"%%1\" " /f

:REGACD
REG ADD "HKEY_CLASSES_ROOT\.acd" /ve /t REG_SZ /d "Assetto Corsa Database file" /f
REG ADD "HKEY_CLASSES_ROOT\.acd\shell" /f
REG ADD "HKEY_CLASSES_ROOT\.acd\shell\extract" /ve /t REG_SZ /d "展開(&E)" /f
REG ADD "HKEY_CLASSES_ROOT\.acd\shell\extract" /v "Icon" /t REG_SZ /d "%ProgramFiles(x86)%\KunosSDK\kunossdk.exe,0" /f
REG ADD "HKEY_CLASSES_ROOT\.acd\shell\extract\command" /ve /t REG_SZ /d "\"%ProgramFiles(x86)%\KunosSDK\kunossdk.exe\" \"%%1\" " /f

REG ADD "HKEY_CLASSES_ROOT\Directory\shell\KunosSDK.CompileACD" /ve /t REG_SZ /d "KsACDにコンパイル(&A)" /f
REG ADD "HKEY_CLASSES_ROOT\Directory\shell\KunosSDK.CompileACD" /v "Icon" /t REG_SZ /d "%ProgramFiles(x86)%\KunosSDK\kunossdk.exe,0" /f
REG ADD "HKEY_CLASSES_ROOT\Directory\shell\KunosSDK.CompileACD\command" /ve /t REG_SZ /d "\"%ProgramFiles(x86)%\KunosSDK\kunossdk.exe\" \"%%1\" " /f

:REGBANK
REG ADD "HKEY_CLASSES_ROOT\.bank" /ve /t REG_SZ /d "Assetto Corsa Sound file" /f
REG ADD "HKEY_CLASSES_ROOT\.bank\shell" /f
REG ADD "HKEY_CLASSES_ROOT\.bank\shell\extract" /ve /t REG_SZ /d "展開(&E)" /f
REG ADD "HKEY_CLASSES_ROOT\.bank\shell\extract" /v "Icon" /t REG_SZ /d "%ProgramFiles(x86)%\KunosSDK\kunossdk.exe,0" /f
REG ADD "HKEY_CLASSES_ROOT\.bank\shell\extract\command" /ve /t REG_SZ /d "\"%ProgramFiles(x86)%\KunosSDK\kunossdk.exe\" \"%%1\" " /f

echo msgbox "インストールが完了しました",vbOKOnly,"KunosSDK SETUP" > %TEMP%/kunossdk.vbs & %TEMP%/kunossdk.vbs