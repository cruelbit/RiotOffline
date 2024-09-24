@echo off
color a

net session 1>nul 2>nul
if not %errorlevel%==0 (
  	echo Please run the script as administrator.
  	goto end
)

netsh advfirewall show allprofiles state | find /i "OFF">NUL
if %errorlevel%==0 (
	echo Please turn on the firewall and run the script again.
	goto end
)

netsh advfirewall firewall show rule name=RIOTOffline > NUL 2>&1
if %errorlevel%==1 (
        goto next
    ) else (
        goto offline
)

:next
tasklist /fi "ImageName eq RiotClientServices.exe" /fo csv 2>NUL | find /i "RiotClientServices.exe">NUL
if %errorlevel%==0 (
	echo Please turn off Riot Client and run the script again.
	goto end
)

echo Type "on" to appear Offline on Riot Client. 

set /p input=

if %input%==on (
	netsh advfirewall firewall add rule name=RIOTOffline protocol=TCP dir=out remoteport=5223 action=block
	cls
	echo You will appear Offline on Riot Client.
	echo To appear Online run the script again.
)

:end
timeout /t 10
exit

:offline
echo You are Offline in Riot Client
echo Type "off" to appear Online on Riot Client.

set /p input=

if %input%==off (
	netsh advfirewall firewall delete rule name=RIOTOffline
	cls
	echo You will appear Online on Riot Client.
	echo To appear Offline run the script again.
)

timeout /t 10