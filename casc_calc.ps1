# 
# Powershell skisse av kaskadekalkulatoren som forhåpentligvis blir en webapp
# cascade_calc.ps1
# cascade gas calculation
# Definer gjeldene trykk på banken, kan evt hentes automatisk eller tastes inn på forhånd...
#

$bank = @(4, 15, 90, 120, 200, 200)

[int]$cylinderVol = Read-Host 'Flaske størrelsen i liter (eks 24)'
$cylinderBar = 1
[int]$fillPressure = Read-Host 'Ønsket He trykk i Bar'
$pressure = 0
$i = 0
[bool]$status = $true

#
# P3 = (P1×V1+P2×V2)/(V1+V2)
# om potensielt fylletrykk er mindre en ønsket trykk, utgjevnt trykket...
# 
while($pressure -lt $fillPressure){
	$pressure = (($bank[$i]*50)+($cylinderVol*$cylinderBar))/($cylinderVol+50)

	if($pressure -lt $fillPressure){
		$bank[$i] = $pressure
		$cylinderBar = $pressure
		if($i -lt $bank.GetUpperBound(0)){
			$i++
		}

# 
# Om fyllingen krever flere flasker en vi har definert, vil ikke fyllingen være mulig.
#
		else{
			write-host "Mix ikke mulig, da trykket wil bli for lavt på den siste bankflasken" $i $bank[$i] "ønsket trykk er: $fillPressure"
			[bool]$status = $false
			return
		}
	}
}

if($status){
	$bank[$i] = $bank[$i] - (($cylinderVol*($fillPressure - $cylinderBar))/50)

	write-host "Flasken er fylt til $fillPressure og trykket på banken er følgende:"

	while($i -ge 0){
		write-host "bankflaske" $i $bank[$i]
		$i--
	}
}
