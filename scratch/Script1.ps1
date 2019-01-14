#
# Script1.ps1
#
Start-AzureRMVM -ResourceGroupName "SP2013TestLab" -Name "DC1"
Start-AzureRMVM -ResourceGroupName "SP2013TestLab" -Name "SQL1"
Start-AzureRMVM -ResourceGroupName "SP2013TestLab" -Name "APP1"
Start-AzureRMVM -ResourceGroupName "SP2013TestLab" -Name "WFE1"
Start-AzureRMVM -ResourceGroupName "SP2013TestLab" -Name "CLIENT1"



Stop-AzureRMVM -ResourceGroupName "SP2013TestLab" -Name "CLIENT1" -Force
Stop-AzureRMVM -ResourceGroupName "SP2013TestLab" -Name "WFE1" -Force
Stop-AzureRMVM -ResourceGroupName "SP2013TestLab" -Name "APP1" -Force
Stop-AzureRMVM -ResourceGroupName "SP2013TestLab" -Name "SQL1" -Force
Stop-AzureRMVM -ResourceGroupName "SP2013TestLab" -Name "DC1" -Force
