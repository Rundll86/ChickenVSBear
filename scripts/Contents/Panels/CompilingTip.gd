@tool
extends FullscreenPanelBase

func afterOpen(_args: Array = []):
	UIState.closeCurrentPanel()
