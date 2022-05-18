$bases = @{}
$csv = Import-Csv -Delimiter ',' -Path .\1c-bases.csv
foreach ($row in $csv) {
    $bases[$row.name]=$row.path
}

function New-FileName {
    param (
        [Parameter()]
        [string]
        $baseName
    )
    $fileName = $baseName.ToLower()
    $fileName = $fileName -replace ' ', '_'
    return $fileName

        
}

function New-BasesConfig {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $baseName,
        # Parameter help description
        [Parameter()]
        [string]
        $basePath,
        # 
        [Parameter()]
        [hashtable]
        $bases
    )

    $template = '.\ibases.v8i.template'
    $i = 0

    foreach ($base in $bases.GetEnumerator() ) {
        $i += 1
        $configFile = New-FileName -baseName $base.key
        $configFile = '.\' + $configFile
        Copy-Item $template -Destination $configFile
        $config = Get-Content -Path $configFile -Raw
        $baseNamePattern = '#baseName#'
        $basePathPattern = '#basePath#'
        $config = $config -replace $baseNamePattern, $base.key
        $config = $config -replace $basePathPattern, $base.Value
        Set-Content -Path $configFile -Value $config

    }
    
}

New-BasesConfig -bases $bases