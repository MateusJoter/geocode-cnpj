@echo off
echo Executando o script Python (preparar_enderecos.py)...
python preparar_enderecos.py

IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo Erro: O script Python falhou. O script R nao sera executado.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo O script Python finalizou com sucesso. Executando o script R (geocode.R)...
Rscript geocode.R

IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo Erro: O script R falhou.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo Pipeline concluido com sucesso!
pause
