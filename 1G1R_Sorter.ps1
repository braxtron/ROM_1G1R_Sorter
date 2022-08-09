<#
1. Separate roms
2. Check EUR for any games on USA list and remove them
3. Check JPN for any games on USA or EUR list and remove them
4. profit
#>

# Doubles = multiple copies of a game in one region
# Duplicates = cross-region multiple copies

# Create working directories
New-Item -itemtype Directory -Name "USA"
New-Item -itemtype Directory -Name "EUR"
New-Item -itemtype Directory -Name "JPN"
New-Item -itemtype Directory -Name "Duplicates\USA"
New-Item -itemtype Directory -Name "Duplicates\EUR"
New-Item -itemtype Directory -Name "Duplicates\JPN"
New-Item -itemtype Directory -Name "Revisions\USA"
New-Item -itemtype Directory -Name "Revisions\EUR"
New-Item -itemtype Directory -Name "Revisions\JPN"
New-Item -itemtype Directory -Name "USA\Doubles"
New-Item -itemtype Directory -Name "EUR\Doubles"
New-Item -itemtype Directory -Name "JPN\Doubles"
New-Item -itemtype Directory -Name "BIOS"
New-Item -itemtype Directory -Name "Demos"
New-Item -itemtype Directory -Name "Betas"
New-Item -itemtype Directory -Name "Prototypes"
New-Item -itemtype Directory -Name "Unlicensed"
New-Item -itemtype Directory -Name "Other Regions"
New-Item -itemtype Directory -Name "Cheat Carts"
New-Item -itemtype Directory -Name "Unsorted"
New-Item -itemtype Directory -Name "Archives"

# Extract roms, move archives to archive directory
$GameZips = Get-ChildItem -Filter *.zip
foreach($GameZip in $GameZips) {
	Expand-Archive $GameZip -DestinationPath 'Unsorted'
	Move-Item -Path $GameZip -Destination 'Archives'
}

# Move roms to relevant folders
$Games = Get-ChildItem -Path 'Unsorted'
foreach($Game in $Games) {	
	$GameName = $Game.BaseName
	$SquishedName = ($GameName -replace '[\W]', '')
	
	if($GameName -like '*bios*') {
		Move-Item -Path "Unsorted\$Game" -Destination 'BIOS'
	}
	elseif($SquishedName -like '*actionreplay*' -OR $SquishedName -like '*gamegenie*' -OR $SquishedName -like '*gameshark*') {
		Move-Item -Path "Unsorted\$Game" -Destination 'Cheat Carts'
	}
	elseif($GameName -like '*(unl*') {
		Move-Item -Path "Unsorted\$Game" -Destination 'Unlicensed'
	}
	elseif($GameName -like '*(beta*') {
		Move-Item -Path "Unsorted\$Game" -Destination 'Betas'
	}
	elseif($GameName -like '*demo*' -OR $GameName -like '*sample*' -OR $GameName -like '*kiosk*') {
		Move-Item -Path "Unsorted\$Game" -Destination 'Demos'
	}
	elseif($GameName -like '*(proto*') {
		Move-Item -Path "Unsorted\$Game" -Destination 'Prototypes'
	}
	elseif($GameName -like '*(USA*') {
		Move-Item -Path "Unsorted\$Game" -Destination 'USA'
	}
	elseif($GameName -like '*(Eur*') {
		Move-Item -Path "Unsorted\$Game" -Destination 'EUR'
	}
	elseif($GameName -like '*japan*') {
		Move-Item -Path "Unsorted\$Game" -Destination 'JPN'
	}
	else{
		Move-Item -Path "Unsorted\$Game" -Destination "Other Regions"
	}	
}

# Remove empty directories
$Directories = Get-ChildItem -Directory
foreach($Directory in $Directories) {
	if(!(Test-Path "$Directory\*")) {
		Remove-Item $Directory
	}
}

############## Isolate USA Doubles ##############
$USAGames = Get-ChildItem -Path 'USA'
$USAGamesList = @()
$USADoubles = @()

foreach($Game in $USAGames) {
	$GameName = $Game.BaseName.split('(')[0].Trim() -replace '[\W]', ''
	if($USAGamesList -Contains $GameName) {
		$USADoubles += $GameName
	}
	else {
		$USAGamesList += $GameName
	}
}
foreach($Game in $USAGames) {
	$GameName = $Game.BaseName.split('(')[0].Trim() -replace '[\W]', ''
	if($USADoubles -Contains $GameName) {
		Move-Item -Path "USA\$Game" -Destination 'USA\Doubles'
	}
}

############## Isolate EUR Doubles ##############
$EURGames = Get-ChildItem -Path 'EUR'
$EURGamesList = @()
$EURDoubles = @()

foreach($Game in $EURGames) {
	$GameName = $Game.BaseName.split('(')[0].Trim() -replace '[\W]', ''
	if($EURGamesList -Contains $GameName) {
		$EURDoubles += $GameName
	}
	else {
		$EURGamesList += $GameName
	}
}

foreach($Game in $EURGames) {
	$GameName = $Game.BaseName.split('(')[0].Trim() -replace '[\W]', ''
	if($EURDoubles -Contains $GameName) {
		Move-Item -Path "EUR\$Game" -Destination 'EUR\Doubles'
	}
}


############## Isolate JPN Doubles ##############
$JPNGames = Get-ChildItem -Path 'JPN'
$JPNGamesList = @()
$JPNDoubles = @()

foreach($Game in $JPNGames) {
	$GameName = $Game.BaseName.split('(')[0].Trim() -replace '[\W]', ''
	if($JPNGamesList -Contains $GameName) {
		$JPNDoubles += $GameName
	}
	else {
		$JPNGamesList += $GameName
	}
}

foreach($Game in $JPNGames) {
	$GameName = $Game.BaseName.split('(')[0].Trim() -replace '[\W]', ''
	if($JPNDoubles -Contains $GameName) {
		Move-Item -Path "JPN\$Game" -Destination 'JPN\Doubles'
	}
}

############## Isolate Other Region Doubles ##############
$OtherGames = Get-ChildItem -Path 'Other Region'
$OtherGamesList = @()
$OtherDoubles = @()

foreach($Game in $OtherGames) {
	$GameName = $Game.BaseName.split('(')[0].Trim() -replace '[\W]', ''
	if($OtherGamesList -Contains $GameName) {
		$OtherDoubles += $GameName
	}
	else {
		$OtherGamesList += $GameName
	}
}

foreach($Game in $OtherGames) {
	$GameName = $Game.BaseName.split('(')[0].Trim() -replace '[\W]', ''
	if($OtherDoubles -Contains $GameName) {
		Move-Item -Path "Other Regions\$Game" -Destination 'Other Regions\Doubles'
	}
}

# Wait for user to handle the ddoubles/revisions situation
echo("Deal with the doubles/revisions and then press Enter")
$HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | OUT-NULL
$HOST.UI.RawUI.Flushinputbuffer()
echo("Good job fucker")

############## Get updated list of USA games ##############
$USAGames = Get-ChildItem -Path 'USA'
$USAGamesList = @()

foreach($Game in $USAGames) {
	$GameName = $Game.BaseName.split('(')[0].Trim() -replace '[\W]', ''
	$USAGamesList += $GameName
}

############## Find EUR games that already exist in USA ##############
$EURGames = Get-ChildItem -Path 'EUR'
$EURGamesList = @()

foreach($Game in $EURGames) {
	$GameName = $Game.BaseName.split('(')[0].Trim() -replace '[\W]', ''
	if($USAGamesList -Contains $GameName) {
		Move-Item -Path "EUR\$Game" -Destination "Duplicates\EUR"
	}
	else{
		$EURGamesList += $GameName
	}
}

############## Find JPN games that already exist in USA ##############
$JPNGames = Get-ChildItem -Path 'JPN'
$JPNGamesList = @()

foreach($Game in $JPNGames) {
	$GameName = $Game.BaseName.split('(')[0].Trim() -replace '[\W]', ''
	if($USAGamesList -Contains $GameName -OR $EURGames -Contains $GameName) {
		Move-Item -Path "JPN\$Game" -Destination "Duplicates\JPN"
	}
	else{
		$JPNGamesList += $GameName
	}
}

start-sleep -Seconds 2 #Sometimes the script is too fast for its own good

if(!(Test-Path "USA\Doubles\*")) {
		Remove-Item "USA\Doubles"
}
if(!(Test-Path "EUR\Doubles\*")) {
		Remove-Item "EUR\Doubles"
}
if(!(Test-Path "JPN\Doubles\*")) {
		Remove-Item "JPN\Doubles"
}

if(!(Test-Path "Duplicates\USA\*")) {
		Remove-Item "Duplicates\USA\"
}
if(!(Test-Path "Duplicates\EUR\*")) {
		Remove-Item "Duplicates\EUR\"
}
if(!(Test-Path "Duplicates\JPN\*")) {
		Remove-Item "Duplicates\JPN\"
}

if(!(Test-Path "Revisions\USA\*")) {
		Remove-Item "Revisions\USA\"
}
if(!(Test-Path "Revisions\EUR\*")) {
		Remove-Item "Revisions\EUR\"
}
if(!(Test-Path "Revisions\JPN\*")) {
		Remove-Item "Revisions\JPN\"
}

echo("We did it, yay. Any duplicates in different languages remain...")
