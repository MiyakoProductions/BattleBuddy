        #include <NomadMemory.au3>


	    ; - Theory Crafting Formulas -
		; Total Attack = BaseAttack + ExtraAttack
		; Extra Attack Percentage = Extra Power * 0.6
		; Extra Attack Amount = BaseAttack * (ExtraAttackPercent / 100)
		; Attack After Crit = TotalAttack * (CritPower + ExtraCritPower)
		;


		; The following offsets in memory may need to be changed after a client update.
		; To update the program, simply change these values here. Everything below will
		; not need to be changed.
		Global $PlayerPointer = 0x172B0F4 ; Static Pointer

		; Struct Offsets
		Global $PlayerBaseOFS1 = 0x2c0 ; Pointer Offest 0
		Global $PlayerBaseOFS2 = 0x1c4 ; Pointer Offset 1
		Global $PlayerBaseOFS3 = 0x40  ; Pointer Offset 2
		Global $PlayerBaseOFS4 = 0x10  ; Pointer Offset 3
		; Offsets in Struct
		Global $OFS_PWRFACTOR   = 0x108 ; Power Factor
		Global $OFS_ENDFACTOR   = 0x118 ; Endurance Factor
		Global $OFS_IMPFACTOR   = 0x128 ; Impact Factor
		Global $OFS_BALFACTOR   = 0x138 ; Balance Factor
		Global $OFS_MOVESPEED1  = 0x148 ; NonCombat Move Speed
		Global $OFS_MOVESPEED2  = 0x168 ; Combat Speed
		Global $OFS_CRITRATE    = 0x178 ; Critical Chance
		Global $OFS_CRITRESIST  = 0x188 ; Critical Resistance
		Global $OFS_CRITPOWER   = 0x198 ; Crit Damage Multiplier
		Global $OFS_ATK1        = 0x1a8 ; Attack Value 1
		Global $OFS_ATK2        = 0x1b8 ; Attack Value 2
		Global $OFS_DEF1        = 0x1c8 ; Defense Value
		Global $OFS_IMP         = 0x1d8 ; Impact Value
		Global $OFS_BAL         = 0x1e8 ; Balance Value
		Global $OFS_RESIST1     = 0x1f8 ; Resistance of Weakening Value, FLOAT
		Global $OFS_RESIST2     = 0x208 ; Resistance of Periodic Value, FLOAT
		Global $OFS_RESIST3     = 0x218 ; Resistance of Stun Value, FLOAT
		Global $OFS_GATHER1     = 0x228 ; Mining Value
		Global $OFS_GATHER2     = 0x248 ; Plant Gathering Value
		Global $OFS_GATHER3     = 0x258 ; Energy Gathering Value
		Global $OFS_POWER       = 0x278 ; Extra Power. 1 power = 0.6% attack. Ex. 16 power = 9.6%. Divide by 100 to get 0.096. Then total attack is: Attack + (Attack * 0.096)
		Global $OFS_ENDURANCE   = 0x288 ; Extra Endurance
		Global $OFS_MOVESPEED3  = 0x2b8 ; Extra NonCombat Move Speed
		Global $OFS_MOVESPEED4  = 0x2d8 ; Extra Combat Speed
		Global $OFS_ECRITRATE   = 0x2e8 ; Extra Critical Chance, FLOAT
		Global $OFS_ECRITRESIST = 0x2f8 ; Extra Chance to resist crit, FLOAT
		Global $OFS_ECRITPOWER  = 0x308 ; Extra Crit Power
		Global $OFS_ATK3        = 0x318 ; Attack gained from power. Simplifies our math, Total Atk = OFS_ATK1 + OFS_ATK3
		Global $OFS_ATK4        = 0x328 ; Matches OFS_ATK3
		Global $OFS_DEF2        = 0x338 ; Extra Defense from Endurance. Total Def = OFS_DEF1 + OFS_DEF2
		Global $OFS_ERESIST1    = 0x368 ; Extra Weakening Resistance, FLOAT
		Global $OFS_ERESIST2    = 0x378 ; Extra Periodic Resistance, FLOAT
		Global $OFS_ERESIST3    = 0x388 ; Extra Stun Resistance, FLOAT
		Global $OFS_EGATHER1    = 0x398 ; Extra Mining
		Global $OFS_EGATHER2    = 0x3a8 ; Extra Plant Gathering
		Global $OFS_EGATHER3    = 0x3b8 ; Extra Energy Gathering
		Global $OFS_UNKNOWN1    = 0x3c8 ; Unknown Stat, returned 5
	  ; End of Editable Variables

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
	   ; clear the terminal
	   RunWait(@COMSPEC &" /C CLS",@WORKINGDIR,@SW_HIDE)

	   ; calculate attack stats
		 $attack    = _MemoryRead($PlayerStruct + $OFS_ATK1    ,$openmem)
		 $attack2   = _MemoryRead($PlayerStruct + $OFS_ATK3    ,$openmem)
		 $attackPercent = _MemoryRead($PlayerStruct + $OFS_POWER ,$openmem) * 0.6
		 $totalAttack = $attack + $attack2
		 $critDamage = round (_MemoryRead($PlayerStruct + $OFS_CRITPOWER    ,$openmem, "float") + _MemoryRead($PlayerStruct + $OFS_ECRITPOWER    ,$openmem, "float") , 2)
		 $afterCrit = $totalAttack * $critDamage
	   ; calculate defense stats
		 $defense   = _MemoryRead($PlayerStruct + $OFS_DEF1    ,$openmem)
		 $defense2  = _MemoryReAd($PlayerStruct + $OFS_DEF2    ,$openmem)
		 $totalDefense = $defense + $defense2
		 $impact    = _MemoryRead($PlayerStruct + $OFS_IMP     ,$openmem)
		 $balance   = _MemoryRead($PlayerStruct + $OFS_BAL     ,$openmem)
		 $weakening = _MemoryRead($PlayerStruct + $OFS_RESIST1 ,$openmem, "float")
		 $periodic = _MemoryRead($PlayerStruct + $OFS_RESIST2 ,$openmem, "float")
		 $stun = _MemoryRead($PlayerStruct + $OFS_RESIST3 ,$openmem, "float")


	   ConsoleWrite("Attack: " & $attack & " + " & $attack2 & " (" & $attackPercent & "%) = " & $totalAttack & " - " & $afterCrit & " (Critical x " & $critDamage & ")" & @CRLF)
	   ConsoleWrite("Defense: " & $defense & " + " & $defense2 & " = " & $totalDefense & @CRLF)
	   ConsoleWrite("Impact: " & $impact & @CRLF)
	   ConsoleWrite("Balance: " & $balance & @CRLF)
	   ConsoleWrite("Resist Weakening: " & $weakening & @CRLF)
	   ConsoleWrite("Resist Periodic: " & $weakening & @CRLF)
	   ConsoleWrite("Resist Stun: " & $stun & @CRLF)

	  ; Refresh the thread.
	  sleep (1000)

   WEnd


	Func _MemoryModuleGetBaseAddress($iPID, $sModule)
	If Not ProcessExists($iPID) Then Return SetError(1, 0, 0)
	If Not IsString($sModule) Then Return SetError(2, 0, 0)
	Local   $PSAPI = DllOpen("psapi.dll")
	;Get Process Handle

	Local   $hProcess
	Local   $PERMISSION = BitOR(0x0002, 0x0400, 0x0008, 0x0010, 0x0020) ; CREATE_THREAD, QUERY_INFORMATION, VM_OPERATION, VM_READ, VM_WRITE
	If $iPID > 0 Then
		Local $hProcess = DllCall("kernel32.dll", "ptr", "OpenProcess", "dword", $PERMISSION, "int", 0, "dword", $iPID)
		If $hProcess[0] Then
			$hProcess = $hProcess[0]
		EndIf
	EndIf
	;EnumProcessModules
	Local   $Modules = DllStructCreate("ptr[1024]")
	Local   $aCall = DllCall($PSAPI, "int", "EnumProcessModules", "ptr", $hProcess, "ptr", DllStructGetPtr($Modules), "dword", DllStructGetSize($Modules), "dword*", 0)
	If $aCall[4] > 0 Then
		Local   $iModnum = $aCall[4] / 4
		Local   $aTemp
		For $i = 1 To $iModnum
			$aTemp =  DllCall($PSAPI, "dword", "GetModuleBaseNameW", "ptr", $hProcess, "ptr", Ptr(DllStructGetData($Modules, 1, $i)), "wstr", "", "dword", 260)
			If $aTemp[3] = $sModule Then
				DllClose($PSAPI)
				Return Ptr(DllStructGetData($Modules, 1, $i))
			EndIf
		Next
	EndIf
	DllClose($PSAPI)
	Return SetError(-1, 0, 0)
EndFunc