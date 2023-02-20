# https://learn.microsoft.com/en-us/powershell/module/az.network/get-aznetworkservicetag?view=azps-9.3.0
# https://woivre.com/blog/2020/04/azure-service-ips

function Get-AzureIpAddresses {
  param (
      [Parameter(Mandatory = $true)]
      [string]$location,
      [Parameter(Mandatory = $true)]
      [string]$service
  )

  try {
      $serviceName = $service+ "." +$location
      $serviceTags = Get-AzNetworkServiceTag -Location $location
      $serviceTag  = $serviceTags.Values | Where-Object { $_.Name -eq $serviceName }
      $ipAddresses = $serviceTag.Properties.AddressPrefixes | Where-Object { $_ -notmatch ':' }
      return $ipAddresses
  }
  catch {
      Write-Error "The Get-AzureIpAddresses function failed to get IPs for $service service in $location location: $($_.Exception.Message)"
  }
}


Get-AzureIpAddresses -location $location -service $service