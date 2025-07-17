@echo off
:: ----------------------------------------------------------------
:: Script de Optimización y Limpieza para Windows 11 v1.1
:: (Opción 9 cambiada a Limpieza de Almacén de Componentes)
:: ----------------------------------------------------------------
title Optimizador Windows 11 v1.1 by ReptOS
:: --- Comprobar permisos de Administrador ---
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Permisos de Administrador OK. Iniciando script...
    timeout /t 2 /nobreak > nul
) else (
    echo ============================================================
    echo  ERROR: Se requieren permisos de Administrador.
    echo ============================================================
    echo.
    echo Por favor, haz clic derecho sobre este script y selecciona
    echo "Ejecutar como administrador".
    echo.
    pause
    exit /b
)

:MainMenu
cls
echo ============================================================
echo         OPTIMIZADOR Y LIMPIADOR PARA WINDOWS 11 (v1.1)
echo ============================================================
echo.
echo   Selecciona una opcion:
echo.
echo   [1] Limpiar Archivos Temporales (Usuario y Sistema)
echo   [2] Limpiar Cache de Windows Update
echo   [3] Limpiar Archivos Prefetch
echo   [4] Liberador de Espacio en Disco (Herramienta Windows)
echo   [5] Comprobar y Reparar Archivos del Sistema (SFC)
echo   [6] Comprobar y Reparar Imagen de Windows (DISM - Health)
echo   [7] Optimizar Unidades (Defragmentar HDD / TRIM SSD)
echo   [8] Limpiar Cache DNS
echo   [9] Limpiar Almacen de Componentes (WinSxS - DISM Cleanup)
echo   [0] Salir
echo.
echo ============================================================
set /p choice="Introduce el numero de tu opcion y pulsa Enter: "

if "%choice%"=="1" goto CleanTemp
if "%choice%"=="2" goto CleanUpdateCache
if "%choice%"=="3" goto CleanPrefetch
if "%choice%"=="4" goto DiskCleanupTool
if "%choice%"=="5" goto RunSFC
if "%choice%"=="6" goto RunDISM
if "%choice%"=="7" goto OptimizeDrives
if "%choice%"=="8" goto FlushDNS
if "%choice%"=="9" goto CleanComponentStore  :: <-- Opción 9 cambiada
if "%choice%"=="0" goto ExitScript

echo Opcion no valida. Intentalo de nuevo.
timeout /t 2 /nobreak > nul
goto MainMenu

:: --- Secciones de Acciones ---

:CleanTemp
cls
echo ============================================================
echo   [1] Limpiando Archivos Temporales...
echo ============================================================
echo Cerrando aplicaciones que puedan usar archivos temporales... (Recomendado cerrar manualmente antes)
echo.
echo Limpiando carpeta temporal del Usuario (%temp%)...
del /q /f /s "%temp%\*.*" 2>nul
echo.
echo Limpiando carpeta temporal del Sistema (C:\Windows\Temp)...
del /q /f /s "C:\Windows\Temp\*.*" 2>nul
echo.
echo Limpieza de temporales completada. Algunos archivos podrian
echo no haberse eliminado si estan en uso.
echo.
pause
goto MainMenu

:CleanUpdateCache
cls
echo ============================================================
echo   [2] Limpiando Cache de Windows Update...
echo ============================================================
echo Deteniendo servicio de Windows Update...
net stop wuauserv
echo.
echo Eliminando archivos de cache (SoftwareDistribution\Download)...
rd /s /q "C:\Windows\SoftwareDistribution\Download" 2>nul
echo.
echo Reiniciando servicio de Windows Update...
net start wuauserv
echo.
echo Limpieza de cache de Windows Update completada.
echo Nota: Esto puede hacer que la proxima busqueda de actualizaciones tarde mas.
echo.
pause
goto MainMenu

:CleanPrefetch
cls
echo ============================================================
echo   [3] Limpiando Archivos Prefetch...
echo ============================================================
echo Los archivos Prefetch ayudan a acelerar el inicio de aplicaciones.
echo Limpiarlos puede liberar espacio, pero puede ralentizar
echo temporalmente el primer inicio de algunas aplicaciones.
echo.
echo Eliminando archivos de C:\Windows\Prefetch...
del /q /f /s "C:\Windows\Prefetch\*.*" 2>nul
echo.
echo Limpieza de Prefetch completada.
echo.
pause
goto MainMenu

:DiskCleanupTool
cls
echo ============================================================
echo   [4] Abriendo Liberador de Espacio en Disco...
echo ============================================================
echo Se abrira la herramienta integrada de Windows.
echo Sigue las instrucciones en pantalla para seleccionar
echo que elementos deseas limpiar.
echo.
start cleanmgr.exe
echo.
echo Esperando a que la herramienta se inicie...
timeout /t 5 /nobreak > nul
echo.
pause
goto MainMenu

:RunSFC
cls
echo ============================================================
echo   [5] Comprobando Archivos del Sistema (SFC)...
echo ============================================================
echo Esto buscara archivos de sistema corruptos o faltantes
echo y los intentara reparar. Puede tardar varios minutos.
echo.
sfc /scannow
echo.
echo Comprobacion SFC completada. Revisa los mensajes anteriores.
echo.
pause
goto MainMenu

:RunDISM
cls
echo ============================================================
echo   [6] Comprobando y Reparando Imagen de Windows (DISM)...
echo ============================================================
echo DISM puede reparar problemas con la imagen de Windows
echo que SFC no puede solucionar. Esto puede tardar bastante
echo y requiere conexion a internet si necesita descargar archivos.
echo.
echo Ejecutando DISM /Online /Cleanup-Image /ScanHealth...
DISM /Online /Cleanup-Image /ScanHealth
echo.
echo Ejecutando DISM /Online /Cleanup-Image /RestoreHealth...
DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo Comprobacion y reparacion DISM completada. Revisa los mensajes.
echo.
pause
goto MainMenu

:OptimizeDrives
cls
echo ============================================================
echo   [7] Optimizando Unidades (Defragmentar/TRIM)...
echo ============================================================
echo Windows 11 optimiza las unidades automaticamente.
echo Esta opcion ejecuta la optimizacion manualmente para la unidad C:.
echo En SSDs, realiza TRIM. En HDDs, desfragmenta.
echo.
echo Optimizando unidad C:...
defrag C: /O
echo.
echo Optimizacion de la unidad C: completada.
echo Puedes usar la herramienta "Desfragmentar y optimizar unidades"
echo de Windows para otras unidades si es necesario.
echo.
pause
goto MainMenu

:FlushDNS
cls
echo ============================================================
echo   [8] Limpiando Cache DNS...
echo ============================================================
echo Esto elimina la cache local de resolucion de nombres DNS.
echo Puede solucionar algunos problemas de conexion a sitios web.
echo.
ipconfig /flushdns
echo.
echo Cache DNS limpiada correctamente.
echo.
pause
goto MainMenu

:CleanComponentStore  :: <-- Nueva sección para la Opción 9
cls
echo ============================================================
echo   [9] Limpiando Almacen de Componentes (WinSxS)...
echo ============================================================
echo Esta operacion elimina versiones antiguas y reemplazadas
echo de componentes del sistema almacenadas en la carpeta WinSxS.
echo Puede liberar una cantidad significativa de espacio en disco.
echo.
echo El proceso puede tardar varios minutos...
echo.
echo Ejecutando DISM /Online /Cleanup-Image /StartComponentCleanup...
DISM.exe /Online /Cleanup-Image /StartComponentCleanup
echo.
echo Limpieza del Almacen de Componentes completada.
echo.
pause
goto MainMenu

:ExitScript
cls
echo ============================================================
echo            Saliendo del Optimizador...
echo ============================================================
echo ¡Gracias por usar el script!
timeout /t 3 /nobreak > nul
exit /b
