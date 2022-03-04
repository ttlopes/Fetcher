@echo off

echo Nome Atual do Computador: %computername%
set /p bool="Deseja Alterar (S/N):  "

IF /I "%bool%"=="s" (
	start sysdm.cpl
    echo Reinicie o Computador para Alterar o nome
    pause >nul
    exit
)

set /p letra="Selecione a Letra da Pen: "

set /p id="Selecione o Piso: "

IF /I "%id%" LEQ "16" goto INICIO

:RETURN

echo.
echo Piso Inexistente 
set /p id="Escolha um Piso entre 1 e 16: "
IF /I "%id%" LEQ "16" goto INICIO

goto RETURN

:INICIO

echo ...Aguarde

REM Definir Variáveis
set serialnumber=
set osname=
set MemRAM=
set availableMem=
set processor=
set IPv4=

REM Numero de Serie
FOR /F "tokens=2 delims='='" %%A in ('wmic Bios Get SerialNumber /value') do SET serialnumber=%%A

REM Sistema Operativo
FOR /F "tokens=2 delims='='" %%A in ('wmic os get Name /value') do SET osname=%%A
FOR /F "tokens=1 delims='|'" %%A in ("%osname%") do SET osname=%%A

REM Memoria RAM
FOR /F "tokens=4" %%a in ('systeminfo ^| findstr Physical') do if defined MemRAM (set availableMem=%%a) else (set MemRAM=%%a)

REM Processador
FOR /F "tokens=2 delims='='" %%A in ('wmic cpu get name /value') do SET processor=%%A

REM Endereço IPv4
FOR /F "tokens=* delims='='" %%A in ('ipconfig ^| findstr /R /C:"IPv4* Address"') do SET IPv4=%%A

set "IPv4=%IPv4:*:=%"
set IPv4=%IPv4: =% 
set MemRAM=%MemRAM:~0,1%
set MemRAM=%MemRAM: =%


IF "%serialnumber%"=="System Serial Number" (
	set serialnumber=Data Not Available
)

echo Concluido!

REM Gerar Mensagem
echo --------------------------------------------
echo Nome Computador: %computername%
echo Numero de Serie: %serialnumber%
echo Sistema Operativo: %osname%
echo Memoria RAM: %MemRAM% GB
echo Processador: %processor%
echo Endereco IPv4: %IPv4%
echo --------------------------------------------

REM Gerar Ficheiro
SET file="%letra%:\Fetcher\PCs\Piso_%id%\%computername%.txt"
echo -------------------------------------------- > %file%
echo Nome Computador: %computername% >> %file%
echo Numero de Serie: %serialnumber% >> %file%
echo Sistema Operativo: %osname% >> %file%
echo Memoria RAM: %MemRAM% GB>> %file%
echo Processador: %processor% >> %file%
echo Endereco IPv4: %IPv4% >> %file%
echo -------------------------------------------- >> %file%

echo ,%computername%,%IPv4%,%osname%,%MemRAM% Gb,%processor%,%serialnumber%>> "%letra%:\Fetcher\RawDataExcel\Piso_%id%.csv"
pause
exit
