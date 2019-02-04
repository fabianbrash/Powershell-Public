<#
###FileName: Enable_VBS_Cred_Guard.ps1
###Purpose:  Enable VBS and Credential Guard on a Windows Server 2016/Win10 VM
#>

function Enable_VBS {
  $DeviceGuard_REG = "HKLM:\System\CurrentControlSet\Control\DeviceGuard"

  $DW_Enable_VBS = "EnableVirtualizationBasedSecurity"

  ###Set the above key to 1 to enable or 0 to disable

  $DW_Require_PSF = "RequirePlatformSecurityFeatures"

  ##Set to 1 to use "Secure Boot only" or 3 to use "Secure Boot and DMA protection" in a VM environment set to 1

  ####Core logic#############

  Set-ItemProperty -Path $DeviceGuard_REG -Name $DW_Enable_VBS -Value 1 -Type DWord
  Set-ItemProperty -Path $DeviceGuard_REG -Name $DW_Require_PSF -Value 1 -Type DWord


  <##Now let's setup CredGuard#>

  $CredG_REG = "HKLM:\System\CurrentControlSet\Control\LSA"

  $DW_LsaCfgFlags = "LsaCfgFlags"

  ##Set to 1 to enable CredGuard with UEFI lock or 2 to enable without lock or 0 to disable, for our environment we would choose 2

  ####Core Logic###########

  Set-ItemProperty -Path $CredG_REG -Name $DW_LsaCfgFlags -Value 2 -Type DWord

  #####Reboot Machine

  Start-Sleep -s 6

  Restart-Computer -Force
  }
  
  Enable_VBS
