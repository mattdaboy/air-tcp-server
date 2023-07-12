@ECHO OFF
echo.
echo Make sfx Opendo-Part-Standalone.exe
echo.
cd "bin\windows signed exe\"
WinRAR a -AI -sfx -iicon..\..\scripts\PartAppIcon.ico -iimg..\..\scripts\Opendo_WinRAR-SFX-logo.png -z..\..\scripts\WinRAR-script.txt "Opendo-Part-Standalone.exe" "Opendo Part Standalone"
EXIT