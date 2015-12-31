cls

[System.Console]::BackgroundColor = [System.ConsoleColor]::Black
enum RareType
{
    Common
    Uncommon
    Rare
    Elite
}

enum WeaponType
{
    Unarmed
    Gauntlet
    Dagger
    Sickle
    Club
    Morningstar
    Axe
    Battleaxe
    Longsword
    GreatAxe
    GreatSword
    GreatWarhammer
}

enum ArmorType
{
    None
    Leather
    Hide
    Chain
    Magic
}

enum ShieldType
{
    None
    Wood
    Metal
}

enum Hands
{
    One
    Two
}

enum Race
{
    Human
    Elf
    Dwarf
}

enum FoeRace
{
	Rat
    Spider
    Basilisk
	Wraith
	Zombie
	Troll
	Orc
	Lich
	Uruk
	Drake
	Gargoyle
}

enum CharacterClass
{
    Warrior
    Mage
    Priest
}

enum PotionType
{
    Health
    AttackBoost
    DexterityBoost
    StrengthBoost
}

enum ItemType
{
    Weapon
    Armor
    Shield
}

# Items
class Item
{
    [string] $Name
    [int]    $ID = (Get-Random)
    [string] $ObjectType = 'Item'
    [string] $S
    [int]    $X
    [int]    $Y
             $Color
    [int]    $Gold
}

class Weapon : Item
{
    # Properties 
    [WeaponType] $WeaponType
    [int]        $Damage
    [int]        $DamageBonus
    [Hands]      $Hands
    [bool]       $Melee
    [RareType]   $RareType
    [Player]     $Equip
    [bool]       $UsableItem = $false
    
    
    # Constructor
    Weapon(
        [WeaponType] $WeaponType,
        [int]        $Damage,
        [int]        $DamageBonus,
        [Hands]      $Hands,
        [bool]       $Melee,
        [RareType]   $RareType,
        [string]     $S,
        [int]        $X,
        [int]        $Y,
                     $Color,
        [int]        $Gold
    )
    {
        $this.Name =        $RareType.ToString() + " " + $Hands.ToString() + " hand " + $WeaponType.ToString()
        $this.WeaponType =  $WeaponType
        $this.Damage =      $Damage
        $this.DamageBonus = $DamageBonus
        $this.Hands =       $Hands
        $this.Melee =       $Melee
        $this.RareType =    $RareType
        $this.S =           $S
        $this.X =           $X
        $this.Y =           $Y
        $this.Color =       $Color
        $this.Gold =        $Gold
    }
}

class Potion : Item
{
    [PotionType] $PotionType
    [bool] $UsableItem = $true

    Potion([PotionType] $PotionType,[int] $Gold)
    {
        $this.Name = "$PotionType potion"
        $this.PotionType = $PotionType
        $this.Color = [System.ConsoleColor]::Red
        $this.Gold = $Gold
    }

    Potion([PotionType] $PotionType,$X,$Y,[int] $Gold)
    {
        $this.Name = "$PotionType potion"
        $this.PotionType = $PotionType
        $this.Color = [System.ConsoleColor]::Red
        $this.X = $X
        $this.Y = $Y
        $this.S = '+'
        $this.Gold = $Gold
    }

    Use($User)
    {

        Switch($this.PotionType.value__)
        {
            0{$hpPlus = Get-Random -Minimum 1 -Maximum 11; $User.HP += $hpPlus; Write-Host "$($User.Name) used $($this.Name) [+$hpPlus HP]" -ForegroundColor Green} # Health
            1{Write-Host "AttackBoost" } # AttackBoost
            2{Write-Host "DexterityBoost"} # DexterityBoost
            3{Write-Host "StrengthBoost"} # StrengthBoost
        }

        $user.inventory.remove($this)
    }
    
}

Class Armor : Item
{
    # Properties 
    [ArmorType]  $ArmorType
    [int]        $ACBonus
    [RareType]   $RareType
    [Player]     $Equip
    [bool]       $UsableItem = $false
    
    
    # Constructor
    Armor(
        [ArmorType] $ArmorType,
        [int]        $ACBonus,
        [RareType]   $RareType,
        [string]     $S,
        [int]        $X,
        [int]        $Y,
                     $Color,
        [int]        $Gold
    )
    {
        $this.Name =        "$($RareType.ToString()) $($ArmorType.ToString()) armor"
        $this.ArmorType =   $ArmorType
        $this.ACBonus =     $ACBonus
        $this.RareType =    $RareType
        $this.S =           $S
        $this.X =           $X
        $this.Y =           $Y
        $this.Color =       $Color
        $this.Gold =        $Gold
    }
}

Class Shield : Item
{
    # Properties 
    [ShieldType] $ShieldType
    [int]        $ACBonus
    [RareType]   $RareType
    [Player]     $Equip
    [bool]       $UsableItem = $false
    
    
    # Constructor
    Shield(
        [ShieldType] $ShieldType,
        [int]        $ACBonus,
        [RareType]   $RareType,
        [string]     $S,
        [int]        $X,
        [int]        $Y,
                     $Color,
        [int]        $Gold
    )
    {
        $this.Name =        "$($RareType.ToString()) $($ShieldType.ToString()) shield"
        $this.ShieldType =  $ShieldType
        $this.ACBonus =     $ACBonus
        $this.RareType =    $RareType
        $this.S =           $S
        $this.X =           $X
        $this.Y =           $Y
        $this.Color =       $Color
        $this.Gold =        $Gold
    }
}

# Creatures
class Creature
{
    # Properties
    [string] $Name
    [ValidateRange(0,40)] [int]  $Level
    [ValidateRange(0,100)] [int] $HP
    [ValidateRange(0,10)] [int]  $Atk
    [ValidateRange(0,10)] [int]  $Dex
    [ValidateRange(0,10)] [int]  $Str
    [ValidateRange(0,20)] [int]  $AC
    [ValidateRange(0,40)] [int]  $TotalAC = ($AC + $ArmorEquip.ACBonus + $ShieldEquip.ACBonus )
    [int]    $Alive = $true
    [int]    $ID = (Get-Random)
    [int]    $XP
    [int]    $Gold
    [string] $ObjectType = 'Creature'
    [System.Collections.ArrayList] $Inventory = @()
    [Weapon] $WeaponEquip
    [Armor]  $ArmorEquip
    [Shield] $ShieldEquip
    [string] $S
    [int]    $X
    [int]    $Y
             $Color
    
    # Hit method
    [Creature] Hit([Weapon] $Weapon,[Creature] $Target)
    {
        if(!$this.Alive)
        {
            Write-Warning "[$($this.name)] can't attack because it's dead"
            return $Target
        }
        elseif(!$Target.Alive)
        {
            Write-Warning "[$($this.name)] can't attack the target [$($Target.name)] because it's dead"
            return $Target
        }
        else
        {
            if($Weapon.Equip -eq $null)
            {
                $Weapon = New-Object Weapon -ArgumentList ([WeaponType]::Unarmed),3,0,0,$true,0,'>',1,1,([System.ConsoleColor]::Green),0
            }

            $Roll = Get-Random -Minimum 1 -Maximum 21
            $attack = $Roll + $this.Atk
            $defence = $Target.TotalAC + $Target.Dex

            if(($attack -gt $defence -or $Roll -eq 20) -and $roll -ne 1)
            {
                $critMultiplier = 1
                if($Roll -eq 20)
                {
                    if((Get-Random -Minimum 1 -Maximum 21) -in 10..20)
                    {
                        $critMultiplier = 2
                        Write-Host "CRITICAL HIT!" -ForegroundColor Red
                    }
                }

                $WeaponBasicDamage = (Get-Random -Minimum 1 -Maximum $weapon.Damage) + $weapon.DamageBonus
                
                $TotalDamage = ($WeaponBasicDamage + $this.Str) * $critMultiplier

                if($Target.HP -gt $TotalDamage)
                {
                    $Target.HP -= $TotalDamage
                    Write-Host "$($this.name) hits '$($Target.name)' with '$($Weapon.Name)' (A:$($attack)/D:$($defence)). Damage: [$TotalDamage] (target HP left: $($Target.HP))" -ForegroundColor Yellow
                }
                else
                {
                    $Target.HP = 0
                    $Target.Alive = $false
                    $this.XP += $target.XP
                    if($target -is [Foe])
                    {
                        $target.RollDrop()
                    }

                    Write-Host "'$($this.name)' hits '$($Target.name)' with '$($Weapon.Name)' (A:$($attack)/D:$($defence)). Damage: [$TotalDamage] (target HP left: $($Target.HP))" -ForegroundColor Yellow
                    Write-Host "'$($Target.name)' Dies" -ForegroundColor Red
                }

                
                return $Target
                
            }
            else
            {
                Write-Host "$($this.name) misses $($Target.name) with '$($Weapon.Name)'. Attack: $attack / defence: $defence"
                return $Target
            }
        }
    }

    Loot([Item] $Item)
    {
        if($this.Inventory.ID -notcontains $Item.ID)
        {
            $this.Inventory.add($Item)
            Write-Host "$($this.Name) Looted [$($Item.Name)]"
        }
        else
        {
            Write-Warning "$($this.Name) already looted [$($Item.Name)]"
        }
    }

    Drop([Item] $Item)
    {

        if($this.Inventory.ID -contains $Item.ID)
        {
            $this.Inventory.Remove($Item)
            Write-Host "$($this.Name) dropped [$($Item.Name)]"
        }
        else
        {
            Write-Warning "$($this.Name) don't have the [$($Item.Name)] item in the inventory"
        }
    }

    Equip([item] $item)
    {
        if($this.Inventory -contains $item -and $item.Equip -ne $this)
        {
            $item.Equip = $this

            if($item -is [Weapon])
            {
                $this.WeaponEquip = $item
            }
            elseif($item -is [Armor])
            {
                $this.ArmorEquip = $item
                $this.TotalAC += $item.ACBonus
            }
            else
            {
                $this.ShieldEquip = $item
                $this.TotalAC += $item.ACBonus
            }
            

            $this.Inventory.Remove($Item)
            Write-Host "$($this.Name) equipped [$($Item.Name)]"
        }
        elseif($item.Equip -eq $this)
        {
           Write-Warning "$($this.Name) already equipped [$($Item.Name)]" 
        }
        else
        {
            Write-Warning "$($this.Name) don't have the [$($Item.Name)] item in the inventory to equip it"
        }
    }

    UnEquip([item] $item)
    {
        if($item.Equip -eq $this)
        {
            $item.Equip = $null

            if($item -is [Weapon])
            {
                $this.WeaponEquip = $null
            }
            elseif($item -is [Armor])
            {
                $this.ArmorEquip = $null
                $this.TotalAC -= $item.ACBonus
            }
            else
            {
                $this.ShieldEquip = $null
                $this.TotalAC -= $item.ACBonus
            }

            $this.Inventory.add($Item)
            Write-Host "$($this.Name) unequipped [$($Item.Name)]"
        }
        else
        {
            Write-Warning "$($this.Name) don't have the [$($Item.Name)] item equipped"
        }
    }

    [item[]] GetEquippedGear()
    {
        return $this.WeaponEquip, $this.ArmorEquip, $this.ShieldEquip
    }


}

class Player : Creature
{
    # Properties
    [Race] $Race

    # Constructor
    Player(
        [string] $Name,
        [Race]   $Race,
        [int]    $Level,
        [int]    $HP,
        [int]    $Atk,
        [int]    $Dex,
        [int]    $Str,
        [int]    $AC,
        [string] $S,
        [int]    $X,
        [int]    $Y,
                 $Color
    )
    {
        $this.Name =    $Name
        $this.Race =    $Race
        $this.Level =   $Level
        $this.HP =      $HP
        $this.Atk =     $Atk
        $this.Dex =     $Dex
        $this.Str =     $Str
        $this.AC =      $AC
        $this.S =       $S
        $this.X =       $X
        $this.Y =       $Y
        $this.Color =   $Color
    }

    UseItem([item] $item)
    {
        $item.Use($this)
    }

    Sell([item] $item)
    {
        $this.Gold += ([math]::Ceiling($item.Gold * 0.25))
        $this.Inventory.Remove($item)

        Write-Host "Player sold $($item.name)"
    }

    Buy([item] $item)
    {
        if($this.Gold -ge $item.Gold)
        {
            $this.Gold -= $item.Gold
            $this.Inventory.Add($item)

            Write-Host "Player bought item: '$($item.name)'"
        }
        else
        {
            Write-Warning "You don't have enough money ($($this.gold) total) to buy this item: '$($item.name)' ($($item.gold))"
        }  
    }

}

class Foe : Creature
{
    # Properties
    [FoeRace]  $Race
    [RareType] $RareType
    [int]      $XP

    # Constructor
    Foe(
        [FoeRace]  $Race,
        [int]      $Level,
        [RareType] $RareType,
        [int]      $HP,
        [int]      $Atk,
        [int]      $Dex,
        [int]      $Str,
        [int]      $AC,
        [string]   $S,
        [int]      $X,
        [int]      $Y,
                   $Color
    )
    {
        $this.Name =     "Level $Level $RareType $Race"
        $this.Race =     $Race
        $this.Level =    $Level
        $this.RareType = $RareType
        $this.HP =       $HP
        $this.Atk =      $Atk
        $this.Dex =      $Dex
        $this.Str =      $Str
        $this.AC =       $AC
        $this.S =        $S
        $this.X =        $X
        $this.Y =        $Y
        $this.Color =    $Color
        $this.XP =       (($Race + 1) * ($RareType+1) * $Level)
    }

    RollDrop()
    {
        $roll = Get-Random -Minimum 1 -Maximum 101

        $itemRoll = Get-Random -Minimum 0 -Maximum 4

        if($roll -gt 1)
        {
            $item = $null

            switch($itemRoll)
            {
                0
                {
                    $item = New-Object Potion -ArgumentList ([PotionType]::Health),$this.X,$this.Y,100
                    
                } # Drops Potion

                1
                {
                    $item = Create-NewItem -ItemType 0 -Level 1 -Count 1 -ItemSubType (Get-Random -Minimum 1 -Maximum ([enum]::GetNames([WeaponType]).count) ) -X $this.X -Y $this.Y
                    
                } # Drops Weapon

                2
                {
                    $item = Create-NewItem -ItemType 1 -Level 1 -Count 1 -ItemSubType (Get-Random -Minimum 1 -Maximum ([enum]::GetNames([ArmorType]).count) ) -X $this.X -Y $this.Y
                    
                } # Drops Armor

                3
                {
                    $item = Create-NewItem -ItemType 2 -Level 1 -Count 1 -ItemSubType (Get-Random -Minimum 1 -Maximum ([enum]::GetNames([ShieldType]).count) ) -X $this.X -Y $this.Y
                    
                } # Drops Shield
            }

           Add-ItemToWorld -Item $item
        }
    }

}


class Block
{
    [string]   $ObjectType
    [int]      $X
    [int]      $Y
    [string]   $S
               $Color

    Block(
    [string] $ObjectType,
    [int]    $X,
    [int]    $Y,
    [string] $S,
             $Color
    )
    {
        $this.ObjectType = $ObjectType
        $this.X =          $X
        $this.Y =          $Y
        $this.S =          $S
        $this.Color =      $Color
    }
}

function Get-Collition
{
param(
$Collitions,
$KeyCode,
$Walker,
$Dimensions
)

    $wx = @{
        X = $Walker.X
        Y = $Walker.Y
    }

    Switch($KeyCode)
    {
        38{$wx.y -= 1} # UP
        40{$wx.y += 1 } # DOWN
        37{$wx.x -= 1} # LEFT
        39{$wx.x += 1} # RIGTH
    }

    if($wx.y -eq 0 -or $wx.y -eq $Dimensions.Y -or $wx.x -eq 0 -or $wx.x -eq $Dimensions.X)
    {
        return $false
    }

    if($Collitions | Where-Object {$_.x -eq $wx.X -and $_.y -eq $wx.Y})
    {
        return $false
    }

    return $true
}

function Draw-Map
{
param(
    $YSize = 9,
    $XSize = 19,
    $Objects
)
    
    cls
    [Console]::Out.Write("`n")
    Write-host "Gold:[$($p.Gold)] XP:[$($p.XP)] HP:[$($p.HP)]" -ForegroundColor Red

    foreach($y in 0..$YSize)
    {
        foreach($x in 0..$XSize)
        {
            if($y -eq 0 -or $y -eq $YSize -or $x -eq 0 -or $x -eq $XSize)
            {
                [System.Console]::BackgroundColor = [System.ConsoleColor]::Gray
                [Console]::Out.Write(' ')
                [System.Console]::BackgroundColor = [System.ConsoleColor]::Black
            }
            else
            {

                $temp = $null
                if($Objects.x -contains $x -and $Objects.y -contains $y)
                {
                    $temp = $Objects | Where-Object {$_.x -eq $x -and $_.y -eq $y}
                }
                if($temp)
                {
                    if($temp.count -gt 1)
                    {
                        [System.Console]::ForegroundColor = $temp[0].Color
                        [Console]::Out.Write($temp[0].S)
                    }
                    else
                    {
                        [System.Console]::ForegroundColor = $temp.Color
                        [Console]::Out.Write($temp.S)

                    }
                }
                else
                {
                    [Console]::Out.Write(' ')
                }
            }
        }
        [Console]::Out.Write("`n")
        [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    }

}

function Get-Inventory
{
param($player)

    return $player.Inventory | Out-GridView -PassThru
}

function Invoke-Prompt
{
param(
$Options = ('Yes','No'),
$Title = "Choose",
$Message = "Option"
)
    $opt = $options | % {
        New-Object System.Management.Automation.Host.ChoiceDescription "&$_", $_
    }

    return $host.ui.PromptForChoice($Title, $Message, $opt, 0) 
}

function Get-Duplicates
{
param($AllObjects)

$a = $AllObjects | select X,Y
$b = $AllObjects | select X,Y –unique

$diff = @(Compare-object –referenceobject $a -DifferenceObject $b -Property X,Y | select X,Y)

    if($b.Length -eq $a.Length)
    {
        return $true
    }
    else
    {

        foreach($d in $diff)
        {
        
            $duplicate = @($AllObjects | where {$_.X -eq $d.X -and $_.Y -eq $d.Y}) | Select-Object -Skip 1

            foreach($dd in $duplicate)
            {
                $dd.X = (Get-Random -Maximum $2D.X -Minimum 0)
                $dd.Y = (Get-Random -Maximum $2D.Y -Minimum 0)
            }
        }
        

        return $false
    }
  
}

function New-Enemy
{
param(
[int] $Count,
[int] $Level = 1,
[FoeRace] $FoeRace
)

    switch($FoeRace.value__)
    {
        0
        {
            $HP = 7
            $Atk = 0
            $Dex = 0
            $Str = 0
            $AC = 10
            $S = 'R'
        
        } # Rat
        1
        {
            $HP = 9
            $Atk = 1
            $Dex = 1
            $Str = 0
            $AC = 10
            $S = 'S'
        } # Spider
        2
        {
            $HP = 10
            $Atk = 1
            $Dex = 1
            $Str = 1
            $AC = 10
            $S = 'B'
        } # Basilisk
        3
        {
            $HP = 12
            $Atk = 2
            $Dex = 2
            $Str = 1
            $AC = 10
            $S = 'W'
        } # Wraith
        4
        {
            $HP = 14
            $Atk = 2
            $Dex = 2
            $Str = 2
            $AC = 10
            $S = 'Z'
        } # Zombie
        5
        {
            $HP = 18
            $Atk = 2
            $Dex = 2
            $Str = 3
            $AC = 10
            $S = 'T'
        } # Troll
        6
        {
            $HP = 20
            $Atk = 3
            $Dex = 2
            $Str = 3
            $AC = 10
            $S = 'O'
        } # Orc
        7
        {
            $HP = 22
            $Atk = 4
            $Dex = 3
            $Str = 3
            $AC = 10
            $S = 'L'
        } # Lich
        8
        {
            $HP = 25
            $Atk = 4
            $Dex = 3
            $Str = 4
            $AC = 10
            $S = 'U'
        } # Uruk
        9
        {
            $HP = 30
            $Atk = 4
            $Dex = 3
            $Str = 4
            $AC = 10
            $S = 'D'
        } # Drake
        10
        {
            $HP = 40
            $Atk = 4
            $Dex = 4
            $Str = 4
            $AC = 10
            $S = 'G'
        } # Gargoyle
    }

    $foes = 1..$Count | % {      
        
        switch(Get-Random -Minimum 1 -Maximum 101)
        {
            {$_ -in 1..79}
            {
                $HPM = 1
                $Color = [System.ConsoleColor]::Green
                $RareType = [RareType]::Common   
            }

            {$_ -in 80..94}
            {
                $HPM = 1.25
                $Color = [System.ConsoleColor]::Cyan
                $RareType = [RareType]::Uncommon
            }

            {$_ -in 95..99}
            {
                $HPM = 1.5
                $Color = [System.ConsoleColor]::Red
                $RareType = [RareType]::Rare
            }

            100
            {
                $HPM = 2
                $Color = [System.ConsoleColor]::Magenta
                $RareType = [RareType]::Elite
            }
        }

        New-Object Foe -ArgumentList $FoeRace,$Level,$RareType,([math]::Ceiling($HP * $HPM)),$Atk,$Dex,$Str,$AC,$S,(Get-Random -Minimum 1 -Maximum ($2D.X-1)),(Get-Random -Minimum 1 -Maximum ($2D.Y-1)),$Color
    }

    return $foes
}

function Add-ItemToWorld
{
param($Item)

    $AllObjects.add($Item)

}

function Create-NewItem
{
param(
    [int] $ItemType,
    [int] $Level,
    [int] $Count,
    [int] $ItemSubType,
    [int] $X,
    [int] $Y
)

    switch($ItemType)
    {
        0
        {
            switch($ItemSubType)
            {
                1
                {
                    $Damage = 3
                    $DamageBonus = 1
                    $Hands = [Hands]::One
                    $Melee = $true
                    $Gold = 20
                } # Gauntlet

                2
                {
                    $Damage = 4
                    $DamageBonus = 1
                    $Hands = [Hands]::One
                    $Melee = $true
                    $Gold = 30
                } # Dagger

                3
                {
                    $Damage = 5
                    $DamageBonus = 1
                    $Hands = [Hands]::One
                    $Melee = $true
                    $Gold = 40
                } # Sickle

                4
                {
                    $Damage = 6
                    $DamageBonus = 1
                    $Hands = [Hands]::One
                    $Melee = $true
                    $Gold = 50
                } # Club

                5
                {
                    $Damage = 7
                    $DamageBonus = 1
                    $Hands = [Hands]::One
                    $Melee = $true
                    $Gold = 60
                } # Morningstar

                6
                {
                    $Damage = 8
                    $DamageBonus = 1
                    $Hands = [Hands]::One
                    $Melee = $true
                    $Gold = 80
                } # Axe

                7
                {
                    $Damage = 9
                    $DamageBonus = 1
                    $Hands = [Hands]::One
                    $Melee = $true
                    $Gold = 120
                } # Battleaxe

                8
                {
                    $Damage = 10
                    $DamageBonus = 1
                    $Hands = [Hands]::One
                    $Melee = $true
                    $Gold = 200
                } # Longsword

                9
                {
                    $Damage = 12
                    $DamageBonus = 2
                    $Hands = [Hands]::Two
                    $Melee = $true
                    $Gold = 1000
                } # GreatAxe

                10
                {
                    $Damage = 14
                    $DamageBonus = 2
                    $Hands = [Hands]::Two
                    $Melee = $true
                    $Gold = 2000
                } # GreatSword

                11
                {
                    $Damage = 16
                    $DamageBonus = 2
                    $Hands = [Hands]::Two
                    $Melee = $true
                    $Gold = 4000
                } # GreatWarhammer
            }

        } # Weapon

        1
        {
            switch($ItemSubType)
            {
                1
                {
                    $ACBonus = 1
                    $Gold = 500
                } # Leather

                2
                {
                    $ACBonus = 2
                    $Gold = 1000
                } # Hide

                3
                {
                    $ACBonus = 3
                    $Gold = 2000
                } # Chain

                4
                {
                    $ACBonus = 4
                    $Gold = 10000
                } # Magic
            }

        } # Armor

        2
        {
            switch($ItemSubType)
            {
                1
                {
                    $ACBonus = 1
                    $Gold = 1000
                } # Wood

                2
                {
                    $ACBonus = 2
                    $Gold = 2000
                } # Metal
            }
        } # Shield
    
    }


    $Items = 1..$Count | % {

        switch(Get-Random -Minimum 1 -Maximum 101)
        {
            {$_ -in 1..79}
            {
                $Multiplier = 1
                $Color = [System.ConsoleColor]::Green
                $RareType = [RareType]::Common   
            }

            {$_ -in 80..94}
            {
                $Multiplier = 1.25
                $Color = [System.ConsoleColor]::Cyan
                $RareType = [RareType]::Uncommon
            }

            {$_ -in 95..99}
            {
                $Multiplier = 1.5
                $Color = [System.ConsoleColor]::Red
                $RareType = [RareType]::Rare
            }

            100
            {
                $DM = 2
                $Color = [System.ConsoleColor]::Magenta
                $RareType = [RareType]::Elite
            }
        }

        switch($ItemType)
        {
            0
            {
                New-Object Weapon -ArgumentList $ItemSubType,([math]::Ceiling($Damage * $Multiplier)),$DamageBonus,$Hands,$Melee,$RareType,'/',$X,$Y,$Color,([math]::Ceiling($Gold * $Multiplier))
            } # Weapon
            
            1
            {
                New-Object Armor -ArgumentList $ItemSubType,([math]::Ceiling($ACBonus * $Multiplier)),$RareType,'=',$X,$Y,$Color,([math]::Ceiling($Gold * $Multiplier))
            } # Armor

            2
            {
                New-Object Shield -ArgumentList $ItemSubType,([math]::Ceiling($ACBonus * $Multiplier)),$RareType,'0',$X,$Y,$Color,([math]::Ceiling($Gold * $Multiplier))
            } # Shield
        }
        
    }
    
    return $Items
}

function Get-Store
{

    $gategorySelect = 'Weapon','Armor','Shield','Potion' | Out-GridView -PassThru

    switch($gategorySelect)
    {
        'Weapon' {$items = 1..([enum]::GetNames([WeaponType]).count -1) | %{Create-NewItem -ItemType 0 -Level 1 -Count 1 -ItemSubType $_ -X 0 -Y 0}}
        'Armor'  {$Items = 1..([enum]::GetNames([ArmorType]).count -1) | %{Create-NewItem -ItemType 1 -Level 1 -Count 1 -ItemSubType $_ -X 0 -Y 0}}
        'Shield' {$Items = 1..([enum]::GetNames([ShieldType]).count -1) | %{Create-NewItem -ItemType 2 -Level 1 -Count 1 -ItemSubType $_ -X 0 -Y 0}}
        'Potion' {$Items = New-Object Potion -ArgumentList ([PotionType]::Health),0,0,100}
    }


    $selectedItem = $Items | Out-GridView -PassThru

    return $selectedItem

}

$2D = @{
    X = 30
    Y = 20
}

$weapon = Create-NewItem -ItemType 0 -Level 1 -Count 1 -ItemSubType (Get-Random -Minimum 1 -Maximum ([enum]::GetNames([WeaponType]).count -5) ) -X 1 -Y 2

$p = New-Object Player -ArgumentList 'Warrior',([Race]::Human),1,20,2,2,2,10,'@',1,1,([System.ConsoleColor]::Yellow)

$foes = New-Enemy -Count 5 -FoeRace (Get-Random -Minimum 0 -Maximum 11)

[System.Collections.ArrayList] $AllObjects = $foes + $p + $weapon

while(!(Get-Duplicates -AllObjects $AllObjects))
{}

# game loop
while($p.alive)
{

    Draw-Map -Objects $AllObjects -YSize $2D.Y -XSize $2D.X

    # Read the arrow key to move to a direction
    $key = ($host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")).VirtualKeyCode

    Switch($key)
    {
        49
        {
            Write-Host "Use item"
            $itemSelected = Get-Inventory -Player $p
            if($itemSelected.UsableItem)
            {
                $p.UseItem($itemSelected)

                $wait = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }
            else
            {
                Write-Host "$($itemSelected.Name) is not usable!"
                $wait = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }
        } # Use item

        69
        {
            $itemSelected = Get-Inventory -Player $p
            if($itemSelected)
            {
                $p.Equip($itemSelected)
                $wait = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }

        } # [E]quipt

        68
        {
            $itemSelected = Get-Inventory -Player $p
            if($itemSelected)
            {
                $p.Drop($itemSelected)
                $itemSelected.X = $p.X
                $itemSelected.Y = $p.Y
                $AllObjects.Add($itemSelected)
                $wait = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }
        } # [D]rop

        73
        {
            Write-Host "Inventory:"
            $p.Inventory
            $wait = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        } # [I]nventory

        85
        {
            $itemSelected = $p.GetEquippedGear() | Out-GridView -PassThru

            $p.UnEquip($itemSelected)
            $wait = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        } # [U]nequip

        71 
        {
            Write-Host "Equipped weapon:"
            $p.WeaponEquip
            Write-Host "Equipped armor:"
            $p.ArmorEquip
            Write-Host "Equipped shield:"
            $p.ShieldEquip
            $wait = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        } # [G]ear equipped

        83 
        {
            Write-Host "Player Stats:"
            $p
            $wait = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        } # [S]tats

        88
        {
            Write-Host "Select item to sell"
            $itemSelected = Get-Inventory -Player $p
            if($itemSelected)
            {

                $prompt = Invoke-Prompt -Title "Sell" -Message "Do you want to sell item '$($itemSelected.name)'?"

                switch($prompt)
                {
                    0
                    {
                        $p.sell($itemSelected)
                    }
                    1
                    {
                        Write-Host "Selling cancelled"
                    }
                }
                

                $wait = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }
        } # Sell

        90
        {
            Write-Host "Select item to Buy"
            $itemSelected = Get-Store

            $itemSelected

            if($itemSelected)
            {
                $prompt = Invoke-Prompt -Title "Buy" -Message "Do you want to buy item '$($itemSelected.name)' ($($itemSelected.gold) gold)?"

                switch($prompt)
                {
                    0
                    {
                        $p.buy($itemSelected)
                    }
                    1
                    {
                        Write-Host "Buying cancelled"
                    }
                } 
            }

            $wait = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        } # Buy
    }

    # If Arrow keys
    if($key -in 37..40)
    {
        if(Get-Collition -Collitions $AllObjects -KeyCode $key -Walker $p -Dimensions $2D)
        {
            Switch($key)
            {
                38{$p.y -= 1} # UP
                40{$p.y += 1} # DOWN
                37{$p.x -= 1} # LEFT
                39{$p.x += 1} # RIGTH
            }
        }
        else
        {
        # Collition
            Switch($key)
            {
                38
                {
                    $cord = @{
                        Y = ($p.y - 1)
                        X = $p.x
                    }
                }
                40
                {
                    $cord = @{
                        Y = ($p.y + 1)
                        X = $p.x
                    }
                }
                37
                {
                     $cord = @{
                        Y = $p.y
                        X = ($p.x - 1)
                    }
                }
                39
                {
                    $cord = @{
                        Y = $p.y
                        X = ($p.x + 1)
                    }
                }
            }

            # Walls
            if($cord.y -eq 0 -or $cord.y -eq $2D.Y -or $cord.x -eq 0 -or $cord.x -eq $2D.X)
            {
                Write-Host "You bumped into the wall"
            }
            else
            {
                $foundItem = $AllObjects | Where-Object {$_.x -eq $cord.x -and $_.y -eq $cord.y}
                $foundItem

                if($foundItem.ObjectType -eq 'Creature')
                {
                    $target = $p.Hit($p.WeaponEquip,$foundItem)

                    if(!$target.alive)
                    {
                        $AllObjects.Remove($target)
                    }
                    else
                    {
                        $target.Hit($target.WeaponEquip,$p)
                    }
                }
                elseif($foundItem.ObjectType -eq 'Item')
                {
                    if(!(Invoke-Prompt -Title 'Found item' -Message "Do you want to pick up [$($foundItem.name)]?"))
                    {
                        $p.Loot($foundItem)
                        $AllObjects.Remove($foundItem)
                    }
                }
                else
                {
                    Write-Host "Nothing"
                }
            }

            $wait = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        
        }
    }
}

$gameOverText = @"
      _____          __  __ ______    ______      ________ _____  _            
     / ____|   /\   |  \/  |  ____|  / __ \ \    / /  ____|  __ \| |           
    | |  __   /  \  | \  / | |__    | |  | \ \  / /| |__  | |__) | |           
    | | |_ | / /\ \ | |\/| |  __|   | |  | |\ \/ / |  __| |  _  /| |           
    | |__| |/ ____ \| |  | | |____  | |__| | \  /  | |____| | \ \|_|           
     \_____/_/    \_\_|  |_|______|  \____/   \/   |______|_|  \_(_)           
 ________________________________________________________________________ 
|________________________________________________________________________|

"@
Write-Host $gameOverText -ForegroundColor Red

