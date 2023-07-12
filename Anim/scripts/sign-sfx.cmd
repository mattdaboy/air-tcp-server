@ECHO OFF
echo.
echo Make sfx Opendo-Anim-Standalone.exe
echo.
call "..\Windows_sign_extended\signtool.exe" sign /f "..\cert\Opendo_CodeSigning_ExtendValidation__exp_2024_05_07.cer" /p opend000 /tr "http://timestamp.digicert.com/?signature=sha2" /td SHA256 "bin\windows signed exe\Opendo-Anim-Standalone.exe"
EXIT