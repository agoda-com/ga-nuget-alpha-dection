function Get-PathsContainingAProjectFile($path){
    Get-Content $path | ForEach-Object {
        if($_.StartsWith("Project(")){
           $_.Split('"') | Where-Object { $_.EndsWith(".csproj") }
        }
    }
}

function Get-HasPackageReference($path){
    $fileContent = Get-Content $path
    $containsReference = $fileContent | % { $_ -match 'PackageReference'  }
    return $containsReference
}
