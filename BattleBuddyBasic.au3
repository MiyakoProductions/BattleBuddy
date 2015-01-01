        #include <NomadMemory.au3>
		#include <PlayerStats.au3>


		; - Theory Crafting Formulas -
		; Total Attack = BaseAttack + ExtraAttack
		; Extra Attack Percentage = Extra Power * 0.6
		; Extra Attack Amount = BaseAttack * (ExtraAttackPercent / 100)
		; Attack After Crit = TotalAttack * (CritPower + ExtraCritPower)
		;

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

	   ; Display Information
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