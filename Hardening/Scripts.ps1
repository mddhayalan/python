# [SCTY_CC] T928: Ensure debug is turned off (Microsoft IIS)

. .\Configure-DeploymentRetail.ps1
Set-DeploymentRetailMode -Retail True

#[SCTY_CC] T931: Ensure httpcookie mode is configured for session state (Microsoft IIS)
Write-Host "[SCTY_CC] T931: Ensure httpcookie mode is configured for session state (Microsoft IIS)"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST/Default Web Site' -filter "system.web/sessionState" -name "mode" -value "StateServer"

#[SCTY_CC] T933: Configure request filters properly (Microsoft IIS)
Write-Host "[SCTY_CC] T933: Configure request filters properly (Microsoft IIS)"
# Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/security/requestFiltering/requestLimits" -name "maxAllowedContentLength" -value 30000000
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/security/requestFiltering/requestLimits" -name "maxUrl" -value 4096
# Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/security/requestFiltering/requestLimits" -name "maxQueryString" -value 2048
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/security/requestFiltering" -name "allowHighBitCharacters" -value "False"

#[SCTY_CC] T934: Ensure HSTS Header is set (Microsoft IIS)
Write-Host "[SCTY_CC] T934: Ensure HSTS Header is set (Microsoft IIS)"
%systemroot%\system32\inetsrv\appcmd.exe set config -section:system.webServer/httpProtocol /+"customHeaders.[name='Strict-Transport-Security',value='max-age=480; includeSubDomains; preload']"

# #[SCTY_CC] T926: Use cookies for forms authentication (Microsoft IIS)
# Write-Host "[SCTY_CC] T926: Use cookies for forms authentication (Microsoft IIS)"
# Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST/Default Web Site' -filter 'system.web/authentication/forms' -name 'cookieless' -value 'UseCookies'

# #[SCTY_CC] T915: Configure MachineKey validation securely (Microsoft IIS)
# Write-Host "[SCTY_CC] T915: Configure MachineKey validation securely (Microsoft IIS)"
# Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT' -filter "system.web/machineKey" -name "validation" -value "AES"

#[SCTY_CC] T916: Ensure global .NET trust level is configured securely (Microsoft IIS)
Write-Host "[SCTY_CC] T916: Ensure global .NET trust level is configured securely (Microsoft IIS)"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT' -filter "system.web/trust" -name "level" -value "Medium"

#[SCTY_CC] T917: Reject double-encoded requests (Microsoft IIS)
Write-Host "[SCTY_CC] T917: Reject double-encoded requests (Microsoft IIS)"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/security/requestFiltering" -name "allowDoubleEscaping" -value "True"

#[SCTY_CC] T918: Disable 'HTTP Trace Method' (Microsoft IIS)
Write-Host "[SCTY_CC] T918: Disable 'HTTP Trace Method' (Microsoft IIS)"
Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/security/requestFiltering/verbs" -name "." -value @{verb='TRACE';allowed='False'}

#[SCTY_CC] T919: Do not allow unlisted file extensions (Microsoft IIS)
Write-Host "[SCTY_CC] T919: Do not allow unlisted file extensions (Microsoft IIS)"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/security/requestFiltering/fileExtensions" -name "allowUnlisted" -value "False"

#[SCTY_CC] T924: Configure FTP securely (Microsoft IIS)
Write-Host "[SCTY_CC] T924: Configure FTP securely (Microsoft IIS)"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.applicationHost/sites/siteDefaults/ftpServer/security/ssl" -name "controlChannelPolicy" -value "SslRequire"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.applicationHost/sites/siteDefaults/ftpServer/security/ssl" -name "dataChannelPolicy" -value "SslRequire"

#[SCTY_CC] T925: Configure TLS/SSL securely for Microsoft IIS (Microsoft IIS)

#[SCTY_CC] T904: Disable 'directory browsing' (Microsoft IIS)
Write-Host "[SCTY_CC] T904: Disable 'directory browsing' (Microsoft IIS)"
Set-WebConfigurationProperty -Filter system.webserver/directorybrowse -PSPath iis:\ -Name Enabled -Value False

#[SCTY_CC] T905: Configure application pools securely (Microsoft IIS)
Write-Host "[SCTY_CC] T905: Configure application pools securely (Microsoft IIS)"
$appPools = Get-IISAppPool
foreach ($apppool in $appPools) {
    $appPoolName = $apppool.Name
    Write-Host "Configuring AppPool: $appPoolName"
    Set-ItemProperty -Path IIS:\AppPools\$appPoolName -Name passAnonymousToken -Value True
}

#[SCTY_CC] T906: Set 'global authorization rule' to restrict access (Microsoft IIS)
# Write-Host "[SCTY_CC] T906: Set 'global authorization rule' to restrict access (Microsoft IIS)"
# Remove-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/security/authorization" -name "." -AtElement @{users='*';roles='';verbs=''}
# Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/security/authorization" -name "." -value @{accessType='Allow';roles='Administrators'}

#[SCTY_CC] T907: Restrict access to sensitive site features to authenticated principals only (Microsoft IIS)
# Write-Host "[SCTY_CC] T907: Restrict access to sensitive site features to authenticated principals only (Microsoft IIS)"
# Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -location '<website location>' -filter 'system.webServer/security/authentication/anonymousAuthentication' -name 'enabled' -value 'False'
# Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -location '<website location>' -filter 'system.webServer/security/authentication/windowsAuthentication' -name 'enabled' -value 'True'

#[SCTY_CC] T908: Require SSL/TLS for 'forms authentication' (Microsoft IIS)
Write-Host "[SCTY_CC] T908: Require SSL/TLS for 'forms authentication' (Microsoft IIS)"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST/Default Web Site' -filter 'system.web/authentication/forms' -name 'requireSSL' -value 'True'

#[SCTY_CC] T909: Configure 'cookie protection mode' for forms authentication (Microsoft IIS)
Write-Host "[SCTY_CC] T909: Configure 'cookie protection mode' for forms authentication (Microsoft IIS)"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST/Default Web Site' -filter 'system.web/authentication/forms' -name 'protection' -value 'All'

#[SCTY_CC] T913: Ensure HTTP detailed errors are hidden from displaying remotely (Microsoft IIS)
Write-Host "[SCTY_CC] T913: Ensure HTTP detailed errors are hidden from displaying remotely (Microsoft IIS)"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST/Default Web Site' -filter "system.webServer/httpErrors" -name "errorMode" -value "DetailedLocalOnly"

#[SCTY_CC] T910: Configure transport layer security for 'basic authentication' (Microsoft IIS)
# Remoive TLS 1.0, 1.1
Write-Host "[SCTY_CC] T910: Configure transport layer security for 'basic authentication' (Microsoft IIS)"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -location 'Default Web Site' -filter 'system.webServer/security/access' -name 'sslFlags' -value 'Ssl'

#[SCTY_CC] T921: Restrict unlisted extensions from being run (Microsoft IIS)
Write-Host "[SCTY_CC] T921: Restrict unlisted extensions from being run (Microsoft IIS)"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/security/requestFiltering/fileExtensions" -name "allowUnlisted" -value "False"

#[SCTY_CC] T923: Configure logging securely on Microsoft IIS (Microsoft IIS)
Write-Host "[SCTY_CC] T923: Configure logging securely on Microsoft IIS (Microsoft IIS)"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.applicationHost/sites/siteDefaults/logFile" -name "directory" -value 'D:\Honeywell\iisLogs'

#[SCTY_CC] T922: Enable 'Dynamic IP Address Restrictions' (Microsoft IIS)
Write-Host "[SCTY_CC] T922: Enable 'Dynamic IP Address Restrictions' (Microsoft IIS)"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.webServer/security/dynamicIpSecurity/denyByConcurrentRequests" -name "enabled" -value "True"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.webServer/security/dynamicIpSecurity/denyByConcurrentRequests" -name "maxConcurrentRequests" -value 30

#[SCTY_CC] T920: Ensure handlers are not granted Write and Script/Execute permissions at the same time (Microsoft IIS)
Write-Host "[SCTY_CC] T920: Ensure handlers are not granted Write and Script/Execute permissions at the same time (Microsoft IIS)"
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/handlers" -name "accessPolicy" -value "Read,Script"