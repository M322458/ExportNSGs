
#From https://learn.microsoft.com/en-us/answers/questions/671154/need-to-get-the-nsg-details-from-all-our-subscript.html
#exports all NSGs and what NIC, subnet, or VNET they are associated with.



$subs = Get-AzSubscription

#Looping on all subscriptions
foreach ($sub in $subs){
  Select-AzSubscription -SubscriptionId $sub.Id
  $nsgs=Get-AzNetworkSecurityGroup
  #Looping on all NSGs in the subscription
  foreach ($nsg in $nsgs){
   $c=0;
   #Looping on all netwo0rk interfaces associated with the NSG
   foreach($nicId in $nsg.NetworkInterfaces.Id){
     $c=$c+1;
     $nic=Get-AzNetworkInterface -ResourceId $nicId;
     $nic | Select-Object @{Name='SubscriptionName';Expression={$sub.Name}},`
     @{Name="NSGName";e={$nsg.Name}},`
     @{Name="NICName";e={$nic.Name}},`
     @{Name="NICLocation";e={$nic.Location}},`
     @{Name="NICRGName";e={$nic.ResourceGroupName}},`
     @{Name="VMName";e={$nic.VirtualMachine.Id.ToString().split("/")[8]}},`
     @{Name="VMRGName";e={$nic.VirtualMachine.Id.ToString().split("/")[4]}},`
     @{Name="VNETName";e=" "},`
     @{Name="VNETRGName";e=" "},`
     @{Name="SubnetName";e=" "}|`
     Export-Csv "C:\Temp\AllNSGs.csv" -Encoding ASCII -Append
  }
   
   #Looping on all subnets associated with the NSG
   foreach($subnetId in $nsg.Subnets.Id){
     $c=$c+1;
     $subnetId | Select-Object @{Name='SubscriptionName';Expression={$sub.Name}},`
     @{Name="NSGName";e={$nsg.Name}},`
     @{Name="NICName";e=" "},`
     @{Name="NICLocation";e=" "},`
     @{Name="NICRGName";e=" "},`
     @{Name="VMName";e=" "},`
     @{Name="VMRGName";e=" "},`
     @{Name="VNETName";e={$subnetId.ToString().split("/")[8]}},`
     @{Name="VNETRGName";e={$subnetId.ToString().split("/")[4]}},`
     @{Name="SubnetName";e={$subnetId.ToString().split("/")[10]}}|`
     Export-Csv "C:\Temp\AllNSGs.csv" -Encoding ASCII -Append
  }
  #If the NSG is neither associated with a network interface nor with a subnet
  if ( $c -eq 0 ){
     $nsg | Select-Object @{Name='SubscriptionName';Expression={$sub.Name}},`
     @{Name="NSGName";e={$nsg.Name}},`
     @{Name="NICName";e=" "},`
     @{Name="NICLocation";e=" "},`
     @{Name="NICRGName";e=" "},`
     @{Name="VMName";e=" "},`
     @{Name="VMRGName";e=" "},`
     @{Name="VNETName";e=" "},`
     @{Name="VNETRGName";e=" "},`
     @{Name="SubnetName";e=" "}|`
     Export-Csv "C:\Temp\AllNSGs.csv" -Encoding ASCII -Append
  }
 }
}