        #include <lib/NomadMemory.lib>
		#include <PlayerStats.h>

        Global $PID
        Global $sModule = "TERA.exe" ; Module in Memory
        Global $openmem
        $PID = ProcessExists("TERA.exe")


	; Get Process ID
	$openmem = _MemoryOpen($PID)

	; Get the base address of TERA.exe
	$baseADDR = _MemoryModuleGetBaseAddress($PID, $sModule)
	$PlayerStruct = "0x" & Hex($baseADDR + $PlayerPointer)

	; Get the address of the player struct
	$PlayerStruct = _MemoryRead($PlayerStruct,$openmem)
	$PlayerStruct = _MemoryRead($PlayerStruct + $PlayerBaseOFS1,$openmem)
	$PlayerStruct = _MemoryRead($PlayerStruct + $PlayerBaseOFS2,$openmem)
	$PlayerStruct = _MemoryRead($PlayerStruct + $PlayerBaseOFS3,$openmem)
	$PlayerStruct = _MemoryRead($PlayerStruct + $PlayerBaseOFS4,$openmem)

	; Find Values
	while 1
	   ; Clear the terminal
	   RunWait(@COMSPEC &" /C CLS",@WORKINGDIR,@SW_HIDE)

	   ; Calculate attack stats
		 $attack    = _MemoryRead($PlayerStruct + $OFS_ATK1    ,$openmem)
		 $attack2   = _MemoryRead($PlayerStruct + $OFS_ATK3    ,$openmem)
		 $attackPercent = _MemoryRead($PlayerStruct + $OFS_POWER ,$openmem) * 0.6
		 $totalAttack = $attack + $attack2
		 $critDamage = round (_MemoryRead($PlayerStruct + $OFS_CRITPOWER    ,$openmem, "float") + _MemoryRead($PlayerStruct + $OFS_ECRITPOWER    ,$openmem, "float") , 2)
		 $afterCrit = $totalAttack * $critDamage
	   ; Calculate defense stats
		 $defense   = _MemoryRead($PlayerStruct + $OFS_DEF1    ,$openmem)
		 $defense2  = _MemoryReAd($PlayerStruct + $OFS_DEF2    ,$openmem)
		 $totalDefense = $defense + $defense2
		 $impact    = _MemoryRead($PlayerStruct + $OFS_IMP     ,$openmem)
		 $balance   = _MemoryRead($PlayerStruct + $OFS_BAL     ,$openmem)
		 $weakening = _MemoryRead($PlayerStruct + $OFS_RESIST1 ,$openmem, "float")
		 $periodic = _MemoryRead($PlayerStruct + $OFS_RESIST2 ,$openmem, "float")
		 $stun = _MemoryRead($PlayerStruct + $OFS_RESIST3 ,$openmem, "float")
	   ; Calculate HP and MP
		 $hp = _MemoryRead($PlayerStruct + $OFS_HEALTH1, $openmem)
		 $maxHP = _MemoryRead($PlayerStruct + $OFS_HEALTH2, $openmem)
		 $mp = _MemoryRead($PlayerStruct + $OFS_MANA1, $openmem)
		 $maxMP = _MemoryRead($PlayerStruct + $OFS_MANA2, $openmem)
       ; Calculate Level
		 $level = _MemoryRead($PlayerStruct + $OFS_LEVEL, $openmem)
		

	   ; Display Information
	   ConsoleWrite("Level: " & $level & @CRLF)
	   ConsoleWrite("Health: " & $hp & " / " & $maxHP & @CRLF)
	   ConsoleWrite("Mana: " & $mp & " / " & $maxMP & @CRLF)
	   ConsoleWrite("Attack: " & $attack & " + " & $attack2 & " (" & $attackPercent & "%) = " & $totalAttack & " - " & $afterCrit & " (Critical x " & $critDamage & ")" & @CRLF)
	   ConsoleWrite("Defense: " & $defense & " + " & $defense2 & " = " & $totalDefense & @CRLF)
	   ConsoleWrite("Impact: " & $impact & @CRLF)
	   ConsoleWrite("Balance: " & $balance & @CRLF)

	  ; Refresh the thread.
	  sleep (1000)

   WEnd