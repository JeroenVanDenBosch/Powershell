
#Connect-MicrosoftTeams

$Teams = Get-Team | Select-Object -Property * | Where-Object -Property Visibility -like 'Public' 

ForEach ($Team in $Teams) 
    {
     "`n" + "Team:         " + $Team.displayname 
     $TeamUsers = Get-TeamUser -GroupId ($Team.GroupId)
     ForEach ($TeamUser in $TeamUsers) 
        {     
         if ($Teamuser.role -like 'Owner') 
            { 
             "Eigenaar:     " + $Teamuser.name
            }
         else {}
        }
   
    }



