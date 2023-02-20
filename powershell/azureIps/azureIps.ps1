# https://learn.microsoft.com/en-us/powershell/module/az.network/get-aznetworkservicetag?view=azps-9.3.0
# https://woivre.com/blog/2020/04/azure-service-ips

param (
  [Parameter(Mandatory = $true)]
  [string]$location,
  [Parameter(Mandatory = $true)]
  [string]$service
)

function Get-AzureIpAddresses {
  try {
      $serviceName = $service + "." + $location
      $serviceTags = Get-AzNetworkServiceTag -Location $location -ErrorAction Stop
      $serviceTag  = $serviceTags.Values | Where-Object { $_.Name -eq $serviceName }
      $ipAddresses = $serviceTag.Properties.AddressPrefixes | Where-Object { $_ -notmatch ':' } # Remove ipv6
      if ($ipAddresses.Count -eq 0) {
        throw "No IP addresses were found for the $service service in the $location location."
      }
      return $ipAddresses
  }
  catch {
      Write-Error $($_.Exception.Message)
  }
}

Get-AzureIpAddresses -location $location -service $service