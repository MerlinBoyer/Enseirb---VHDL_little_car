@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 022a523d72cd4b0f9d448502bda99ef7 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot coor_voiture_tb_behav xil_defaultlib.coor_voiture_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
