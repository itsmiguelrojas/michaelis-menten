@echo off
C:
PATH "C:\Program Files\R\R-4.2.2\bin"
cd "%~dp0"
Rscript "%~dp0enzymeApp.R"
exit