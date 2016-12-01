Function Invoke-Hangman
{
    [alias("Hangman")]
    Param
    (
        [Switch] $SuppressMusic
    )



    $VictoryMessage = "You're the Saviour!", "Thanks for saving my Life Human!", "You're my hero! you saved me." , "Your smartness saved my life." , "Sigh! I'm safe now." ,"Phew! Finally I'm down, Thanks!", "Awesome! Smarty."
    $LooserNote = "You've Killed me stupid human !!", "Next time atleast use some brain.", "I wish I was a cat they have 9 lives :(" , "I had faith in you, but your IQ is less than Zero", "You Kill people, You're a criminal!", "My Death is on you! Looser!!"

$Winner = @"
________________
   |         |
   |         |
   |
   |
   |        
   |        \0/
   |         |
___|____    //  ** $($VictoryMessage|random) 

"@
$start = @"
________________
   |         |
   |         |
   |
   |
   |         
   |        
   |        
___|____

"@
$Attempt1= @"
________________
   |         |
   |         |
   |         0
   |
   |
   |        
   |        
___|____

"@
$Attempt2= @"
________________
   |         |
   |         |
   |         0
   |        /|\
   |
   |
   |         
___|____

"@
$Attempt3= @"
________________
   |         |
   |         |
   |         0
   |        /|\
   |        // 
   |
   |         
___|____        ** $($LooserNote|random) 

"@



    $Attempt= @($Attempt1, $Attempt2, $Attempt3)

    $OriginalProgressPreference = $ProgressPreference 
    $ProgressPreference = 'silentlycontinue' # Suppressing Progress preference so that no progress appears when get-help runs
    
    #region GetRandomWord

        <# 
        Getting  a random word from Get-Help about* topics
        Hiding few random characters in the word to make people guess it
        #>

        $Word = Get-Help about* | %{$_.name -replace "about_" -split "_" -split "-"} |?{$_.length -gt 6} |select @{n='Word';e={$_}}, @{n='Length';e={$_.length}} -Unique |random
        $OriginalWord = $Question = $Word.word
        $IndexesToHide = ($Word.Length/2 - 1)
        
        1..$IndexesToHide | %{
            
            $Question = $Question -replace $Question[$(get-random -Minimum 1 -Maximum $IndexesToHide)] , '_'
        }
        
        $Question = "$($Question -split '')".Trim()

    #endregion GetRandomWord

    $ProgressPreference =  $OriginalProgressPreference # Rollback Progress Preference to original

    cls ; $start # Game Begins
    $BeepSharpness =  2
    $BeepDuration = 0.4

    For($i=0;$i -lt 3;$i++)
    {
        Write-host "Guess the following $($Word.length) Letter word, this is your $($i+1)/3 attempt :  " -NoNewline
        Write-Host $Question -ForegroundColor Yellow
        $answer = Read-Host "Your answer"
        
        if($OriginalWord -eq $answer)
        {
            $Winner
            Write-Host " WINNER " -BackgroundColor Yellow -ForegroundColor Black 
            If(-not $SuppressMusic)
            {
                [Console]::Beep(349*$BeepSharpness, 100)
                [Console]::Beep(466*$BeepSharpness, 100)
                [Console]::Beep(588*$BeepSharpness, 100)
                [Console]::Beep(699*$BeepSharpness, 100)
                [Console]::Beep(933*$BeepSharpness, 300)
                [Console]::Beep(933*$BeepSharpness, 100)
                [Console]::Beep(933*$BeepSharpness, 100)
                [Console]::Beep(933*$BeepSharpness, 100)
                [Console]::Beep(1047*$BeepSharpness, 400)
            }
            return
        }
        else
        {
            $Attempt[$i]
            If($i -lt 2)
            {
                Write-Host " ALIVE " -BackgroundColor Green -ForegroundColor Black 
            }
            else
            {
                Write-Host " DEAD " -BackgroundColor Red -ForegroundColor Black
                Write-Host "`nCORRECT WORD : " -NoNewline; Write-Host "$OriginalWord" -ForegroundColor Yellow
                
                If(-not $SuppressMusic)
                {
                    [console]::beep(659,500*$BeepDuration) 
                    [console]::beep(698,350*$BeepDuration) 
                    [console]::beep(523,150*$BeepDuration) 
                    [console]::beep(415,500*$BeepDuration) 
                    [console]::beep(349,350*$BeepDuration) 
                    [console]::beep(523,150*$BeepDuration) 
                    [console]::beep(440,1000*$BeepDuration)
                }
            }
        }
    
    }

}
