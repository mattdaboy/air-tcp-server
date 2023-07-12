@ECHO OFF
C:\AIR50.2.2.2\bin\adt.bat ^
-package ^
-storetype pkcs12 ^
-keystore ..\cert\Opendo_Self-signed_CodeSigning__exp_2024_07_11.p12 ^
-storepass opend0 ^
-tsa http://timestamp.digicert.com ^
-target bundle "bin\Opendo Part Standalone" app-windows.xml ^
-extdir lib ^
-C bin opendo-part.swf ^
-C bin assets ^
-C bin database ^
-C bin htdocs ^
-e bin\icons\Desktop\Desktop-16.png icons\Desktop\Desktop-16.png ^
-e bin\icons\Desktop\Desktop-32.png icons\Desktop\Desktop-32.png ^
-e bin\icons\Desktop\Desktop-36.png icons\Desktop\Desktop-36.png ^
-e bin\icons\Desktop\Desktop-48.png icons\Desktop\Desktop-48.png ^
-e bin\icons\Desktop\Desktop-72.png icons\Desktop\Desktop-72.png ^
-e bin\icons\Desktop\Desktop-114.png icons\Desktop\Desktop-114.png ^
-e bin\icons\Desktop\Desktop-128.png icons\Desktop\Desktop-128.png
EXIT