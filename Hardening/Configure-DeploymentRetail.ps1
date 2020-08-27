
function Get-DeploymentRetailMode {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string[]] $ComputerName = $env:COMPUTERNAME
    )

    begin {
        $netfxFolders = @{ 
            'Framework 2.0 x86' = 'C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\CONFIG'; 
            'Framework 4.0 x86' = 'C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\CONFIG'; 
            'Framework 2.0 x64' = 'C:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\CONFIG'; 
            'Framework 4.0 x64' = 'C:\WINDOWS\Microsoft.NET\Framework64\v4.0.30319\CONFIG';
        }
    }

    process {
        $ComputerName | ForEach-Object {
            $Computer = $_
            if (Test-Connection -ComputerName $Computer -Count 1 -Quiet) {

                $netfxFolders.GetEnumerator() | Sort-Object Name | ForEach-Object { 

                    $NetFxVersion = $_.Name
                    $MachineConfig = $_.Value + '\machine.config'
                    $MachineConfig = $MachineConfig -replace [regex]::Escape('C:\WINDOWS\'), "\\$Computer\Admin`$\"

                    if (Test-Path -Path $MachineConfig -PathType Leaf) {
                        $RetailMode = (([xml](Get-Content -Path $MachineConfig)).configuration.'system.web'.deployment.retail)
                        New-Object -TypeName PSObject -Property @{ 
                            ComputerName = $Computer
                            NetFxVersion = $NetFxVersion
                            RetailMode = $RetailMode
                        } | Select-Object ComputerName, NetFxVersion, RetailMode
            
                    } else {
                        Write-Verbose "$NetFxVersion is not installed on $Computer, or the machine.config file is unreachable"
                    }
                }
            } else {
                    Write-Warning "$Computer is unreachable" 
            }
        }
    }
    <#
    .Synopsis
    Gets the mode that specifies whether the deployed web applications are in retail mode or not, on each of the .NET CLRs installed

    .Description
    Gets the mode that specifies whether the deployed web applications are in retail mode or not, on each of the .NET CLRs installed
    When the retail attribute is true, ASP.NET disables trace output, disables debug capabilities, and disables detailed system-generated error messages for remote users. 
    For applications that have a customErrors element in the application Web.config file, the mode attribute is forced to On. 
    These settings override any settings that are made in application Web.config files.
    See https://msdn.microsoft.com/en-us/library/vstudio/ms228298 for more details

    .Parameter ComputerName
    The netbios name, FQDN or IP Address of the remote computer to retreive the information from
    #>
}


function Set-DeploymentRetailMode {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string[]] $ComputerName = $env:COMPUTERNAME,

        [ValidateSet($true, $false)]
        [Alias('DeploymentRetail','RetailMode')]
        $Retail = $true
    )

    begin {
        $netfxFolders = @{ 
            'Framework 2.0 x86' = 'C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\CONFIG'; 
            'Framework 4.0 x86' = 'C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\CONFIG'; 
            'Framework 2.0 x64' = 'C:\WINDOWS\Microsoft.NET\Framework64\v2.0.50727\CONFIG'; 
            'Framework 4.0 x64' = 'C:\WINDOWS\Microsoft.NET\Framework64\v4.0.30319\CONFIG';
        }
        $RetailMode = $Retail.ToString().ToLower()
    }

        process {
            $ComputerName | ForEach-Object {
            $Computer = $_

            if($PSCmdlet.ShouldProcess($Computer, "Configure the deplyment retail mode in the machine.config files")) {

                if (Test-Connection -ComputerName $Computer -Count 1 -Quiet) {

                    $netfxFolders.GetEnumerator() | Sort-Object Name | ForEach-Object { 

                        $NetFxVersion = $_.Name
                        $MachineConfig = $_.Value + '\machine.config'
                        $MachineConfig = $MachineConfig -replace [regex]::Escape('C:\WINDOWS\'), "\\$Computer\Admin`$\"

                        if (Test-Path -Path $MachineConfig -PathType Leaf) {

                            $TargetFilePath = $MachineConfig  + ('-{0:yyyyMMddHHmmss}.bak' -f (Get-Date))
                            Copy-Item -Path $MachineConfig -Destination $TargetFilePath -Force -ErrorAction SilentlyContinue
                            if (-not ($?)) {
                                 Write-Warning "Unable to backup $MachineConfig. File skipped"
                            } else {
                                $xmlMachineConfig = [xml](Get-Content -Path $MachineConfig)
                                if (-not $xmlMachineConfig.SelectSingleNode('configuration/system.web/deployment')) {
                                    $deployment = $xmlMachineConfig.CreateElement('deployment')
                                    $sw = $xmlMachineConfig.SelectSingleNode('configuration/system.web')
                                    [void] $sw.AppendChild($deployment)
                                }
                                if (-not $xmlMachineConfig.SelectSingleNode('configuration/system.web/deployment/retail')) {
                                    $deployment = $xmlMachineConfig.SelectSingleNode('configuration/system.web/deployment')
                                    $deployment.SetAttribute('retail', $RetailMode)
                                } else {
                                    $xmlMachineConfig.configuration.'system.web'.deployment.retail = $RetailMode
                                }
                                $xmlMachineConfig.Save($MachineConfig)

                                New-Object -TypeName PSObject -Property @{ 
                                    ComputerName = $Computer
                                    NetFxVersion = $NetFxVersion
                                    RetailMode = $xmlMachineConfig.configuration.'system.web'.deployment.retail
                                } | Select-Object ComputerName, NetFxVersion, RetailMode
                

                            }
                        } else {
                            Write-Verbose "$NetFxVersion is not installed on $Computer, or the machine.config file is unreachable"
                        }
                    }
                } else {
                        Write-Warning "$Computer is unreachable" 
                }
            }
        }
    }
    <#
    .Synopsis
    Sets the mode that specifies whether the deployed web applications are in retail mode or not, on each of the .NET CLRs installed

    .Description
    Sets the mode that specifies whether the deployed web applications are in retail mode or not, on each of the .NET CLRs installed
    When the retail attribute is true, ASP.NET disables trace output, disables debug capabilities, and disables detailed system-generated error messages for remote users. 
    For applications that have a customErrors element in the application Web.config file, the mode attribute is forced to On. 
    These settings override any settings that are made in application Web.config files.
    See https://msdn.microsoft.com/en-us/library/vstudio/ms228298 for more details

    .Parameter ComputerName
    The netbios name, FQDN or IP Address of the remote computer to retreive the information from

    .Parameter Retail
    A bolean value that represents if the deployment retail mode is on ($true) or off ($false)
    #>
}

# Usage examples:
# ----------------
# Get-DeploymentRetailMode
# Set-DeploymentRetailMode -Retail False

# 'Web01', 'Web02', 'Web03' | Get-DeploymentRetailMode
# Get-DeploymentRetailMode -ComputerName 'Web01', 'Web02', 'Web03'

# Set-DeploymentRetailMode -ComputerName 'Web01', 'Web02', 'Web03' -Retail $true -WhatIf
# 'Web01', 'Web02' | Set-DeploymentRetailMode -Retail $false -WhatIf