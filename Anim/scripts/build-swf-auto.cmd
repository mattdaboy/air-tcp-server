@ECHO OFF
echo.
echo Building opendo-anim-auto-update.swf
echo.
C:\AIR50.2.2.2\bin\mxmlc.bat ^
src\AutoUpdate.as ^
-debug=false ^
-target-player=50.0 ^
-output=bin\opendo-anim-auto-update.swf ^
+flexlib=C:\AIR50.2.2.2\frameworks ^
+configname=air ^
-source-path+=src ^
-library-path+=lib\as3corelib.swc ^
-library-path+=lib\blooddy_crypto.swc ^
-library-path+=lib\greensock.swc ^
-library-path+=C:\AIR50.2.2.2\frameworks\libs\air\airglobal.swc ^
-library-path+=C:\AIR50.2.2.2\frameworks\libs\core.swc ^
-library-path+=C:\AIR50.2.2.2\frameworks\libs\air\aircore.swc ^
-library-path+=C:\AIR50.2.2.2\frameworks\libs\air\applicationupdater.swc ^
-library-path+=C:\AIR50.2.2.2\frameworks\libs\air\applicationupdater_ui.swc ^
-library-path+=C:\AIR50.2.2.2\frameworks\libs\air\servicemonitor.swc ^
-static-link-runtime-shared-libraries=true ^
-library-path+=C:\AIR50.2.2.2\frameworks\locale\en_US ^
-default-size=1920,1200 ^
-creator=Matt
EXIT