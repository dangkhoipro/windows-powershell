oh-my-posh init pwsh | Invoke-Expression
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
# $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#   Import-Module "$ChocolateyProfile"
# }

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Import-Module PSFzf
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

# function Prompt {
#   $loc = $executionContext.SessionState.Path.CurrentLocation;
#
#   $out = ""
#     if ($loc.Provider.Name -eq "FileSystem") {
#       $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
#     }
#   $out += "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
#   return $out
# }

function parseAlias {
  param(
      [string]$AliasPath
      )

    $aliases = @{
      "zsp" = "D:\z-social-plus-miniapp\"
        "zsp2" = "D:\z-social-plus-miniapp-copy\"
        "mb" = "d:/zalo-ads-mobile"
        "mb2" = "d:/zalo-ads-mobile-copy"
        "mp" = "d:/instant-page"
        "mp2" = "d:/instant-page-copy"
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
        "mad" = "D:/new-new-mock-ads"
        "zad" = "D:/z-ad"
        "zad2" = "D:/z-ad-copy"
        "ps" = "~/Documents/Powershell"
        "hr" = "D:/zcloud/hr-fe"
        "hr2" = "D:/zcloud/hr-fe-copy"
        "hss" = "D:/zcloud/fintech-static"
        "had" = "D:/zcloud/fiza-hr-admin"
        "hbe" = "D:/zcloud/fiza-hr-be"
        "hlp" = "D:/zcloud/fiza-hr-website-landing-page"
        "hrmock" = "D:/zcloud/hr-mock-api"
        "hadmock" = "D:/zcloud/hr-admin-mock-api"
# Add more aliases as needed
    }

  if ($aliases.ContainsKey($AliasPath)) {
    $Path = $aliases[$AliasPath]
    $Path2 = $aliases[$AliasPath + "2"]

    return @($Path, $Path2)
  } else {
    return $null
  }
}

function go {
  param(
      [string]$AliasPath,
      [string]$Command
      )

  $Paths = parseAlias($AliasPath)

# Check if the alias exists in the aliases dictionary
  if ($Paths) {
    Set-Location -Path $Paths[0]

      if ($Command) {
        Invoke-Expression -Command $Command
      }
  } else {
    Write-Host "Alias not found."
  }
}

function init {
  param(
      [string]$AliasPath
      )

  $paths = parseAlias($AliasPath)

  if (!$paths) {
    Write-Host "Alias not found."
    return
  }

# open a new pane & set directory
  wt.exe -w 0 -d $paths[0] nvim `; sp -V -d $paths[0] lazygit `; sp -V -d $paths[1] `; mf -direction 8

  # move to the middle pane (lazygit)
  # direction left:1, right:2, first:8
  # wt -w 0 move-focus --direction 1
  # Invoke-Expression -Command "lazygit"
}

function fz {
    param (
        [string]$InitialDirectory = "."
    )

    # Change to the initial directory
    Set-Location $InitialDirectory
    $findDirectories = "fd --type d --max-depth 5"
    $findFiles = "fd --type f --max-depth 5"

    # Store the STDOUT of fzf in a variable
    $selection = & {
        $fzfOptions = @(
            '--multi', '--height=80%', '--border=sharp',
            '--preview', '', '--preview-window', '45%,border-sharp',
            '--prompt', 'Dirs > ',
            '--bind', 'del:execute(rm -ri {+})',
            '--bind', 'ctrl-u:toggle-preview',
            '--bind', 'ctrl-d:change-prompt(Dirs > )',
            '--bind', ('ctrl-d:+reload(' + $findDirectories + ')'),
            '--bind', 'ctrl-d:+change-preview()',
            '--bind', 'ctrl-d:+refresh-preview',
            '--bind', 'ctrl-f:change-prompt(Files > )',
            '--bind', ('ctrl-f:+reload(' + $findFiles + ')'),
            '--bind', 'ctrl-f:+change-preview(cat {})',
            '--bind', 'ctrl-f:+refresh-preview',
            '--bind', 'ctrl-a:select-all',
            '--bind', 'ctrl-x:deselect-all',
            '--header', @"
CTRL-D to display directories | CTRL-F to display files
CTRL-A to select all | CTRL-X to deselect all
ENTER to edit | DEL to delete
CTRL-U to toggle preview
"@
        )
        Invoke-Expression -Command $findDirectories | fzf @fzfOptions
    }

    # Determine what to do depending on the selection
    if (Test-Path $selection -PathType Container) {
        Set-Location $selection
    } else {
        # jump to file location before run command
        # Set-Location (Split-Path $selection -Parent)
        Invoke-Expression "nvim $selection"
    }
}
