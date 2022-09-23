
Connect-MicrosoftTeams

# Connect via bovenstaand en voer onderstaand uit. 

# Output wordt weggeschreven naar:
$filename = 'C:\Applicatiebeheer\teams_'+(get-date -Format yyyyMMdd)+'.csv'

#Opvragen alle teams (met all eigenschappen)
$Teams = Get-Team | Select-Object -Property *

ForEach ($Team in $Teams) 
    {
     $TeamUsers = Get-TeamUser -GroupId ($Team.GroupId)
     ForEach ($TeamUser in $TeamUsers) 
        {     
         $Team.DisplayName + ';' + $TeamUser.name + ';' + $Teamuser.role >> $filename  
        }
    
    }
