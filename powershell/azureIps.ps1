# https://learn.microsoft.com/en-us/powershell/module/az.network/get-aznetworkservicetag?view=azps-9.3.0
# https://woivre.com/blog/2020/04/azure-service-ips

function Get-AzureIps {
  param (
    [Parameter(Mandatory = $true)]
    [string]$location,
  
    [Parameter(Mandatory = $true)]
    [string]$service
  )

  try {
    $serviceTags = Get-AzNetworkServiceTag -Location $location
    $serviceName = $service+ "." +$location
    $serviceTag  = $serviceTags.Values | Where-Object { $_.Name -eq $serviceName } # Get 
    $ipAddresses = $serviceTag.Properties.AddressPrefixes | Where-Object { $_ -notmatch ':' }
    return $ipAddresses
    Write-Output $ipAddresses
  }
  catch {
    Write-Output "Failed to get Azure IPs"
  }
}

Write-Host $ipAddresses