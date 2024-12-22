@echo off
:pauseIfDoubleClicked
setlocal enabledelayedexpansion
:restart
set testl=%cmdcmdline:"=%
set testr=!testl:%~nx0=!

set "destinationDirectory=D:\CORE - TYPE R\collections\"
:: Get the directory where the script is located
set "sourceDirectory=%~dp0"

echo The script is located in the directory: %sourceDirectory%
echo Source directory: %sourceDirectory%
echo Target directory: %destinationDirectory%

:: Check if script is already running with elevated privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if %errorlevel% neq 0 (
    echo Run As Administrator
    pause
    exit /b 1
)

set "mode=S"
set /P "mode=~ All Folders(A) or Single Folder(S) [S]: "

if %mode% == S (
   set "mode=S"
) else (
    if %mode% == A (
        set "mode=A"
    ) else (
        echo Select A or S
        pause
        exit /b 1
    )
)

:: The rest of the script continues here
setlocal enabledelayedexpansion
set "linkType=D"
set /P "linkType=~ Simlink(D) or Junction(J) [D]: "

if %linkType% == D (
   set "linkType=Simlink"
) else (
    if %linkType% == J (
        set "linkType=Junction"
    ) else (
        echo Select D or J
        pause
        exit /b 1
    )
)

@REM set /p "sourceDirectory=~ Source directory: "
@REM set /p "destinationDirectory=~ Destination directory: "

:: Change to script's running DIR
cd /d "%sourceDirectory%"
echo Now in the script directory: %cd%

if %mode% == A (
    for /D %%d in ("%sourceDirectory%\*") do (

        call :CreateLink "%%~nxd" A
        set "p="
        @REM exit /b 1
    )

) else (
    call :CreateLink simple S
)



:CreateLink
    if %2 == S (
        set /p "folder=~ Folder: "
        set "folder=!folder:"=!"
        set "destinationDirectoryFinal=!destinationDirectory!!folder!"
        set "sourceDirectoryFinal=!sourceDirectory!!folder!"
    )else (
        set p=%~1
        @REM set "p=%p:"=%"
        echo StrippedParaM: !p!
        set "destinationDirectoryFinal=!destinationDirectory!!p!"
        set "sourceDirectoryFinal=!sourceDirectory!!p!"
    )


    echo ##### ##### ####
    echo ~ Link using [ !linkType! ] Source Directory: [ !sourceDirectoryFinal! ]
    echo ~ with Destination Directory: [ !destinationDirectoryFinal! ]

    set "confirm=Y"
    @REM set /P confirm="Is that correct? [Y/n]: "

    if not %confirm% == Y (    
        echo Make sure you make the right choice
        pause
        exit /b 1
    ) else (
        echo ~# Cool
    )
    

    if %linkType% == Simlink (
        :: Create a Soft link
        mklink /D "!destinationDirectoryFinal!" "!sourceDirectoryFinal!"

    ) else (
        if %linkType% == Junction (
            :: Create a Junction
            mklink /J "!destinationDirectoryFinal!" "!sourceDirectoryFinal!"
        ) else (
            echo Make sure you make the right choice
            pause
            exit /b 1
        )
    )

    :: Check for errors
    if not errorlevel 1 (  
        echo.
    ) else (
        echo Error creating [!linkType!]. Check the paths and ensure you have administrative privileges.
        exit /b 1
    )
    goto :eof

set "restart=Y"
set /P restart="Restart? [Y/n]: "

if not %restart% == Y (    
    echo Bye...
    pause
    exit /b 0
) else (
    echo ~# Ok
    echo.
)

goto restart

pause
exit /b 0