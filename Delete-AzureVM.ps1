Clear-Host

$theVM = "wus-dev-2"

Remove-AzVM -ResourceGroupName Lab-West -Name $theVM -Force -Confirm:$false -NoWait