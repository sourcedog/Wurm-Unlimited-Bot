class Config
{
	__New()
	{
		this.console    := new Console
		this.configData := Object()

		configFile = %A_ScriptDir%\config.ini

		IniRead, tmpConfigFile, % configFile, GENERAL, EVENTLOG_FOLDER
		this.configData["eventLogFolder"] := tmpConfigFile

		;;; Special ;;;
		special := Object()
		
		; Tool is empty / broken
		IniRead, tmpConfigMessage, % configFile, SPECIAL, MESSAGE_TOOL_EMPTY
		special[tmpConfigMessage] := "halt"
		
		; Tool needs to be repaired
		IniRead, tmpConfigMessage, % configFile, SPECIAL, MESSAGE_NEEDS_REPAIR
		IniRead, tmpConfigButton, % configFile, ACTIONS, ACTION_REPAIR
		special[tmpConfigMessage] := tmpConfigButton

		this.configData["special"] := special

		;;; Metalworking ;;;
		metalWorking := Object()
		
		; Lump cannot be used to improve any further, jump to next target
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_LUMP_POOR_SHAPE
		metalWorking[tmpConfigMessage] := "next"
		
		; Something has cooled down too much, halt
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NOT_GLOWING
		metalWorking[tmpConfigMessage] := "halt"
		
		; Hammer
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NEEDS_HAMMER
		IniRead, tmpConfigSlot, % configFile, METALWORKING, TOOLBELT_HAMMER
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		metalWorking[tmpConfigMessage] := tmpConfigButton
		
		; Lump
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NEEDS_LUMP
		IniRead, tmpConfigSlot, % configFile, METALWORKING, TOOLBELT_LUMP
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		metalWorking[tmpConfigMessage] := tmpConfigButton
		
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NEEDS_MORELUMP
		IniRead, tmpConfigSlot, % configFile, METALWORKING, TOOLBELT_LUMP
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		metalWorking[tmpConfigMessage] := tmpConfigButton
		
		; Water
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NEEDS_WATER
		IniRead, tmpConfigSlot, % configFile, METALWORKING, TOOLBELT_WATER
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		metalWorking[tmpConfigMessage] := tmpConfigButton
		
		; Whetstone
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NEEDS_WHETSTONE
		IniRead, tmpConfigSlot, % configFile, METALWORKING, TOOLBELT_WHETSTONE
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		metalWorking[tmpConfigMessage] := tmpConfigButton
		
		; Pelt
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NEEDS_PELT
		IniRead, tmpConfigSlot, % configFile, METALWORKING, TOOLBELT_PELT
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		metalWorking[tmpConfigMessage] := tmpConfigButton
		
		this.configData["metalworking"] := metalWorking
	}
	
	getEventLogFolder()
	{
		return this.configData["eventLogFolder"]
	}
	
	getMetalworkingConfig()
	{
		return this.configData["metalworking"]
	}
	
	getSpecialConfig()
	{
		return this.configData["special"]
	}
}