#Include %A_ScriptDir%\include

#Include ArrayExtensions.ahk
#Include Console.ahk
#Include Config.ahk
#Include EventLogUpdateChecker.ahk
#Include EventLogParser.ahk

startExecution = 0

itemPositions         := []
console               := new Console
config                := new Config
eventLogParser        := new EventLogParser(config)

FormatTime, eventLogTimeString, , yyyy-MM
eventLogFolder := config.getEventLogFolder()
eventLogFile    = %eventLogFolder%_Event.%eventLogTimeString%.txt
eventLogUpdateChecker := new EventLogUpdateChecker(eventLogFile)

improveButton := config.getImproveButton()
examineButton := config.getExamineButton()

console.log("Please mark items to improve by hovering the mouse over each one and pressing SPACE")
console.log("Start execution with SHIFT+ESC when ready")
console.log("Once running, press SHIFT+ESC to go back to idle, press ESC to stop entirely")

Idle:
Loop 													
{
    if startExecution = 1
    {
        console.log("Starting up... Event log size is " . eventLogUpdateChecker.getLineCount() . " line(s)")
        break   
    }
    sleep 500
}

curItemPos := itemPositions.shift()

MouseMove, curItemPos["x"], curItemPos["y"]
Send, {LButton}
Send {%examineButton% down}

Loop
{
    newLines := eventLogUpdateChecker.checkForUpdate()
    if(newLines.MaxIndex() > 0)
    {
        console.log("")
        console.log("Update in event log found!")
        for index, element in newLines
        {
            keyToPress := eventLogParser.parseString(element)
            
            if(keyToPress == "next")
            {
                if(itemPositions.length() <= 0)
                {
                    console.log("Ran out of items to improve. Going idle...")
                    startExecution = 0
                    Goto, Idle 
                }
                curItemPos := itemPositions.shift()
                MouseMove, curItemPos["x"], curItemPos["y"]
                Send, {LButton}
                Send {%examineButton% down}
                continue
            }
            else
            {
                MouseMove, curItemPos["x"], curItemPos["y"]
                Send, {LButton}
            }
            
            if(keyToPress == "halt")
            {
                console.log("Cannot proceed, going back to idle")
                startExecution = 0
                Goto, Idle
            }
            
            if(keyToPress != "")
            {
                console.log("Sending Keypress " . keyToPress)
                Send {%keyToPress% down}
                Sleep 500
                Send {%improveButton% down}
                sleep 6000   
            }
        }
    }
}

esc::exitapp

+esc::
    if(startExecution == 1)
    {
        startExecution = 0
        Goto, Idle
    }
    else
    {
        startExecution = 1   
    }
return

space::
    if(startExecution == 0)
    {
        console.log("Recording item position...")
        MouseGetPos, PosX, PosY
        mousePos := Object()
        mousePos["x"] := PosX
        mousePos["y"] := PosY
        
        itemPositions.push(mousePos)
    }
return

f11::listvars

f12::reload

#singleinstance force