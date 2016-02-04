$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# While Core PowerShell does not support the JSON cmdlets, a third
# party C# library, [Json.NET](http://www.newtonsoft.com/json), can be
# loaded into PowerShell and used directly.

# http://www.newtonsoft.com/json/help/html/ParsingLINQtoJSON.htm

Describe "Json.NET LINQ Parsing" {
    # load third party Json.NET library
    if ([string]::IsNullOrEmpty($env:CORE_ROOT)) {
        $base = [System.AppContext]::BaseDirectory
    } else {
        $base = $env:CORE_ROOT
    }

    $path = Join-Path $base Newtonsoft.Json.dll
    [Microsoft.PowerShell.CoreCLR.AssemblyExtensions]::LoadFrom($path)

    BeforeEach {
        $jsonFile = "$here/assets/TestJson.json"
        $jsonData = (Get-Content $jsonFile | Out-String)
        $json = [Newtonsoft.Json.Linq.JObject]::Parse($jsonData)
    }

    It "Should return data via Item()" {
        [string]$json.Item("Name") | Should Be "Zaphod Beeblebrox"
    }

    It "Should return data via []" {
        [string]$json["Planet"] | Should Be "Betelgeuse"
    }

    It "Should return nested data via Item().Item()" {
        [int]$json.Item("Appendages").Item("Heads") | Should Be 2
    }

    It "Should return nested data via [][]" {
        [int]$json["Appendages"]["Arms"] | Should Be 3
    }

    It "Should return correct array count" {
        $json["Achievements"].Count | Should Be 4
    }

    It "Should return array data via [n]" {
        [string]$json["Achievements"][3] | Should Be "One hoopy frood"
    }
}