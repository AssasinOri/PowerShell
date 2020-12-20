function global:set-cursorposition ($x,$y) {
    [console]::CursorLeft = $x
    [console]::CursorTop = $y
}

function global:draw-symbol ($x,$y,$symbol) {
    set-cursorposition $x $y
    Write-Host $symbol -NoNewline
}
$windowWidth = [console]::WindowWidth - 1
$WindowHeight = [console]::WindowHeight - 1
[console]::CursorVisible = $false

function draw-snake ($snake) {
    for ($i=0;$i -lt $snake.count;$i++) {
        draw-symbol $snake[$i][$x] $snake[$i][$y] "*" 
    }
}

$xArrow = 0
$yArrow = 0

$xx = Get-Random -Minimum 0 -Maximum $windowWidth
$yy = Get-Random -Minimum 0 -Maximum $WindowHeight

$xbomb = Get-Random -Minimum 0 -Maximum $windowWidth
$ybomb = Get-Random -Minimum 0 -Maximum $WindowHeight

$x = 0
$y = 1
#$snake = @(@([math]::round($windowWidth/2),[math]::round($WindowHeight/2)))
$snake = @(0)
$snake[0] = @(@(50,10))
Clear-Host
$snakespeedchange = 10
$snakespeed = 150 #milliseconds
$keypressed = "RightArrow" #right direction
$OldArrow = $keypressed
while ($true) {
    #draw snake
    draw-symbol $xx $yy "@"
    draw-symbol $xbomb $ybomb "#"
    while (-not [Console]::KeyAvailable) {
        Start-Sleep -Milliseconds $snakespeed
        #erase last snake element
        draw-snake $snake
        draw-symbol 0 0 $snake
        draw-symbol 0 1 $snake.count
        switch ($keypressed) {
            "UpArrow" {
                for ($i=0;$i -lt $snake.count;$i++) {
                    if ($snake[$i][$x] -eq $xArrow){
                        if ($snake[$i][$y] -gt 0) {$snake[$i][$y]=$snake[$i][$y]-1}
                    }
                }
            }
            "DownArrow" {
                for ($i=0;$i -lt $snake.count;$i++) {
                    if ($snake[$i][$x] -eq $xArrow){
                        if ($snake[$i][$y] -lt $WindowHeight) {$snake[$i][$y]=$snake[$i][$y]+1}
                    }
                }
            }              
            "RightArrow" {
                for ($i=0;$i -lt $snake.count;$i++) {
                    if ($snake[$i][$y] -eq $yArrow){
                        if ($snake[$i][$x] -lt $windowWidth) {$snake[$i][$x]=$snake[$i][$x]+1}
                    }
                }
            }
            "LeftArrow" {
                for ($i=0;$i -lt $snake.count;$i++) {
                    if ($snake[$i][$y] -eq $yArrow){
                        if ($snake[$i][$x] -gt 0) {$snake[$i][$x]=$snake[$i][$x]-1}
                    }
                }
            }      
        } #switch keypressed
        draw-snake $snake
#        draw-symbol $snake[$snake.Count-1][$x] $snake[$snake.Count-1][$y] " "
        if ($snake[0][$y] -eq $yy -and $snake[0][$x] -eq $xx) {
            if ($snakespeed -gt $snakespeedchange){
                $snakespeed = $snakespeed - $snakespeedchange            
                $snake += 0
                switch ($keypressed) {
                    "UpArrow"       {$snake[$snake.count-1] = @($xx,($yy+$snake.count-1))}
                    "DownArrow"     {$snake[$snake.count-1] = @($xx,($yy-$snake.count-1))}
                    "LeftArrow"     {$snake[$snake.count-1] = @(($xx+$snake.count-1),$yy)}
                    "RightArrow"    {$snake[$snake.count-1] = @(($xx-$snake.count-1),$yy)}
                }
                $xx = Get-Random -Minimum 0 -Maximum $windowWidth
                $yy = Get-Random -Minimum 0 -Maximum $WindowHeight
                draw-symbol $xx $yy "@"
            }
        }
<#        if ($y -eq $ybomb -and $x -eq $xbomb) {
            draw-symbol $xbomb $ybomb "!"
#            set-cursorposition $WindowWidth/2-5 $WindowHeight/2
#            [System.Console]::BackgroundColor = "red"
            draw-symbol 0 0 "game over"
            sleep 5
            exit
        }
        if ($y -eq 0 -or $y -eq $WindowHeight -or $x -eq 0 -or $x -eq $windowWidth){  
            draw-symbol 10 10 "game over"
            sleep 5
            exit
        } #>
    } #while keyAvailable
    $OldArrow = $keypressed
    $keypressed = ([Console]::ReadKey($true)).key
    $xArrow = $snake[0][$x]
    $yArrow = $snake[0][$y]
    draw-symbol 0 20 $keypressed
}