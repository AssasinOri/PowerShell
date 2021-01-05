function draw-borders ($x1,$y1,$x2,$y2) {
    [char]9556+"$([char]9552)"*30+[char]9559+"`n"+[char]9553+"`n"+[char]9553+"`n"+[char]9562+"$([char]9552)"*30+[char]9565
}
function global:set-cursorposition ($x,$y) {
    [console]::CursorLeft = $x
    [console]::CursorTop = $y
}
function global:draw-symbol ($x,$y,$symbol) {
    set-cursorposition $x $y
    Write-Host $symbol -NoNewline
}
function draw-snake ($snake) {
    for ($i=0;$i -lt $snake.count;$i++) {
        draw-symbol $snake[$i][$x] $snake[$i][$y] "*" 
    }
}
function Set-ArrowArray ($ArrowArray) {
    for ($i = $ArrowArray.Count-1; $i -gt 0; $i--) {
        $ArrowArray[$i] = $ArrowArray[$i-1]
    }    
}

function gameover {
    set-cursorposition ([int][math]::round($windowWidth/2)-4) ([int][math]::round($WindowHeight/2))
    [System.Console]::BackgroundColor = "red"
    Write-Host "Game over" -NoNewline
    sleep 5
    exit
}

$windowWidth = [console]::WindowWidth - 1
$WindowHeight = [console]::WindowHeight - 1
[console]::CursorVisible = $false

#Set coordinates of @ element
$xx = Get-Random -Minimum 0 -Maximum $windowWidth
$yy = Get-Random -Minimum 0 -Maximum $WindowHeight

#Set coordinates of # element (bomb)
$xbomb = Get-Random -Minimum 0 -Maximum $windowWidth
$ybomb = Get-Random -Minimum 0 -Maximum $WindowHeight

#Initialize the first element of snake array 
$snake = @()
$snake += ,(@([int][math]::round($windowWidth/2),[int][math]::round($WindowHeight/2)))
#set indexes of x and y in snake array
$x = 0
$y = 1

Clear-Host
#set speed of snake
$snakespeed = 150 #milliseconds

#Initialize first direction
$keypressed = "RightArrow" #right direction
$ArrowArray = @()
$ArrowArray += $keypressed
while ($true) {
    draw-symbol $xx $yy "@"
    draw-symbol $xbomb $ybomb "#"
    if ( [Console]::KeyAvailable) {
        $keypressed = ([Console]::ReadKey($true)).key
    }
    if ($keypressed -eq "UpArrow" -or $keypressed -eq "DownArrow" -or $keypressed -eq "LeftArrow" -or $keypressed -eq "RightArrow") {
        if ($ArrowArray.count -gt 1){
            if ($ArrowArray[0] -eq "RightArrow" -and $keypressed -eq "LeftArrow"){gameover}
            if ($ArrowArray[0] -eq "LeftArrow" -and $keypressed -eq "RightArrow"){gameover}
            if ($ArrowArray[0] -eq "UpArrow" -and $keypressed -eq "DownArrow"){gameover}
            if ($ArrowArray[0] -eq "DownArrow" -and $keypressed -eq "UpArrow"){gameover}
        }
        Set-ArrowArray $ArrowArray
        $ArrowArray[0] = $keypressed
    }
    Start-Sleep -Milliseconds $snakespeed
    #helping code
    draw-symbol 0 0 $snake
    draw-symbol 0 1 $snake.count
    draw-symbol 0 2 $ArrowArray
    draw-symbol 0 3 $keypressed
    $lastSnakeElementX = $snake[$snake.Count-1][$x]
    $lastSnakeElementY = $snake[$snake.Count-1][$y]
    for ($i = 0; $i -lt $snake.Count; $i++) {
        switch ($ArrowArray[$i]) {
            "UpArrow" {
                if ($snake[$i][$y] -gt 0) {$snake[$i][$y]=$snake[$i][$y]-1}
            }
            "DownArrow" {
                if ($snake[$i][$y] -lt $WindowHeight) {$snake[$i][$y]=$snake[$i][$y]+1}
            }              
            "RightArrow" {
                if ($snake[$i][$x] -lt $windowWidth) {$snake[$i][$x]=$snake[$i][$x]+1}    
            }
            "LeftArrow" {
                if ($snake[$i][$x] -gt 0) {$snake[$i][$x]=$snake[$i][$x]-1}
            }      
        } #switch keypressed
        if ($i -gt 0) {
            if (($snake[0][$x] -eq $snake[$i][$x])-and($snake[0][$y] -eq $snake[$i][$y])){gameover}
        }
    } #for $snake
    draw-snake $snake
    draw-symbol $lastSnakeElementX $lastSnakeElementY " "
    # If snake get into the @
    if ($snake[0][$y] -eq $yy -and $snake[0][$x] -eq $xx) {
        if ($snakespeed -gt [int][math]::round($snakespeed/10)){
            $snakespeed = $snakespeed - [int][math]::round($snakespeed/10)
        }           
        $snake += ,(@($lastSnakeElementX,$lastSnakeElementY))
        if ($keypressed -eq "UpArrow" -or $keypressed -eq "DownArrow" -or $keypressed -eq "LeftArrow" -or $keypressed -eq "RightArrow") {
            $ArrowArray += $ArrowArray[$ArrowArray.count-1]
        }
        $xx = Get-Random -Minimum 0 -Maximum $windowWidth
        $yy = Get-Random -Minimum 0 -Maximum $WindowHeight
        draw-symbol $xx $yy "@"
    }
    # If snake get into the Bomb #
    if ($snake[0][$y] -eq $ybomb -and $snake[0][$x] -eq $xbomb) {
        draw-symbol $xbomb $ybomb "!"
        gameover
    }
<#    if ($y -eq 0 -or $y -eq $WindowHeight -or $x -eq 0 -or $x -eq $windowWidth){  
        draw-symbol 10 10 "game over"
        sleep 5
        exit
    } #>
}