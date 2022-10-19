
#From https://learn.microsoft.com/en-us/answers/questions/671154/need-to-get-the-nsg-details-from-all-our-subscript.html
#exports all NSGs and rules that are in them.


$subs = Get-AzSubscription
$outputfile = "C:\temp\NsgRules2.csv"

foreach ($sub in $subs) {
	Select-AzSubscription -SubscriptionId $sub.Id
	$nsgs = Get-AzNetworkSecurityGroup
	Foreach ($nsg in $nsgs) {
		$nsgRules = $nsg.SecurityRules
		foreach ($nsgRule in $nsgRules) {
			$nsgRule | Select-Object @{n='SubscriptionName';e={$sub.Name}},
				@{n='ResourceGroupName';e={$nsg.ResourceGroupName}},
				@{n='NetworkSecurityGroupName';e={$nsg.Name}},
				Name,Description,Priority,
				@{Name='SourceAddressPrefix';Expression={[string]::join(",", ($_.SourceAddressPrefix))}},
				@{Name='SourcePortRange';Expression={[string]::join(",", ($_.SourcePortRange))}},
				@{Name='DestinationAddressPrefix';Expression={[string]::join(",", ($_.DestinationAddressPrefix))}},
				@{Name='DestinationPortRange';Expression={[string]::join(",", ($_.DestinationPortRange))}},
				Protocol,Access,Direction |
					Export-Csv $outputfile  -NoTypeInformation -Encoding ASCII -Append        
		}
	}
	Foreach ($nsg in $nsgs) {
		$nsgRules = $nsg.DefaultSecurityRules
		foreach ($nsgRule in $nsgRules) {
			$nsgRule | Select-Object @{n='SubscriptionName';e={$sub.Name}},
				@{n='ResourceGroupName';e={$nsg.ResourceGroupName}},
				@{n='NetworkSecurityGroupName';e={$nsg.Name}},
				Name,Description,Priority,
				@{Name='SourceAddressPrefix';Expression={[string]::join(",", ($_.SourceAddressPrefix))}},
				@{Name='SourcePortRange';Expression={[string]::join(",", ($_.SourcePortRange))}},
				@{Name='DestinationAddressPrefix';Expression={[string]::join(",", ($_.DestinationAddressPrefix))}},
				@{Name='DestinationPortRange';Expression={[string]::join(",", ($_.DestinationPortRange))}},
				Protocol,Access,Direction |
					Export-Csv $outputfile  -NoTypeInformation -Encoding ASCII -Append        
		}
	}
}
