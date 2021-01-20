BeforeAll { 
   . $PSScriptRoot/entrypoint.ps1
}

Describe "Get-HasPackageReference" {
    Context "When file does not contain a package reference" {
        BeforeEach{
            Mock Get-Content {return ""}
        }

        It "Builds the next version" {
            $result = Get-HasPackageReference "x:\test.sln"
            $result | Should -Be $false
        }
    }

    Context "When file does contain a package reference" {
        BeforeEach{
            Mock Get-Content {return '<PackageReference Include="Microsoft.AspNet.Mvc" Version="5.2.3" />'}
        }

        It "Builds the next version" {
            $result = Get-HasPackageReference "x:\test.sln"
            $result | Should -Be $true
        }
    }
}

Describe "Get-PathsContainingAProjectFile" {
    Context "When file does not contain projects" {
        BeforeEach{
            Mock Get-Content {return ""}
        }

        It "Builds the next version" {
            $result = Get-PathsContainingAProjectFile "x:\test.sln"
            $result | Should -Be $null
        }
    }

    Context "When file contais an empty project" {
        BeforeEach{
            Mock Get-Content {return 'Project("{2150E333-8FDC-42A3-9474-1A3956D46DE8}") = "www", "www", "{AF762FDB-C658-4745-BF55-87FCD1A074E7}'}
        }

        It "Builds the next version" {
            $result = Get-PathsContainingAProjectFile "x:\test.sln"
            $result | Should -Be $null
        }
    }

    Context "When file contais an empty project" {
        BeforeEach{
            Mock Get-Content {return 'Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "Website", "Website\Test.csproj", "{0AB1CEF2-B780-45E3-964B-F0F7674365D9}"'}
        }

        It "Builds the next version" {
            $result = Get-PathsContainingAProjectFile "x:\test.sln"
            $result | Should -Be "Website\Test.csproj"
        }
    }
}
