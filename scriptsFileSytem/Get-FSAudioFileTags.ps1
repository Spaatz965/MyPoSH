<#
	Leverages taglib-sharp.dll from http://download.banshee.fm/taglib-sharp/
	Original inspiration: http://www.toddklindt.com/blog/Lists/Posts/Post.aspx?ID=468
#>



$tagfile = "C:\program files\SysinternalsSuite\taglib-sharp.dll"
[system.reflection.assembly]::loadfile($tagfile) | Out-Null

$musicfiles = (Get-ChildItem -Include *.mp3,*.m4a,*.m4p,*.wav -Recurse | Select-Object name,creationtime,directoryname,extension,fullname,lastaccesstime,lastwritetime,length)

foreach ($musicfile in $musicfiles) {
    $media = [TagLib.File]::Create($musicfile.fullname)
    $tag = ($media.tag.tags[0] | where-object {$_ -is [TagLib.Id3v2.PopularimeterFrame]})

    if ( $tag ) {
        $rating = $tag.rating
    }

    $Properties = @{
        'FileName'               = $musicfile.name
        'FileCreated'            = $musicfile.creationtime
        'FileExtension'          = $musicfile.extension
        'FileFullName'           = $musicfile.fullname
        'DirectoryName'          = $musicfile.directoryname
        'FileLastAccess'         = $musicfile.lastaccesstime
        'FileLastWrite'          = $musicfile.lastwritetime
        'FileSize'               = $musicfile.length
        'FileTagTypes'           = $media.tag.TagTypes
        'FileTitle'              = $media.tag.Title
        'FilePerformers'         = $media.tag.Performers -join ";"
        'FileAlbumArtists'       = $media.tag.AlbumArtists -join ";"
        'FileComposers'          = $media.tag.Composers -join ";"
        'FileAlbum'              = $media.tag.Album
        'FileComment'            = $media.tag.Comment
        'FileGenres'             = $media.tag.Genres -join ";"
        'FileYear'               = $media.tag.Year
        'FileTrack'              = $media.tag.Track
        'FileTrackCount'         = $media.tag.TrackCount
        'FileDisc'               = $media.tag.Disc
        'FileDiscCount'          = $media.tag.DiscCount
        'FileBeatsPerMinute'     = $media.tag.BeatsPerMinute
        'FileCopyright'          = $media.tag.Copyright
        'FileArtists'            = $media.tag.Artists -join ";"
        'FileFirstArtist'        = $media.tag.FirstArtist
        'FileFirstAlbumArtist'   = $media.tag.FirstAlbumArtist
        'FileFirstPerformer'     = $media.tag.FirstPerformer
        'FileFirstComposer'      = $media.tag.FirstComposer
        'FileFirstGenre'         = $media.tag.FirstGenre
        'FileJoinedArtists'      = $media.tag.JoinedArtists
        'FileJoinedAlbumArtists' = $media.tag.JoinedAlbumArtists
        'FileJoinedPerformers'   = $media.tag.JoinedPerformers
        'FileJoinedComposers'    = $media.tag.JoinedComposers
        'FileJoinedGenres'       = $media.tag.JoinedGenres
        'FileDuration'           = $media.properties.Duration
        'FileDescription'        = $media.properties.Description
        'FileAudioBitrate'       = $media.properties.AudioBitrate
        'FileAudioSampleRate'    = $media.properties.AudioSampleRate
        'FileBitsPerSample'      = $media.properties.BitsPerSample
        'FileAudioChannels'      = $media.properties.AudioChannels
        'FileRating'             = $rating
    }
    $output = New-Object -TypeName PSObject -Property $properties
    Write-Output $output
}

