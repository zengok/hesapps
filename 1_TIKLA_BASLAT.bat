@echo off
color 0B
echo ==========================================================
echo HESAPPS - MOBIL ODAKLI STANDART BASLATICISI
echo ==========================================================
echo.
echo Lutfen bekleyin, cross-platform (Web/Device) baslatiliyor...
echo.

set PATH=%PATH%;%USERPROFILE%\Downloads\flutter_windows_3.41.5-stable\flutter\bin
flutter run -d chrome

echo.
echo Islem sonlandirildi.
pause
