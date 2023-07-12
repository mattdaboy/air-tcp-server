@ECHO OFF
echo.
echo Clean windows signed exe folder
echo.
cd "bin\windows signed exe\"
rmdir /s /q "Opendo Anim Standalone"
del /s /q *.exe
del /s /q *.zip
EXIT