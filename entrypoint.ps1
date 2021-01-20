#!/usr/bin/pwsh -Command

write-host "Check Prerelease version of nuget package "

$path = (Get-Item -Path ".\" -Verbose).FullName
$allPackages = @{}
$slnPath = $args[0]
if(!(Test-Path($slnPath)))
{
 Write-Error "File in solution-file-full-path was not found, pleae make sure you are using teh checkout step, and/or please check the parameter value and try again"
 exit 1
}
$slnFile = Get-Item $slnPath
$slnDir = Split-Path -parent $slnFile

function Get-PathsContainingAProjectFile($path){
    Get-Content $path | ForEach-Object {
        if($_.StartsWith("Project(")){
           $_.Split('"') | Where-Object { $_.EndsWith(".csproj") }
        }
    }
}

function Get-HasPackageReference($path){
    $fileContent = Get-Content $path

    $isOk = $fileContent | ForEach-Object { $_ -match 'PackageReference'  }

    if ($isOk -eq $true) {
        return $true
    } else {
        return $false
    }
}

Get-PathsContainingAProjectFile($slnPath) | ForEach-Object { 

    $fullName = Join-Path $slnDir  $_

    if (Get-HasPackageReference($fullName)) {
        $projPath = Split-Path -parent(Join-Path $slnDir  $_)

        Get-ChildItem $projPath -Recurse -Filter "*.csproj" -ErrorAction Ignore | ForEach-Object {
            $packagePath = $_.FullName
            [xml]$config = Get-Content $packagePath
            foreach($ig in $config.Project.ItemGroup) {
                foreach($igc in $ig.ChildNodes) {
                    if ($igc.Name -eq 'PackageReference') {
                        if($igc.Version -like '*-*'){ 
                            $version = $igc.Version
                            if(!($allPackages[$igc.Include])){
                                $allPackages[$igc.Include] += @{}
                            }
                            if(!($allPackages[$igc.Include][$version])){
                                $allPackages[$igc.Include][$version] = @()
                            }
                            $allPackages[$igc.Include][$version] += $packagePath.Replace($slnDir, "")
                        }
                    }
                }
            }
        } 

    } else {
        Write-Host "NOT OKAY: no PackageReference found in: " $fullName  
    }
}


$prnuget = $allPackages.GetEnumerator() | Where-Object { $_.Value.Keys.Count -gt 0 } | ForEach-Object {
    $name = $_.Key    

    $_.Value.GetEnumerator() | ForEach-Object {
        $version = $_.Key
        $_.Value | ForEach-Object {                    

            New-Object PsObject -Property @{
                name = $name
                version = $version 
                path = $_
            }
        }
    }   
} 

$prnuget | ForEach-Object {
    Write-Error "`e[31;107m Prerelease version of nuget exists in the project $($_.name) on $($_.path) and version $($_.version)`e[0m" 
}

if($prnuget.Count -gt 0){
    exit 1
}
