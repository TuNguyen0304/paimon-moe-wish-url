<#
.SYNOPSIS
  This script extracts the latest wish URL from Genshin Impact ($([char]0x539f)$([char]0x795e)) cache file.
.DESCRIPTION
  Usage:
  1. Run Genshin Impact and open the "Wish History" page at least once.
  2. Run this script to extract the latest wish URL from the cache file.
  3. The wish URL will be copied to the clipboard.
.EXAMPLE
  # On Windows
  PS C:\Users\Alice> .\Get-WishUrl.ps1
.NOTES
  Version:  0.14.0
  Author:   jogerj
  License:  MIT
#>

function Get-ValidatedWishUrl {
  param (
    [string]$WishUrl
  )
  # Character wish banner, latest 5 pulls
  $WishUrl = "$WishUrl&page=1&size=5&gacha_type=301"
  # If webpage, rewrite URL to call API directly
  if ($WishUrl -match "hk4e_global") {
    # Global
    $WishUrl = $WishUrl -replace "https:\/\/gs.hoyoverse.com.+html\?", "https://public-operation-hk4e-sg.hoyoverse.com/gacha_info/api/getGachaLog?"
  }
  else {
    # CN
    $WishUrl = $WishUrl -replace "https:\/\/webstatic.+html\?", "https://public-operation-hk4e.mihoyo.com/gacha_info/api/getGachaLog?"
  }

  # Only send the extracted URL to known official wish-history hosts and paths.
  try {
    $parsedWishUrl = [System.Uri]::new($WishUrl)
  }
  catch {
    Write-Host "The extracted wish URL is malformed and will not be requested." -ForegroundColor Red
    return $null
  }
  $allowedHosts = @(
    "public-operation-hk4e-sg.hoyoverse.com",
    "public-operation-hk4e.mihoyo.com",
    "hk4e-api-os.hoyoverse.com",
    "hk4e-api.mihoyo.com"
  )
  $allowedPaths = @(
    "/gacha_info/api/getGachaLog",
    "/event/gacha_info/api/getGachaLog"
  )
  if (
    $parsedWishUrl.Scheme -ne "https" -or
    -not $parsedWishUrl.IsDefaultPort -or
    $parsedWishUrl.UserInfo -ne "" -or
    $parsedWishUrl.Fragment -ne "" -or
    $allowedHosts -notcontains $parsedWishUrl.DnsSafeHost.ToLowerInvariant() -or
    $allowedPaths -notcontains $parsedWishUrl.AbsolutePath -or
    $parsedWishUrl.Query -notmatch "(?:\?|&)game_biz=hk4e_(?:global|cn)(?:&|$)"
  ) {
    Write-Host "The extracted URL is not an official Genshin wish-history URL and will not be requested." -ForegroundColor Red
    return $null
  }

  # Check validity
  try {
    $urlResponse = Invoke-RestMethod -URI $WishUrl -ContentType 'application/json' -Method Get -MaximumRedirection 0
    # Test OK
    if ($urlResponse.message -ne "OK") {
      Write-Host "URL found but it is expired/invalid! Open `"Wish History`" page again to fetch a new URL!" -ForegroundColor Yellow
      return $null
    }
    return $WishUrl
  }
  catch {
    Write-Host "Could not validate wish URL! Make sure you have a working internet connection." -ForegroundColor Red
    return $null
  }
}

function Get-GenshinLogPath {
  $logPathGlobal = [System.Environment]::ExpandEnvironmentVariables("%userprofile%/AppData/LocalLow/miHoYo/Genshin Impact/output_log.txt")
  $logPathChina = [System.Environment]::ExpandEnvironmentVariables("%userprofile%/AppData/LocalLow/miHoYo/$([char]0x539f)$([char]0x795e)/output_log.txt")
  $globalExists = Test-Path $logPathGlobal
  $cnExists = Test-Path $logPathChina

  function Write-FoundGlobal { Write-Host "Found Genshin Impact (Global) log file!" -ForegroundColor Green }
  function Write-FoundCN { Write-Host "Found $([char]0x539f)$([char]0x795e) (CN) log file!" -ForegroundColor Green }

  if ($globalExists) {
    if ($cnExists) {
      # both exists, pick newest one
      if ((Get-Item $logPathGlobal).LastWriteTime -ge (Get-Item $logPathChina).LastWriteTime) {
        Write-FoundGlobal
        return $logPathGlobal
      }
      else {
        Write-FoundCN
        return $logPathChina
      }
    }
    else {
      Write-FoundGlobal
      return $logPathGlobal
    }
  }
  else {
    if ($cnExists) {
      Write-FoundCN
      return $logPathChina
    }
    else {
      return $null
    }
  }
}



function Get-LatestCacheSegment {
  param (
    [string]$Path
  )

  $share = [System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete
  $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, $share)
  $reader = [System.IO.StreamReader]::new($stream, [System.Text.Encoding]::UTF8, $true)
  $buffer = New-Object 'char[]' 65536
  $carry = ''
  $latestSegment = ''
  $hasSeparator = $false
  $maxSegmentLength = 262144

  try {
    while (($charactersRead = $reader.Read($buffer, 0, $buffer.Length)) -gt 0) {
      $currentChunk = [string]::new($buffer, 0, $charactersRead)
      $combined = $carry + $currentChunk
      $separatorIndex = $combined.LastIndexOf('1/0/', [System.StringComparison]::Ordinal)

      if ($separatorIndex -ge 0) {
        $latestSegment = $combined.Substring($separatorIndex + 4)
        $hasSeparator = $true
      }
      elseif ($hasSeparator -and $latestSegment.Length -lt $maxSegmentLength) {
        $latestSegment += $currentChunk
      }

      if ($latestSegment.Length -gt $maxSegmentLength) {
        # The URL starts after the marker. Cache padding can extend far beyond it.
        $latestSegment = $latestSegment.Substring(0, $maxSegmentLength)
      }

      $carry = if ($combined.Length -gt 3) { $combined.Substring($combined.Length - 3) } else { $combined }
    }
  }
  finally {
    $reader.Dispose()
  }

  if ($hasSeparator) {
    return $latestSegment
  }
  return $null
}

function Get-GenshinWishUrl {
  $LogPath = Get-GenshinLogPath
  if (-not $LogPath) {
    Write-Host "Cannot find Genshin Impact log file! Make sure to run Genshin Impact and open the wish history at least once!" -ForegroundColor Red
    Write-Host "This utility reads files in your user profile and does not require Administrator privileges." -ForegroundColor DarkCyan
    return $null
  }

  $GameDataPathRegexPattern = ".:/.+(GenshinImpact_Data|YuanShen_Data)"
  $LogMatch = Select-String -Path $LogPath -Pattern $GameDataPathRegexPattern | Select-Object -Last 1

  if (-not $LogMatch) {
    Write-Host "Cannot find Genshin Impact path in log file! Make sure to run Genshin Impact and open the wish history at least once!" -ForegroundColor Red
    Pause
    return $null
  }

  $null = $LogMatch.Line -match $GameDataPathRegexPattern
  $GameDataPath = $Matches[0]
  $CacheFolderPath = "$GameDataPath/webCaches"
  try {
    if (Test-Path "$CacheFolderPath") {
      Write-Host "Cache folder found! Trying to extract latest cache file..." -ForegroundColor Green
      try {
        $cacheVerPath = Get-Item (Get-ChildItem -Path "$GameDataPath/webCaches" | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
        $cachePath = "$cacheVerPath/Cache/Cache_Data/data_2"

        if (-not (Test-Path $cachePath)) {
          Write-Host "The latest cache folder has no Cache_Data/data_2 file. Open Wish History and wait for the list to load." -ForegroundColor Yellow
          return
        }

        # check cache not older than 2 days
        if ((Get-Item $cachePath).LastWriteTime -le $(Get-Date).AddDays(-2)) {
          Write-Host "The wish cache is more than two days old. Open Wish History to update it." -ForegroundColor Yellow
          return
        }

        $latestCacheSegment = Get-LatestCacheSegment -Path $cachePath
        $found = $latestCacheSegment -match "https.+?game_biz=hk4e_(global|cn)"
        if ($found) {
          $cacheVer = Split-Path $cacheVerPath -Leaf
          Write-Host "Wish URL file found in $cacheVer cache! Validating wish URL..." -ForegroundColor Green
          $wishUrl = Get-ValidatedWishUrl $Matches[0]
          if ($wishUrl) {
            Write-Host "Wish URL validated!" -ForegroundColor Green
            Set-Clipboard -Value $WishUrl
            Write-Host "URL copied to clipboard, paste it on any Genshin Impact ($([char]0x539f)$([char]0x795e)) wish tracker. Keep the link private." -ForegroundColor Green
            return $null
          }
          return
        }
        Write-Host "The cache was read but contains no matching wish URL. Reopen Wish History." -ForegroundColor Yellow
      }
      catch {
        Write-Host "The local cache could not be read safely." -ForegroundColor Yellow
        Write-Host "Reopen Wish History in the game, then try again." -ForegroundColor Yellow
      }
    }
    else {
      throw "Cache folder was not found! Please restart Genshin Impact and reopen `"Wish History`"!"
    }
  }
  catch {
    Write-Host "The wish URL could not be retrieved from the local game data." -ForegroundColor Red
    Pause
  }
  return $null
}

# Run the script
Get-GenshinWishUrl
