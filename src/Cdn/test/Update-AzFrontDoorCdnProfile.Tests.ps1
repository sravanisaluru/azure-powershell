if(($null -eq $TestName) -or ($TestName -contains 'Update-AzFrontDoorCdnProfile'))
{
  $loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
  if (-Not (Test-Path -Path $loadEnvPath)) {
      $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
  }
  . ($loadEnvPath)
  $TestRecordingFile = Join-Path $PSScriptRoot 'Update-AzFrontDoorCdnProfile.Recording.json'
  $currentPath = $PSScriptRoot
  while(-not $mockingPath) {
      $mockingPath = Get-ChildItem -Path $currentPath -Recurse -Include 'HttpPipelineMocking.ps1' -File
      $currentPath = Split-Path -Path $currentPath -Parent
  }
  . ($mockingPath | Select-Object -First 1).FullName
}

Describe 'Update-AzFrontDoorCdnProfile' {
    It 'UpdateExpanded' {
        { 
            $ResourceGroupName = 'testps-rg-' + (RandomString -allChars $false -len 6)
            try
            {
                Write-Host -ForegroundColor Green "Create test group $($ResourceGroupName)"
                New-AzResourceGroup -Name $ResourceGroupName -Location $env.location

                $frontDoorCdnProfileName = 'fdp-' + (RandomString -allChars $false -len 6);
                Write-Host -ForegroundColor Green "Use frontDoorCdnProfileName : $($frontDoorCdnProfileName)"

                $profileSku = "Standard_AzureFrontDoor";
                $tags = @{
                    Tag1 = 1
                    Tag2  = 2
                }
                New-AzFrontDoorCdnProfile -SkuName $profileSku -Name $frontDoorCdnProfileName -ResourceGroupName $ResourceGroupName -Location Global -Tag $tags
                $tags = @{
                    Tag1 = 11
                    Tag2  = 22
                }
                Update-AzFrontDoorCdnProfile -Name $frontDoorCdnProfileName -ResourceGroupName $ResourceGroupName -Tag $tags
                $updatedProfile = Get-AzFrontDoorCdnProfile -Name $frontDoorCdnProfileName -ResourceGroupName $ResourceGroupName
                
                $updatedProfile.Tag["Tag1"] | Should -Be "11"
                $updatedProfile.Tag["Tag2"] | Should -Be "22"
            } Finally
            {
                Remove-AzResourceGroup -Name $ResourceGroupName -NoWait
            }
        } | Should -Not -Throw
    }

    It 'UpdateViaIdentityExpanded' {
        { 
            $PSDefaultParameterValues['Disabled'] = $true
            $ResourceGroupName = 'testps-rg-' + (RandomString -allChars $false -len 6)
            try
            {
                Write-Host -ForegroundColor Green "Create test group $($ResourceGroupName)"
                New-AzResourceGroup -Name $ResourceGroupName -Location $env.location

                $frontDoorCdnProfileName = 'fdp-' + (RandomString -allChars $false -len 6);
                Write-Host -ForegroundColor Green "Use frontDoorCdnProfileName : $($frontDoorCdnProfileName)"

                $profileSku = "Standard_AzureFrontDoor";
                $tags = @{
                    Tag1 = 1
                    Tag2  = 2
                }
                New-AzFrontDoorCdnProfile -SkuName $profileSku -Name $frontDoorCdnProfileName -ResourceGroupName $ResourceGroupName -Location Global -Tag $tags
                $tags = @{
                    Tag1 = 11
                    Tag2  = 22
                }
                Get-AzFrontDoorCdnProfile -Name $frontDoorCdnProfileName -ResourceGroupName $ResourceGroupName | Update-AzFrontDoorCdnProfile -Tag $tags
                $updatedProfile = Get-AzFrontDoorCdnProfile -Name $frontDoorCdnProfileName -ResourceGroupName $ResourceGroupName
                
                $updatedProfile.Tag["Tag1"] | Should -Be "11"
                $updatedProfile.Tag["Tag2"] | Should -Be "22"
            } Finally
            {
                Remove-AzResourceGroup -Name $ResourceGroupName -NoWait
            }
        } | Should -Not -Throw
    }
}
