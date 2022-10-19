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



555ae505-ae64-488c-bef4-8b0c06ebeab3

Select-AzSubscription -SubscriptionId c8b23a33-d148-4a17-8e76-4457df1fdf8b
Select-AzSubscription -SubscriptionId 555ae505-ae64-488c-bef4-8b0c06ebeab3


$nsgs = Get-AzNetworkSecurityGroup
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
			Protocol,Access,Direction 
	}
}
