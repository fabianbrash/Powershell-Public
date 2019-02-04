
#Filename:            WinClusterAutomation.ps1
#Author:              Fabian Brash
#Date:                11-30-2017
#Modified:            11-30-2017
#Purpose:             Automate deployment of a 3 node Windows Cluster



<#________   ________   ________
|\   __  \ |\   __  \ |\   ____\
\ \  \|\  \\ \  \|\  \\ \  \___|_
 \ \   _  _\\ \   ____\\ \_____  \
  \ \  \\  \|\ \  \___| \|____|\  \
   \ \__\\ _\ \ \__\      ____\_\  \
    \|__|\|__| \|__|     |\_________\
                         \|_________|#>


Clear-Host

$ClusterIP = Read-Host "Please enter cluster IP"
$Clustering = 'Failover-Clustering'
$NodeA = Read-Host "Enter the name for the 1st node"
$NodeB = Read-Host "Enter the name for the 2nd node"
$NodeC = Read-Host "Enter the name for the 3rd node"
$ClusterName = Read-Host "Please enter the name of the cluster to create"

Install-WindowsFeature -Name $Clustering -IncludeManagementTools  #Do this on each node first

New-Cluster -Name $ClusterName -Node $NodeA,NodeB,NodeC -StaticAddress $ClusterIP
