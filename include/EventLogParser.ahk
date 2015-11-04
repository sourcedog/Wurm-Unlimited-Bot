Class EventLogParser
{
	__New(config)
	{
		this.console := new Console
		this.config  := config
	}
	
	parseString(line)
	{
		specialConfig      := this.config.getSpecialConfig()
		for index, element in specialConfig
        {
			If InStr(line, index)
				return element
		}
		
		metalworkingConfig := this.config.getMetalworkingConfig()
		for index, element in metalworkingConfig
        {
			If InStr(line, index)
				return element
		}
		
		return ""
	}
}