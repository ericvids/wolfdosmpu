@ECHO OFF
SET _ALLFAILED=0
IF NOT "%1"=="" GOTO :SINGLE
CALL _ALL.BAT V
IF "%_ALLFAILED%"=="1" GOTO :END
CALL _ALL.BAT M
IF "%_ALLFAILED%"=="1" GOTO :END
CALL _ALL.BAT W
IF "%_ALLFAILED%"=="1" GOTO :END
GOTO :END

:SINGLE
CALL _WC.BAT %1 %2 %3
BC /B
IF NOT EXIST OBJ\WOLF3D.EXE GOTO :ERROR
CALL _WR.BAT %1 %2 %3
BC /B
IF NOT EXIST OBJ\WOLF3D.EXE GOTO :ERROR
CALL _WS.BAT %1 %2 %3
BC /B
IF NOT EXIST OBJ\WOLF3D.EXE GOTO :ERROR
CALL _SC.BAT %1 %2 %3
BC /B
IF NOT EXIST OBJ\WOLF3D.EXE GOTO :ERROR
CALL _SD.BAT %1 %2 %3
BC /B
IF NOT EXIST OBJ\WOLF3D.EXE GOTO :ERROR
CALL _WC.BAT _
ECHO All executables have been built.
GOTO :END

:ERROR
SET _ALLFAILED=1

:END
