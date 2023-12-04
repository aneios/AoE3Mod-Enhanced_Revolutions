# Allowed Missing Animations.xml
$animationsFile = '$HOME\Games\Age of Empires 3 DE\76561198043389070\mods\local\enhanced revolutions\Data\Allowed Missing Animations.xml'
$animationsNode = [xml](Get-Content $animationsFile)

foreach ($element in $animationsNode.SelectNodes("//unit[contains(@name, 'Repentant')]")) {
	$element.ParentNode.RemoveChild($element)
}

$animationsNode.Save($animationsFile)

# attacktime.xml
$attacksFile = '$HOME\Games\Age of Empires 3 DE\76561198043389070\mods\local\enhanced revolutions\Data\attacktime.xml'
$attacksNode = [xml](Get-Content $attacksFile)

foreach ($element in $attacksNode.SelectNodes("//unit[contains(@name, 'Repentant')]")) {
	$element.ParentNode.RemoveChild($element)
}

$attacksNode.Save($attacksFile)

# protoy.xml
$protoFile = '$HOME\Games\Age of Empires 3 DE\76561198043389070\mods\local\enhanced revolutions\Data\protoy.xml'
$protoNode = [xml](Get-Content $protoFile)

foreach ($element in $protoNode.SelectNodes("//unit[contains(@name, 'Repentant')]")) {
	$element.ParentNode.RemoveChild($element)
}

$protoNode.Save($protoFile)

# unithelpy.xml
$unithelpFile = '$HOME\Games\Age of Empires 3 DE\76561198043389070\mods\local\enhanced revolutions\Data\unithelpy.xml'
$unithelpNode = [xml](Get-Content $unithelpFile)

foreach ($element in $unithelpNode.SelectNodes("//entry[contains(@protoname, 'Repentant')]")) {
	$element.ParentNode.RemoveChild($element)
}

$unithelpNode.Save($unithelpFile)

# techtreedata_asians.xml
$techtree_asians = @('$HOME\Games\Age of Empires 3 DE\76561198043389070\mods\local\enhanced revolutions\Data\uitechtree\techtreedata_chinese.xml',
	'$HOME\Games\Age of Empires 3 DE\76561198043389070\mods\local\enhanced revolutions\Data\uitechtree\techtreedata_indians.xml',
	'$HOME\Games\Age of Empires 3 DE\76561198043389070\mods\local\enhanced revolutions\Data\uitechtree\techtreedata_japanese.xml')

foreach ($file in $techtree_asians) {
	$techtreeNode = [xml](Get-Content $file)

	$element = $techtreeNode.SelectSingleNode("//proto[@name='deRepentantHarquebusier']")
	if ($element) {
		$element.SetAttribute("name", "deMercHarquebusier")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantArsonist']")
	if ($element) {
		$element.SetAttribute("name", "ypMercArsonist")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantBarbaryCorsair']")
	if ($element) {
		$element.SetAttribute("name", "MercBarbaryCorsair")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantBlackRider']")
	if ($element) {
		$element.SetAttribute("name", "MercBlackRider")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantBlindMonk']")
	if ($element) {
		$element.SetAttribute("name", "ypWokouBlindMonk")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantDacoit']")
	if ($element) {
		$element.SetAttribute("name", "ypDacoit")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantElmeti']")
	if ($element) {
		$element.SetAttribute("name", "MercElmeti")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantFusilier']")
	if ($element) {
		$element.SetAttribute("name", "MercFusilier")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantGreatCannon']")
	if ($element) {
		$element.SetAttribute("name", "MercGreatCannon")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantHackapell']")
	if ($element) {
		$element.SetAttribute("name", "MercHackapell")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantHighlander']")
	if ($element) {
		$element.SetAttribute("name", "MercHighlander")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantIronTroop']")
	if ($element) {
		$element.SetAttribute("name", "ypMercIronTroop")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantJaeger']")
	if ($element) {
		$element.SetAttribute("name", "MercJaeger")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantJatLancer']")
	if ($element) {
		$element.SetAttribute("name", "ypMercJatLancer")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantLandsknecht']")
	if ($element) {
		$element.SetAttribute("name", "MercLandsknecht")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantMameluke']")
	if ($element) {
		$element.SetAttribute("name", "MercMameluke")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantManchu']")
	if ($element) {
		$element.SetAttribute("name", "MercManchu")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantNinja']")
	if ($element) {
		$element.SetAttribute("name", "MercNinja")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantOutlawPistol']")
	if ($element) {
		$element.SetAttribute("name", "SaloonOutlawPistol")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantOutlawRider']")
	if ($element) {
		$element.SetAttribute("name", "SaloonOutlawRider")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantOutlawRifleman']")
	if ($element) {
		$element.SetAttribute("name", "SaloonOutlawRifleman")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantPirate']")
	if ($element) {
		$element.SetAttribute("name", "SaloonPirate")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantRonin']")
	if ($element) {
		$element.SetAttribute("name", "MercRonin")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantSmuggler']")
	if ($element) {
		$element.SetAttribute("name", "ypWokouPirate")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantStradiot']")
	if ($element) {
		$element.SetAttribute("name", "MercStradiot")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantSwissPikeman']")
	if ($element) {
		$element.SetAttribute("name", "MercSwissPikeman")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantThuggee']")
	if ($element) {
		$element.SetAttribute("name", "ypThuggee")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantWanderingHorseman']")
	if ($element) {
		$element.SetAttribute("name", "ypWokouWanderingHorseman")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantWaywardRonin']")
	if ($element) {
		$element.SetAttribute("name", "ypWokouWaywardRonin")
	}

	$element = $techtreeNode.SelectSingleNode("//proto[@name='ypRepentantYojimbo']")
	if ($element) {
		$element.SetAttribute("name", "ypMercYojimbo")
	}

	$techtreeNode.Save($file)
}

# techtreey.xml
$techtreeFile = '$HOME\Games\Age of Empires 3 DE\76561198043389070\mods\local\enhanced revolutions\Data\techtreey.xml'
$techtreeNode = [xml](Get-Content $techtreeFile)

foreach ($element in $techtreeNode.SelectNodes("//effect[@subtype='Enable']")) {
	$target = $element.SelectSingleNode("target[contains(text(),'Repentant')]")
	if ($target) {
		$element.RemoveChild($target)
	}
}

$techNode = $techtreeNode.SelectSingleNode("//tech[@name='YPAge0ChineseSPCConsulate']")
$targetNode = $techNode.SelectSingleNode("//target[text()='ypRepentantBlindMonk']")
if ($targetNode) {
	$targetNode.InnerText = "ypWokouBlindMonk"
}

$techtreeNode.Save($techtreeFile)

# civs.xml
$civsFile = '$HOME\Games\Age of Empires 3 DE\76561198043389070\mods\local\enhanced revolutions\Data\civs.xml'
$civsNode = [xml](Get-Content $civsFile)
$unitNode = $civsNode.SelectSingleNode("//unit[text()='ypRepentantBlindMonk']")
if ($unitNode) {
	$unitNode.InnerText = "ypWokouBlindMonk"
}

$civsNode.Save($civsFile)
