@ECHO OFF
echo.
echo Make sfx Opendo-Anim-Standalone.exe
echo.
cd "bin\windows signed exe\"
WinRAR a -AI -sfx -iicon..\..\scripts\AnimAppIcon.ico -iimg..\..\scripts\Opendo_WinRAR-SFX-logo.png -z..\..\scripts\WinRAR-script.txt "Opendo-Anim-Standalone.exe" "Opendo Anim Standalone"
EXIT