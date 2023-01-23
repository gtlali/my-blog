ECHO OFF
CLS
setlocal EnableDelayedExpansion 

REM Detect JVM Version
for /f tokens^=2-5^ delims^=.-_^" %%j in ('java -fullversion 2^>^&1') do set "jver=%%j%%k%%l%%m"

REM Detect JVM Runtime Architecture
java -version 2>&1 | find "64-Bit" >nul:
if errorlevel 1 (
    set jarch=32
) else (
    set jarch=64
)

Echo Java Version: %jver%
Echo JVM Runtime Architecture: %jarch% bit
Echo Java path: "%java_home%"

if %jver% LSS 18000 ( 
	Echo ERROR: Attempted to run software with Java Version %jver%. This software is only compatible with Java 8 Runtime enviroments. 
) else ( 
	Echo Java version %jver% is compatible with this software
	if "%tmp%"=="" ( 
		set temploc=C:/Temp
	) else ( 
		set temploc=%tmp%
	)
)
Echo Temp directory: %temploc%

if %jarch%==32 (
	set "Path=%temploc%\RTI_Native_Libs;%PATH%"
) else (
	set "Path=%temploc%\RTI_Native_Libs_64;%PATH%"
)

ECHO Starting DA

start cmd /k call java -jar DaExecutive.jar %*

Echo Starting HMI

REM java -jar HMIApp.jar local 8887 cm 1111 "SECTION" "MACHINE" 1111
start cmd /k  call java -jar HMIApp.jar local 8887 cm 1111 "South Section #11" "Miner 13" 1111
rem start cmd /k  call Java -jar HMIApp.jar local 8887 lws 1001313 "Northeast LW Panel #23" "Shearer 14" 1313

ECHO %cd% Starting DDS Simulator

start cmd /k call java -jar DdsSimGui.jar prop SimProps-cm.xml key Keys/MinerKeys/PN123456789-001.fbkz
rem start cmd /k call java -jar DdsSimGui.jar prop SimProps-cm.xml key  
rem start cmd /k call java -jar DdsSimGui.jar prop SimProps-lws.xml key miniPanel-FB200.fbkz 
