if(($null -eq $TestName) -or ($TestName -contains 'Get-AzCdnOriginGroup'))
{
  $loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
  if (-Not (Test-Path -Path $loadEnvPath)) {
      $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
  }
  . ($loadEnvPath)
  $TestRecordingFile = Join-Path $PSScriptRoot 'Get-AzCdnOriginGroup.Recording.json'
  $currentPath = $PSScriptRoot
  while(-not $mockingPath) {
      $mockingPath = Get-ChildItem -Path $currentPath -Recurse -Include 'HttpPipelineMocking.ps1' -File
      $currentPath = Split-Path -Path $currentPath -Parent
  }
  . ($mockingPath | Select-Object -First 1).FullName
}

Describe 'Get-AzCdnOriginGroup' {
    It 'List' {
        { 
            $subId = $env.SubscriptionId
            $ResourceGroupName = 'testps-rg-' + (RandomString -allChars $false -len 6)
            try
            {
                Write-Host -ForegroundColor Green "Create test group $($ResourceGroupName)"
                New-AzResourceGroup -Name $ResourceGroupName -Location $env.location

                $cdnProfileName = 'p-' + (RandomString -allChars $false -len 6);
                Write-Host -ForegroundColor Green "Use cdnProfileName : $($cdnProfileName)"

                $profileSku = "Standard_Microsoft";
                New-AzCdnProfile -SkuName $profileSku -Name $cdnProfileName -ResourceGroupName $ResourceGroupName -Location Global

                $endpointName = 'e-' + (RandomString -allChars $false -len 6);
                Write-Host -ForegroundColor Green "Create endpointName : $($endpointName)"
                
                $location = "westus"
                $origin = @{
                    Name = "origin1"
                    HostName = "host1.hello.com"
                };
                $originId = "/subscriptions/$subId/resourcegroups/$ResourceGroupName/providers/Microsoft.Cdn/profiles/$cdnProfileName/endpoints/$endpointName/origins/$($origin.Name)"
                $healthProbeParametersObject = New-AzCdnHealthProbeParametersObject -ProbeIntervalInSecond 240 -ProbePath "/health.aspx" -ProbeProtocol "Https" -ProbeRequestType "GET" 
                $originGroup = @{
                    Name = "originGroup1"
                    healthProbeSetting = $healthProbeParametersObject 
                    Origin = @(@{
                        Id = $originId
                    })
                }
                $defaultOriginGroup = "/subscriptions/$subId/resourcegroups/$ResourceGroupName/providers/Microsoft.Cdn/profiles/$cdnProfileName/endpoints/$endpointName/origingroups/$($originGroup.Name)"
                New-AzCdnEndpoint -Name $endpointName -ResourceGroupName $ResourceGroupName -ProfileName $cdnProfileName -Location $location `
                    -Origin $origin -OriginGroup $originGroup -DefaultOriginGroupId $defaultOriginGroup
                $originGroups = Get-AzCdnOriginGroup -EndpointName $endpointName -ProfileName $cdnProfileName -ResourceGroupName $ResourceGroupName
                
                $originGroups.Count | Should -Be 1
            } Finally
            {
                Remove-AzResourceGroup -Name $ResourceGroupName -NoWait
            }
        } | Should -Not -Throw
    }

    It 'Get' {
        { 
            $subId = $env.SubscriptionId
            $ResourceGroupName = 'testps-rg-' + (RandomString -allChars $false -len 6)
            try
            {
                Write-Host -ForegroundColor Green "Create test group $($ResourceGroupName)"
                New-AzResourceGroup -Name $ResourceGroupName -Location $env.location

                $cdnProfileName = 'p-' + (RandomString -allChars $false -len 6);
                Write-Host -ForegroundColor Green "Use cdnProfileName : $($cdnProfileName)"

                $profileSku = "Standard_Microsoft";
                New-AzCdnProfile -SkuName $profileSku -Name $cdnProfileName -ResourceGroupName $ResourceGroupName -Location Global

                $endpointName = 'e-' + (RandomString -allChars $false -len 6);
                Write-Host -ForegroundColor Green "Create endpointName : $($endpointName)"
                
                $location = "westus"
                $origin = @{
                    Name = "origin1"
                    HostName = "host1.hello.com"
                };
                $originId = "/subscriptions/$subId/resourcegroups/$ResourceGroupName/providers/Microsoft.Cdn/profiles/$cdnProfileName/endpoints/$endpointName/origins/$($origin.Name)"
                $healthProbeParametersObject = New-AzCdnHealthProbeParametersObject -ProbeIntervalInSecond 240 -ProbePath "/health.aspx" -ProbeProtocol "Https" -ProbeRequestType "GET" 
                $originGroup = @{
                    Name = "originGroup1"
                    healthProbeSetting = $healthProbeParametersObject 
                    Origin = @(@{
                        Id = $originId
                    })
                }
                $defaultOriginGroup = "/subscriptions/$subId/resourcegroups/$ResourceGroupName/providers/Microsoft.Cdn/profiles/$cdnProfileName/endpoints/$endpointName/origingroups/$($originGroup.Name)"
                New-AzCdnEndpoint -Name $endpointName -ResourceGroupName $ResourceGroupName -ProfileName $cdnProfileName -Location $location `
                    -Origin $origin -OriginGroup $originGroup -DefaultOriginGroupId $defaultOriginGroup
                $endpointOriginGroup = Get-AzCdnOriginGroup -Name $originGroup.Name -EndpointName $endpointName -ProfileName $cdnProfileName -ResourceGroupName $ResourceGroupName
                
                $endpointOriginGroup.Name | Should -Be $originGroup.Name
                $endpointOriginGroup.HealthProbeSetting.ProbeIntervalInSecond | Should -Be $originGroup.HealthProbeSetting.ProbeIntervalInSecond
                $endpointOriginGroup.HealthProbeSetting.ProbePath | Should -Be $originGroup.HealthProbeSetting.ProbePath
                $endpointOriginGroup.HealthProbeSetting.ProbeProtocol | Should -Be $originGroup.HealthProbeSetting.ProbeProtocol
                $endpointOriginGroup.HealthProbeSetting.ProbeRequestType | Should -Be  $originGroup.HealthProbeSetting.ProbeRequestType
                $endpointOriginGroup.Origin[0].Id | Should -Be $originGroup.Origin[0].Id
            } Finally
            {
                Remove-AzResourceGroup -Name $ResourceGroupName -NoWait
            }
        } | Should -Not -Throw
    }

    It 'GetViaIdentity' {
        { 
            $PSDefaultParameterValues['Disabled'] = $true
            $subId = $env.SubscriptionId
            $ResourceGroupName = 'testps-rg-' + (RandomString -allChars $false -len 6)
            try
            {
                Write-Host -ForegroundColor Green "Create test group $($ResourceGroupName)"
                New-AzResourceGroup -Name $ResourceGroupName -Location $env.location

                $cdnProfileName = 'p-' + (RandomString -allChars $false -len 6);
                Write-Host -ForegroundColor Green "Use cdnProfileName : $($cdnProfileName)"

                $profileSku = "Standard_Microsoft";
                New-AzCdnProfile -SkuName $profileSku -Name $cdnProfileName -ResourceGroupName $ResourceGroupName -Location Global

                $endpointName = 'e-' + (RandomString -allChars $false -len 6);
                Write-Host -ForegroundColor Green "Create endpointName : $($endpointName)"
                
                $location = "westus"
                $origin = @{
                    Name = "origin1"
                    HostName = "host1.hello.com"
                };
                $originId = "/subscriptions/$subId/resourcegroups/$ResourceGroupName/providers/Microsoft.Cdn/profiles/$cdnProfileName/endpoints/$endpointName/origins/$($origin.Name)"
                $healthProbeParametersObject = New-AzCdnHealthProbeParametersObject -ProbeIntervalInSecond 240 -ProbePath "/health.aspx" -ProbeProtocol "Https" -ProbeRequestType "GET" 
                $originGroup = @{
                    Name = "originGroup1"
                    healthProbeSetting = $healthProbeParametersObject 
                    Origin = @(@{
                        Id = $originId
                    })
                }
                $defaultOriginGroup = "/subscriptions/$subId/resourcegroups/$ResourceGroupName/providers/Microsoft.Cdn/profiles/$cdnProfileName/endpoints/$endpointName/origingroups/$($originGroup.Name)"
                New-AzCdnEndpoint -Name $endpointName -ResourceGroupName $ResourceGroupName -ProfileName $cdnProfileName -Location $location `
                    -Origin $origin -OriginGroup $originGroup -DefaultOriginGroupId $defaultOriginGroup
                $endpointOriginGroup = Get-AzCdnOriginGroup -Name $originGroup.Name -EndpointName $endpointName -ProfileName $cdnProfileName -ResourceGroupName $ResourceGroupName | Get-AzCdnOriginGroup
                
                $endpointOriginGroup.Name | Should -Be $originGroup.Name
                $endpointOriginGroup.HealthProbeSetting.ProbeIntervalInSecond | Should -Be $originGroup.HealthProbeSetting.ProbeIntervalInSecond
                $endpointOriginGroup.HealthProbeSetting.ProbePath | Should -Be $originGroup.HealthProbeSetting.ProbePath
                $endpointOriginGroup.HealthProbeSetting.ProbeProtocol | Should -Be $originGroup.HealthProbeSetting.ProbeProtocol
                $endpointOriginGroup.HealthProbeSetting.ProbeRequestType | Should -Be  $originGroup.HealthProbeSetting.ProbeRequestType
                $endpointOriginGroup.Origin[0].Id | Should -Be $originGroup.Origin[0].Id
            } Finally
            {
                Remove-AzResourceGroup -Name $ResourceGroupName -NoWait
            }
        } | Should -Not -Throw
    }
}
