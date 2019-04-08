Function VideoMerge {
    $fileArray = New-Object System.Collections.ArrayList
    $items = Get-childitem *.mkv,*.vob,*.mp4,*.ts
    $itemCount = $items.Count
    $i = 0
    $cmdScript = ""

    ForEach ($item in $items){
        $i++
        $cmdScript += "ffmpeg -i `"$($item.Name)`" -f mpegts -c copy file-0$i.mpeg.ts`n"
        $fileArray.Add("file-0$i.mpeg.ts")
    }
    
    ForEach ($file in $fileArray){
   
    $cmdScript+="ffmpeg -isync -i `"concat:$($fileArray -join '|')`" -c copy output.mp4"
    
    Invoke-Expression $cmdScript

    rm *.mpeg.ts
    }
}

Function FadeEffect {
$videos = Get-childitem *.mp4
ForEach ($video in $videos){
        $outFile_NoExt = (Get-Item $video).BaseName
        $fadeEffect=ffmpeg -i $video -sseof -1 -copyts -i $video -filter_complex "[1]fade=out:0:30[t];[0][t]overlay,fade=in:0:30[v]; anullsrc,atrim=0:1[at];[0][at]acrossfade=d=0,afade=d=0[a]" -map "[v]" -map "[a]" -c:v libx264 -crf 22 -preset veryfast -shortest $outFile_NoExt`_tmp.mp4
        mkdir bak
        mv $video bak/
        mv $outFile_NoExt`_tmp.mp4 $video
    }
}

Function VideoTrim ([string]$arg1, [string]$arg2, [string]$arg3, [string]$arg4) {
    #$inputVid = Read-Host -Prompt "input video file"
    $inputVid = echo `"$arg1`"
    $outputVid = Split-Path -Parent $inputVid
    $outputVid += echo "\"
    $outputVid += echo "Trimmed\"
    #$outputVid += Read-Host -Prompt "output video name"
    $outputVid += echo "$arg2"
    $outputVid += echo "`""
    #$startOffset = Read-Host -Prompt "start offset"
    $startOffset = echo "$arg3"
    #$videoDuration = Read-Host -Prompt "video duration"
    $videoDuration = echo "$arg4"
    Invoke-Expression "ffmpeg.exe -ss 00:$startOffset -t 00:$videoDuration -i $inputVid -r 60 -s 1280x720 $outputVid"
    }