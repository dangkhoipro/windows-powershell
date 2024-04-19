oh-my-posh init pwsh | Invoke-Expression
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

function Prompt {
  $loc = $executionContext.SessionState.Path.CurrentLocation;

  $out = ""
    if ($loc.Provider.Name -eq "FileSystem") {
      $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
    }
  $out += "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
  return $out
}

function go {
  param(
    [string]$AliasPath,
    [string]$Command
  )

  # Define aliases and their corresponding paths
  $aliases = @{
    "zsp" = "D:\z-social-plus-miniapp\"
    "zsp1" = "D:\z-social-plus-miniapp-copy\"
    "mb" = "d:/zalo-ads-mobile"
    "mb1" = "d:/zalo-ads-mobile-copy"
    "mp" = "d:/instant-page"
    "mp1" = "d:/instant-page-copy"
    "arc" = "d:/ads-review"
    "mock" = "D:\mock-server-zsp\"
    "nvim" = "~/appData/Local/my-nvim"
    "lazy" = "~/appData/Local/lazyvim/"
    "note" = "~/notes"
    "notew" = "~/notes/work"
    "notep" = "~/notes/personal/"
    "lazygit" = "~/appData/Roaming/lazygit/"
    "port" = "D:/personal-projects/portfolio"
    "admin" = "D:/zalo-ads-admin"
    "adv2" = "D:/zalo-ads-v2"
    # Add more aliases as needed
  }

  # Check if the alias exists in the aliases dictionary
  if ($aliases.ContainsKey($AliasPath)) {
    $Path = $aliases[$AliasPath]
      Set-Location -Path $Path

      if ($Command) {
        Invoke-Expression -Command $Command
      }
  } else {
    Write-Host "Alias not found."
  }
}

