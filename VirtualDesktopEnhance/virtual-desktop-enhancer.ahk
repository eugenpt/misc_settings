#SingleInstance, force
#WinActivateForce
#HotkeyInterval 20
#MaxHotkeysPerInterval 20000
#MenuMaskKey vk07
#UseHook
; Credits to Ciantic: https://github.com/Ciantic/VirtualDesktopAccessor

; EP
; Initialize the array with a single element
currentIndex := 1
desktopHistory := []
desktopHistory[currentIndex] := 1  ; Store the number 1 at index currentIndex

#Include, %A_ScriptDir%\libraries\read-ini.ahk
#Include, %A_ScriptDir%\libraries\tooltip.ahk

; ======================================================================
; Set Up Library Hooks
; ======================================================================

DetectHiddenWindows, On
hwnd := WinExist("ahk_pid " . DllCall("GetCurrentProcessId","Uint"))
hwnd += 0x1000 << 32

hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", A_ScriptDir . "\libraries\virtual-desktop-accessor.dll", "Ptr")

global GoToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GoToDesktopNumber", "Ptr")
global RegisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "RegisterPostMessageHook", "Ptr")
global UnregisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnregisterPostMessageHook", "Ptr")
global GetCurrentDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetCurrentDesktopNumber", "Ptr")
global GetDesktopCountProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetDesktopCount", "Ptr")
global IsWindowOnDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsWindowOnDesktopNumber", "Ptr")
global MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "MoveWindowToDesktopNumber", "Ptr")
global IsPinnedWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsPinnedWindow", "Ptr")
global PinWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "PinWindow", "Ptr")
global UnPinWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnPinWindow", "Ptr")
global IsPinnedAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsPinnedApp", "Ptr")
global PinAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "PinApp", "Ptr")
global UnPinAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnPinApp", "Ptr")

DllCall(RegisterPostMessageHookProc, Int, hwnd, Int, 0x1400 + 30)
OnMessage(0x1400 + 30, "VWMess")
VWMess(wParam, lParam, msg, hwnd) {
    OnDesktopSwitch(lParam + 1)
}

; ======================================================================
; Auto Execute
; ======================================================================

; Set up tray tray menu

Menu, Tray, NoStandard
Menu, Tray, Add, &Manage Desktops, OpenDesktopManager
Menu, Tray, Default, &Manage Desktops
Menu, Tray, Add, Reload Settings, Reload
Menu, Tray, Add, Exit, Exit
Menu, Tray, Click, 1

; Read and groom settings

ReadIni("settings.ini")

global GeneralDesktopWrapping := (GeneralDesktopWrapping != "" and GeneralDesktopWrapping ~= "^[01]$") ? GeneralDesktopWrapping : 1
global TooltipsEnabled := (TooltipsEnabled != "" and TooltipsEnabled ~= "^[01]$") ? TooltipsEnabled : 1
global TooltipsLifespan := (TooltipsLifespan != "" and TooltipsLifespan ~= "^\d+$") ? TooltipsLifespan : 750
global TooltipsFadeOutAnimationDuration := (TooltipsFadeOutAnimationDuration != "" and TooltipsFadeOutAnimationDuration ~= "^\d+$") ? TooltipsFadeOutAnimationDuration : 100
global TooltipsPositionX := (TooltipsPositionX == "LEFT" or TooltipsPositionX == "CENTER" or TooltipsPositionX == "RIGHT") ? TooltipsPositionX : "CENTER"
global TooltipsPositionY := (TooltipsPositionY == "TOP" or TooltipsPositionY == "CENTER" or TooltipsPositionY == "BOTTOM") ? TooltipsPositionY : "CENTER"
global TooltipsOnEveryMonitor := (TooltipsOnEveryMonitor != "" and TooltipsOnEveryMonitor ~= "^[01]$") ? TooltipsOnEveryMonitor : 1
global TooltipsFontSize := (TooltipsFontSize != "" and TooltipsFontSize ~= "^\d+$") ? TooltipsFontSize : 11
global TooltipsFontInBold := (TooltipsFontInBold != "" and TooltipsFontInBold ~= "^[01]$") ? (TooltipsFontInBold ? 700 : 400) : 700
global TooltipsFontColor := (TooltipsFontColor != "" and TooltipsFontColor ~= "^0x[0-9A-Fa-f]{1,6}$") ? TooltipsFontColor : "0xFFFFFF"
global TooltipsBackgroundColor := (TooltipsBackgroundColor != "" and TooltipsBackgroundColor ~= "^0x[0-9A-Fa-f]{1,6}$") ? TooltipsBackgroundColor : "0x1F1F1F"
global GeneralUseNativePrevNextDesktopSwitchingIfConflicting := (GeneralUseNativePrevNextDesktopSwitchingIfConflicting ~= "^[01]$" && GeneralUseNativePrevNextDesktopSwitchingIfConflicting == "1" ? true : false)

; Initialize

global taskbarPrimaryID=0
global taskbarSecondaryID=0
global previousDesktopNo=0
global doFocusAfterNextSwitch=0
global hasSwitchedDesktopsBefore=1

global changeDesktopNamesPopupTitle := "Windows 10 Virtual Desktop Enhancer"
global changeDesktopNamesPopupText :=  "Change the desktop name of desktop #{:d}"

initialDesktopNo := _GetCurrentDesktopNumber()

SwitchToDesktop(GeneralDefaultDesktop)
; Call "OnDesktopSwitch" since it wouldn't be called otherwise, if the default desktop matches the current one
if (GeneralDefaultDesktop == initialDesktopNo) {
    OnDesktopSwitch(GeneralDefaultDesktop)
}

; ======================================================================
; Set Up Key Bindings
; ======================================================================

; Translate the modifier keys strings

hkModifiersSwitch          := KeyboardShortcutsModifiersSwitchDesktop
hkModifiersMove            := KeyboardShortcutsModifiersMoveWindowToDesktop
hkModifiersMoveAndSwitch   := KeyboardShortcutsModifiersMoveWindowAndSwitchToDesktop
hkModifiersPlusTen         := KeyboardShortcutsModifiersNextTenDesktops
hkIdentifierPrevious       := KeyboardShortcutsIdentifiersPreviousDesktop
hkIdentifierNext           := KeyboardShortcutsIdentifiersNextDesktop
hkComboPinWin              := KeyboardShortcutsCombinationsPinWindow
hkComboUnpinWin            := KeyboardShortcutsCombinationsUnpinWindow
hkComboTogglePinWin        := KeyboardShortcutsCombinationsTogglePinWindow
hkComboPinApp              := KeyboardShortcutsCombinationsPinApp
hkComboUnpinApp            := KeyboardShortcutsCombinationsUnpinApp
hkComboTogglePinApp        := KeyboardShortcutsCombinationsTogglePinApp
hkComboOpenDesktopManager  := KeyboardShortcutsCombinationsOpenDesktopManager
hkComboChangeDesktopName     := KeyboardShortcutsCombinationsChangeDesktopName

arrayS := Object(),                     arrayR := Object()
arrayS.Insert("\s*|,"),                 arrayR.Insert("")
arrayS.Insert("L(Ctrl|Shift|Alt|Win)"), arrayR.Insert("<$1")
arrayS.Insert("R(Ctrl|Shift|Alt|Win)"), arrayR.Insert(">$1")
arrayS.Insert("Ctrl"),                  arrayR.Insert("^")
arrayS.Insert("Shift"),                 arrayR.Insert("+")
arrayS.Insert("Alt"),                   arrayR.Insert("!")
arrayS.Insert("Win"),                   arrayR.Insert("#")

for index in arrayS {
    hkModifiersSwitch         := RegExReplace(hkModifiersSwitch, arrayS[index], arrayR[index])
    hkModifiersMove           := RegExReplace(hkModifiersMove, arrayS[index], arrayR[index])
    hkModifiersMoveAndSwitch  := RegExReplace(hkModifiersMoveAndSwitch, arrayS[index], arrayR[index])
    hkModifiersPlusTen        := RegExReplace(hkModifiersPlusTen, arrayS[index], arrayR[index])
    hkComboPinWin             := RegExReplace(hkComboPinWin, arrayS[index], arrayR[index])
    hkComboUnpinWin           := RegExReplace(hkComboUnpinWin, arrayS[index], arrayR[index])
    hkComboTogglePinWin       := RegExReplace(hkComboTogglePinWin, arrayS[index], arrayR[index])
    hkComboPinApp             := RegExReplace(hkComboPinApp, arrayS[index], arrayR[index])
    hkComboUnpinApp           := RegExReplace(hkComboUnpinApp, arrayS[index], arrayR[index])
    hkComboTogglePinApp       := RegExReplace(hkComboTogglePinApp, arrayS[index], arrayR[index])
    hkComboOpenDesktopManager := RegExReplace(hkComboOpenDesktopManager, arrayS[index], arrayR[index])
    hkComboChangeDesktopName    := RegExReplace(hkComboChangeDesktopName, arrayS[index], arrayR[index])    
}

; Setup key bindings dynamically
;  If they are set incorrectly in the settings, an error will be thrown.

setUpHotkey(hk, handler, settingPaths) {
    Hotkey, %hk%, %handler%, UseErrorLevel
    if (ErrorLevel <> 0) {
        MsgBox, 16, Error, One or more keyboard shortcut settings have been defined incorrectly in the settings file: `n%settingPaths%. `n`nPlease read the README for instructions.
        Exit
    }
}

setUpHotkeyWithOneSetOfModifiersAndIdentifier(modifiers, identifier, handler, settingPaths) {
    modifiers <> "" && identifier <> "" ? setUpHotkey(modifiers . identifier, handler, settingPaths) :
}

setUpHotkeyWithTwoSetOfModifiersAndIdentifier(modifiersA, modifiersB, identifier, handler, settingPaths) {
    modifiersA <> "" && modifiersB <> "" && identifier <> "" ? setUpHotkey(modifiersA . modifiersB . identifier, handler, settingPaths) :
}

setUpHotkeyWithCombo(combo, handler, settingPaths) {
    combo <> "" ? setUpHotkey(combo, handler, settingPaths) :
}

i := 0
while (i < 10) {
    hkDesktopI0 := KeyboardShortcutsIdentifiersDesktop%i%
    hkDesktopI1 := KeyboardShortcutsIdentifiersDesktopAlt%i%
    j := 0
    while (j < 2) {
        hkDesktopI := hkDesktopI%j%
        setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersSwitch, hkDesktopI, "OnShiftNumberedPress", "[KeyboardShortcutsModifiers] SwitchDesktop")
        setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersMove, hkDesktopI, "OnMoveNumberedPress", "[KeyboardShortcutsModifiers] MoveWindowToDesktop")
        setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersMoveAndSwitch, hkDesktopI, "OnMoveAndShiftNumberedPress", "[KeyboardShortcutsModifiers] MoveWindowAndSwitchToDesktop")
        setUpHotkeyWithTwoSetOfModifiersAndIdentifier(hkModifiersSwitch, hkModifiersPlusTen, hkDesktopI, "OnShiftNumberedPressNextTen", "[KeyboardShortcutsModifiers] SwitchDesktop, [KeyboardShortcutsModifiers] NextTenDesktops")
        setUpHotkeyWithTwoSetOfModifiersAndIdentifier(hkModifiersMove, hkModifiersPlusTen, hkDesktopI, "OnMoveNumberedPressNextTen", "[KeyboardShortcutsModifiers] MoveWindowToDesktop, [KeyboardShortcutsModifiers] NextTenDesktops")
        setUpHotkeyWithTwoSetOfModifiersAndIdentifier(hkModifiersMoveAndSwitch, hkModifiersPlusTen, hkDesktopI, "OnMoveAndShiftNumberedPressNextTen", "[KeyboardShortcutsModifiers] MoveWindowAndSwitchToDesktop, [KeyboardShortcutsModifiers] NextTenDesktops")
        j := j + 1
    }
    i := i + 1
}

if (!(GeneralUseNativePrevNextDesktopSwitchingIfConflicting && _IsPrevNextDesktopSwitchingKeyboardShortcutConflicting(hkModifiersSwitch, hkIdentifierPrevious))) {
    setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersSwitch, hkIdentifierPrevious, "OnShiftLeftPress", "[KeyboardShortcutsModifiers] SwitchDesktop, [KeyboardShortcutsIdentifiers] PreviousDesktop")
}
if (!(GeneralUseNativePrevNextDesktopSwitchingIfConflicting && _IsPrevNextDesktopSwitchingKeyboardShortcutConflicting(hkModifiersSwitch, hkIdentifierNext))) {
    setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersSwitch, hkIdentifierNext, "OnShiftRightPress", "[KeyboardShortcutsModifiers] SwitchDesktop, [KeyboardShortcutsIdentifiers] NextDesktop")
}

setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersMove, hkIdentifierPrevious, "OnMoveLeftPress", "[KeyboardShortcutsModifiers] MoveWindowToDesktop, [KeyboardShortcutsIdentifiers] PreviousDesktop")
setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersMove, hkIdentifierNext, "OnMoveRightPress", "[KeyboardShortcutsModifiers] MoveWindowToDesktop, [KeyboardShortcutsIdentifiers] NextDesktop")

setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersMoveAndSwitch, hkIdentifierPrevious, "OnMoveAndShiftLeftPress", "[KeyboardShortcutsModifiers] MoveWindowAndSwitchToDesktop, [KeyboardShortcutsIdentifiers] PreviousDesktop")
setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersMoveAndSwitch, hkIdentifierNext, "OnMoveAndShiftRightPress", "[KeyboardShortcutsModifiers] MoveWindowAndSwitchToDesktop, [KeyboardShortcutsIdentifiers] NextDesktop")

setUpHotkeyWithCombo(hkComboPinWin, "OnPinWindowPress", "[KeyboardShortcutsCombinations] PinWindow")
setUpHotkeyWithCombo(hkComboUnpinWin, "OnUnpinWindowPress", "[KeyboardShortcutsCombinations] UnpinWindow")
setUpHotkeyWithCombo(hkComboTogglePinWin, "OnTogglePinWindowPress", "[KeyboardShortcutsCombinations] TogglePinWindow")

setUpHotkeyWithCombo(hkComboPinApp, "OnPinAppPress", "[KeyboardShortcutsCombinations] PinApp")
setUpHotkeyWithCombo(hkComboUnpinApp, "OnUnpinAppPress", "[KeyboardShortcutsCombinations] UnpinApp")
setUpHotkeyWithCombo(hkComboTogglePinApp, "OnTogglePinAppPress", "[KeyboardShortcutsCombinations] TogglePinApp")

setUpHotkeyWithCombo(hkComboOpenDesktopManager, "OpenDesktopManager", "[KeyboardShortcutsCombinations] OpenDesktopManager")

setUpHotkeyWithCombo(hkComboChangeDesktopName, "ChangeDesktopName", "[KeyboardShortcutsCombinations] ChangeDesktopName")

if (GeneralTaskbarScrollSwitching) {
    Hotkey, ~WheelUp, OnTaskbarScrollUp
    Hotkey, ~WheelDown, OnTaskbarScrollDown
}

; ======================================================================
; Event Handlers
; ======================================================================

OnShiftNumberedPress() {
    SwitchToDesktop(substr(A_ThisHotkey, 0, 1))
}

OnShiftNumberedPressNextTen() {
    SwitchToDesktop(1 . substr(A_ThisHotkey, 0, 1))
}

OnMoveNumberedPress() {
    MoveToDesktop(substr(A_ThisHotkey, 0, 1))
}

OnMoveNumberedPressNextTen() {
    MoveToDesktop(1 . substr(A_ThisHotkey, 0, 1))
}

OnMoveAndShiftNumberedPress() {
    MoveAndSwitchToDesktop(substr(A_ThisHotkey, 0, 1))
}

OnMoveAndShiftNumberedPressNextTen() {
    MoveAndSwitchToDesktop(1 . substr(A_ThisHotkey, 0, 1))
}

OnShiftLeftPress() {
    SwitchToDesktop(_GetPreviousDesktopNumber())
}

OnShiftRightPress() {
    SwitchToDesktop(_GetNextDesktopNumber())
}

OnMoveLeftPress() {
    MoveToDesktop(_GetPreviousDesktopNumber())
}

OnMoveRightPress() {
    MoveToDesktop(_GetNextDesktopNumber())
}

OnMoveAndShiftLeftPress() {
    MoveAndSwitchToDesktop(_GetPreviousDesktopNumber())
}

OnMoveAndShiftRightPress() {
    MoveAndSwitchToDesktop(_GetNextDesktopNumber())
}

OnTaskbarScrollUp() {
    if (_IsCursorHoveringTaskbar()) {
        OnShiftLeftPress()
    }
}

OnTaskbarScrollDown() {
    if (_IsCursorHoveringTaskbar()) {
        OnShiftRightPress()
    }
}

OnPinWindowPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    _PinWindow(windowID)
    _ShowTooltipForPinnedWindow(windowTitle)
}

OnUnpinWindowPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    _UnpinWindow(windowID)
    _ShowTooltipForUnpinnedWindow(windowTitle)
}

OnTogglePinWindowPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    if (_GetIsWindowPinned(windowID)) {
        _UnpinWindow(windowID)
        _ShowTooltipForUnpinnedWindow(windowTitle)
    }
    else {
        _PinWindow(windowID)
        _ShowTooltipForPinnedWindow(windowTitle)
    }
}

OnPinAppPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    _PinApp()
    _ShowTooltipForPinnedApp(windowTitle)
}

OnUnpinAppPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    _UnpinApp()
    _ShowTooltipForUnpinnedApp(windowTitle)
}

OnTogglePinAppPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    if (_GetIsAppPinned(windowID)) {
        _UnpinApp(windowID)
        _ShowTooltipForUnpinnedApp(windowTitle)
    }
    else {
        _PinApp(windowID)
        _ShowTooltipForPinnedApp(windowTitle)
    }
}

OnDesktopSwitch(n:=1) {
    ; Give focus first, then display the popup, otherwise the popup could
    ; steal the focus from the legitimate window until it disappears.
    _FocusIfRequested()
    if (TooltipsEnabled) {
        _ShowTooltipForDesktopSwitch(n)
    }
    _ChangeAppearance(n)
    _ChangeBackground(n)

    if (previousDesktopNo) {
        _RunProgramWhenSwitchingFromDesktop(previousDesktopNo)
    }
    _RunProgramWhenSwitchingToDesktop(n)
    previousDesktopNo := n
}

; ======================================================================
; Functions
; ======================================================================

;EP
; Function to add a new desktop to the history
AddDesktopToHistory(desktopName) {
    global desktopHistory, currentIndex
    ; Add the desktop name to the array
    desktopHistory.push(desktopName)
    ; Set the current index to the latest desktop
    currentIndex := desktopHistory.MaxIndex()
}
SwitchToDesktopNoHistory(n:=1) {
    doFocusAfterNextSwitch=1
    _ChangeDesktop(n)
}

SwitchToDesktop(n:=1) {
    doFocusAfterNextSwitch=1
    _ChangeDesktop(n)
	AddDesktopToHistory(n)
}

MoveToDesktop(n:=1) {
    _MoveCurrentWindowToDesktop(n)
    _Focus()
}

MoveAndSwitchToDesktop(n:=1) {
    doFocusAfterNextSwitch=1
    _MoveCurrentWindowToDesktop(n)
    _ChangeDesktop(n)
}

OpenDesktopManager() {
    Send #{Tab}
}

; Let the user change desktop names with a prompt, without having to edit the 'settings.ini'
; file and reload the program.
; The changes are temprorary (names will be overwritten by the default values of
; 'settings.ini' when the program will be restarted.
ChangeDesktopName() {
    currentDesktopNumber := _GetCurrentDesktopNumber()
    currentDesktopName := _GetDesktopName(currentDesktopNumber)
    InputBox, newDesktopName, % changeDesktopNamesPopupTitle, % Format(changeDesktopNamesPopupText, _GetCurrentDesktopNumber()), , , , , , , , %currentDesktopName%
    ; If the user choose "Cancel" ErrorLevel is set to 1.
    if (ErrorLevel == 0) {
        _SetDesktopName(currentDesktopNumber, newDesktopName)
    }
    _ChangeAppearance(currentDesktopNumber)
}

Reload() {
    Reload
}

Exit() {
    ExitApp
}

_IsPrevNextDesktopSwitchingKeyboardShortcutConflicting(hkModifiersSwitch, hkIdentifierNextOrPrevious) {
    return ((hkModifiersSwitch == "<#<^" || hkModifiersSwitch == ">#<^" || hkModifiersSwitch == "#<^" || hkModifiersSwitch == "<#>^" || hkModifiersSwitch == ">#>^" || hkModifiersSwitch == "#>^" || hkModifiersSwitch == "<#^" || hkModifiersSwitch == ">#^" || hkModifiersSwitch == "#^") && (hkIdentifierNextOrPrevious == "Left" || hkIdentifierNextOrPrevious == "Right"))
}

_IsCursorHoveringTaskbar() {
    MouseGetPos,,, mouseHoveringID
    if (!taskbarPrimaryID) {
        WinGet, taskbarPrimaryID, ID, ahk_class Shell_TrayWnd
    }
    if (!taskbarSecondaryID) {
        WinGet, taskbarSecondaryID, ID, ahk_class Shell_SecondaryTrayWnd
    }
    return (mouseHoveringID == taskbarPrimaryID || mouseHoveringID == taskbarSecondaryID)
}

_GetCurrentWindowID() {
    WinGet, activeHwnd, ID, A
    return activeHwnd
}

_GetCurrentWindowTitle() {
    WinGetTitle, activeHwnd, A
    return activeHwnd
}

_TruncateString(string:="", n:=10) {
    return (StrLen(string) > n ? SubStr(string, 1, n-3) . "..." : string)
}

_GetDesktopName(n:=1) {
    if (n == 0) {
        n := 10
    }
    name := DesktopNames%n%
    if (!name) {
        name := "Desktop " . n
    }
    return name
}

; Set the name of the nth desktop to the value of a given string.
_SetDesktopName(n:=1, name:=0) {
    if (n == 0) {
        n := 10
    }
    if (!name) {
        ; Default value: "Desktop N".
        name := "Desktop " %n%
    }
    DesktopNames%n% := name
}

_GetNextDesktopNumber() {
    i := _GetCurrentDesktopNumber()
	if (GeneralDesktopWrapping == 1) {
		i := (i == _GetNumberOfDesktops() ? 1 : i + 1)
	} else {
		i := (i == _GetNumberOfDesktops() ? i : i + 1)
	}

    return i
}

_GetPreviousDesktopNumber() {
    i := _GetCurrentDesktopNumber()
	if (GeneralDesktopWrapping == 1) {
		i := (i == 1 ? _GetNumberOfDesktops() : i - 1)
	} else {
		i := (i == 1 ? i : i - 1)
	}

    return i
}

_GetCurrentDesktopNumber() {
    return DllCall(GetCurrentDesktopNumberProc) + 1
}

_GetNumberOfDesktops() {
    return DllCall(GetDesktopCountProc)
}

_MoveCurrentWindowToDesktop(n:=1) {
    activeHwnd := _GetCurrentWindowID()
    DllCall(MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, n-1)
}

_ChangeDesktop(n:=1) {
    if (n == 0) {
        n := 10
    }
    DllCall(GoToDesktopNumberProc, Int, n-1)
}

_CallWindowProc(proc, window:="") {
    if (window == "") {
        window := _GetCurrentWindowID()
    }
    return DllCall(proc, UInt, window)
}

_PinWindow(windowID:="") {
    _CallWindowProc(PinWindowProc, windowID)
}

_UnpinWindow(windowID:="") {
    _CallWindowProc(UnpinWindowProc, windowID)
}

_GetIsWindowPinned(windowID:="") {
    return _CallWindowProc(IsPinnedWindowProc, windowID)
}

_PinApp(windowID:="") {
    _CallWindowProc(PinAppProc, windowID)
}

_UnpinApp(windowID:="") {
    _CallWindowProc(UnpinAppProc, windowID)
}

_GetIsAppPinned(windowID:="") {
    return _CallWindowProc(IsPinnedAppProc, windowID)
}

_RunProgram(program:="", settingName:="") {
    if (program <> "") {
        if (FileExist(program)) {
            Run, % program
        }
        else {
            MsgBox, 16, Error, The program "%program%" is not valid. `nPlease reconfigure the "%settingName%" setting. `n`nPlease read the README for instructions.
        }
    }
}

_RunProgramWhenSwitchingToDesktop(n:=1) {
    if (n == 0) {
        n := 10
    }
    _RunProgram(RunProgramWhenSwitchingToDesktop%n%, "[RunProgramWhenSwitchingToDesktop] " . n)
}

_RunProgramWhenSwitchingFromDesktop(n:=1) {
    if (n == 0) {
        n := 10
    }
    _RunProgram(RunProgramWhenSwitchingFromDesktop%n%, "[RunProgramWhenSwitchingFromDesktop] " . n)
}

_ChangeBackground(n:=1) {
    line := Wallpapers%n%
    isHex := RegExMatch(line, "^0x([0-9A-Fa-f]{1,6})", hexMatchTotal)
    if (isHex) {
        hexColorReversed := SubStr("00000" . hexMatchTotal1, -5)

        RegExMatch(hexColorReversed, "^([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})", match)
        hexColor := "0x" . match3 . match2 . match1, hexColor += 0

        DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, "", UInt, 1)
        DllCall("SetSysColors", "Int", 1, "Int*", 1, "UInt*", hexColor)
    }
    else {
        filePath := line

        isRelative := (substr(filePath, 1, 1) == ".")
        if (isRelative) {
            filePath := (A_WorkingDir . substr(filePath, 2))
        }
        if (filePath and FileExist(filePath)) {
            DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, filePath, UInt, 1)
        }
    }
}

_ChangeAppearance(n:=1) {
    Menu, Tray, Tip, % _GetDesktopName(n)
    if (FileExist("./icons/" . n ".ico")) {
        Menu, Tray, Icon, icons/%n%.ico
    }
    else {
        Menu, Tray, Icon, icons/+.ico
    }
}

; Only give focus to the foremost window if it has been requested.
_FocusIfRequested() {
    if (doFocusAfterNextSwitch) {
        _Focus()
        doFocusAfterNextSwitch=0
    }
}

; Give focus to the foremost window on the desktop.
_Focus() {
    foremostWindowId := _GetForemostWindowIdOnDesktop(_GetCurrentDesktopNumber())
    WinActivate, ahk_id %foremostWindowId%
}

; Select the ahk_id of the foremost window in a given virtual desktop.
_GetForemostWindowIdOnDesktop(n) {
    if (n == 0) {
        n := 10
    }
    ; Desktop count starts at 1 for this script, but at 0 for Windows.
    n -= 1

    ; winIDList contains a list of windows IDs ordered from the top to the bottom for each desktop.
    WinGet winIDList, list
    Loop % winIDList {
        windowID := % winIDList%A_Index%
        windowIsOnDesktop := DllCall(IsWindowOnDesktopNumberProc, UInt, WindowID, UInt, n)
        ; Select the first (and foremost) window which is in the specified desktop.
        if (WindowIsOnDesktop == 1) {
            return WindowID
        }
    }
}

_ShowTooltip(message:="") {
    params := {}
    params.message := message
    params.lifespan := TooltipsLifespan
    params.position := TooltipsCentered
    params.fontSize := TooltipsFontSize
    params.fontWeight := TooltipsFontInBold
    params.fontColor := TooltipsFontColor
    params.backgroundColor := TooltipsBackgroundColor
    Toast(params)
}

_ShowTooltipForDesktopSwitch(n:=1) {
    if (n == 0) {
        n := 10
    }
    _ShowTooltip(_GetDesktopName(n))
}

_ShowTooltipForPinnedWindow(windowTitle) {
    _ShowTooltip("Window """ . _TruncateString(windowTitle, 30) . """ pinned.")
}

_ShowTooltipForUnpinnedWindow(windowTitle) {
    _ShowTooltip("Window """ . _TruncateString(windowTitle, 30) . """ unpinned.")
}

_ShowTooltipForPinnedApp(windowTitle) {
    _ShowTooltip("App """ . _TruncateString(windowTitle, 30) . """ pinned.")
}

_ShowTooltipForUnpinnedApp(windowTitle) {
    _ShowTooltip("App """ . _TruncateString(windowTitle, 30) . """ unpinned.")
}

; Function to show the current desktop in history
ShowCurrentDesktop() {
    global desktopHistory, currentIndex
    if (currentIndex > 0 && currentIndex <= desktopHistory.MaxIndex()) {
        SwitchToDesktopNoHistory(desktopHistory[currentIndex])
    } else {
        ToolTip "No desktop history available."
    }
}

GoPreviousDesktop() {
    global currentIndex, desktopHistory
    if (currentIndex > 1) {
        currentIndex--
        ShowCurrentDesktop()
    } else {
        ToolTip "Already at the first desktop in history."
		Sleep 500
		ToolTip
    }
}

GoNextDesktop() {
    global currentIndex, desktopHistory
    if (currentIndex < desktopHistory.MaxIndex()) {
        currentIndex++
        ShowCurrentDesktop()
    } else {
        ToolTip "Already at the last desktop in history."
		Sleep 500
		ToolTip
    }
}




; Time threshold for long press (in milliseconds)
longPressThreshold := 500  ; 500 ms (half a second)

; Variables to track the key state and timer for XButton1
XButton1keyPressStart := 0
isXButton1Pressed := false



; Detect when XButton1 is pressed down (Start the timer)
XButton1::
    if (!isXButton1Pressed) {
        isXButton1Pressed := true
        XButton1keyPressStart := A_TickCount  ; Record the time when XButton1 is pressed
        SetTimer, CheckLongPressXButton1, % -longPressThreshold  ; Start the timer with negative delay (to run only once)
    }
return

; Detect when XButton1 is released (Stop the timer and handle short press)
XButton1 Up::
    isXButton1Pressed := false
    SetTimer, CheckLongPressXButton1, Off  ; Stop the timer
    pressDuration := A_TickCount - XButton1keyPressStart
    if (pressDuration < longPressThreshold) {
        ;MsgBox Short press detected on XButton1!
		
		if (currentIndex < desktopHistory.MaxIndex()){
			GoNextDesktop()
		} else {
			GoPreviousDesktop()
		}
		
        ; Add action for short press
    }
return

; Timer function to check for long press on XButton1
CheckLongPressXButton1:
    if (isXButton1Pressed) {  ; Check if the key is still being held
        ; MsgBox Long press detected on XButton1!
        ; Add action for long press
		ShowDesktopSelection()
    }
return

selectedDesktop := 0



desktopCoords := {}  ; Dictionary to store button coordinates
titleBarHeight = 0
guiStartCenterX := 0
guiStartCenterY := 0

MonitorMouseMovTimerOK := false

; Function to display desktop selection GUI in a clock-like arrangement, centered at mouse position
ShowDesktopSelection() {
    global selectedDesktop, desktopCoords  ; Make these variables global
	
	global guiStartCenterX
	global guiStartCenterY

    ; Get the current mouse position
	MouseGetPos, mouseX, mouseY ; Relative to the focused window

	; Get the position of the focused window
	WinGetPos, winX, winY, , , A ; Retrieves the window position and size of the active window

	; Calculate the absolute mouse position
	absoluteMouseX := mouseX + winX
	absoluteMouseY := mouseY + winY
	
	guiStartCenterX := absoluteMouseX
	guiStartCenterY := absoluteMouseY

	Gui, +AlwaysOnTop -Caption ; Always on top, no title bar or window decorations
    Gui, Add, Text,, Select a desktop to switch to:

	gridX0 := 10
	gridW := 50
	gridY0 := 30
	gridH := 50
	buttonW := 40
	buttonH := 30

    Loop, 9 {
        Row := Ceil(A_Index / 3)  ; Determine the row (1 to 3)
        Col := Mod(A_Index - 1, 3)  ; Determine the column (0 to 2)
        xPos := Col * gridW + gridX0  ; Set X position based on column (adjust 50 for width)
        yPos := (Row - 1) * gridH + gridY0  ; Set Y position based on row (adjust 50 for height)
        Gui, Add, Button, x%xPos% y%yPos% w%buttonW% h%buttonH% gSwitchDesktop, %A_Index%
    }
	windowX := absoluteMouseX - gridX0 - gridW - 0.5*buttonW - 20
	windowY := absoluteMouseY - gridY0 - gridH - 0.5*buttonH - 25

    ; Show the GUI centered at the mouse position
    Gui, Show, x%windowX% y%windowY%, Select Desktop
	
	MonitorMouseMovTimerOK := true
	SetTimer, MonitorMouseMov, 50
}

MonitorMouseMov:
	global MonitorMouseMovTimerOK
	global guiStartCenterX
	global guiStartCenterY
	if(MonitorMouseMovTimerOK){

		; Example to get absolute mouse position
		MouseGetPos, mouseX, mouseY ; Relative to the focused window

		; Get the position of the focused window
		WinGetPos, winX, winY, , , A ; Retrieves the window position and size of the active window

		; Calculate the absolute mouse position
		absoluteMouseX := mouseX + winX
		absoluteMouseY := mouseY + winY
	
		delta := 40
		delta0 := 60
		
		dx := absoluteMouseX - guiStartCenterX
		dy := absoluteMouseY - guiStartCenterY
		
		deltaX := 0
		deltaY := 0
		if ((Abs(dx) > delta) or (Abs(dy) > delta)){
		
			if(Abs(dx) <= delta){
				y_th := delta0
			} else {
				y_th := delta
			}
			if(Abs(dy) <= delta){
				x_th := delta0
			} else {
				x_th := delta
			}
			
			if(dy < -1 * y_th) {
				deltaY := -1
			} else if (dy > y_th){
				deltaY := 1
			}

			if(dx < -1 * x_th) {
				deltaX := -1
			} else if (dx > x_th){
				deltaX := 1
			}
			
		}
		
		if((Abs(deltaY)+Abs(deltaX)) > 0) {
			selectedDesktop := 1 + deltaX + 1  + 3 * deltaY  + 3

			GuiClose()
			
			Sleep, 100
		;	SwitchToDesktop(selectedDesktop)
			_ChangeDesktop(selectedDesktop)
			AddDesktopToHistory(selectedDesktop)
		}
	}
return

; Function to handle desktop switch on mouse hover
SwitchDesktop:
    ; Extract the number from the button text
    ButtonText := A_GuiControl
    selectedDesktop := RegExReplace(ButtonText, " .+")  ; Extract the number from the button text
    
	GuiClose()

	Sleep, 100
;	SwitchToDesktop(selectedDesktop)
	_ChangeDesktop(selectedDesktop)
	AddDesktopToHistory(selectedDesktop)
	
return

; Function to handle GUI close
GuiClose() {
    ToolTip  ; Hide tooltip
    Gui, Destroy
	MonitorMouseMovTimerOK := false
	SetTimer, MonitorMouseMov, Off
}

; Function to handle desktop switch
SwitchDesktopOLD:
    ButtonText := A_GuiControl  ; Get the name of the button clicked
    selectedDesktop := RegExReplace(ButtonText, "[^\d]")  ; Extract the number from the button text
    ; MsgBox You selected Desktop %selectedDesktop%!
    ; Here, you can add logic to switch to the appropriate desktop
    
	GuiClose()
	
	
	Sleep, 100
;	SwitchToDesktop(selectedDesktop)
	_ChangeDesktop(selectedDesktop)
	AddDesktopToHistory(selectedDesktop)
return


mousePosTimerON := false
^F7::
	mousePosTimerON := true
	SetTimer, ShowMousePosTooltip, 50
return

^F8::
	mousePosTimerON := false
	SetTimer, ShowMousePosTooltip, Off
	ToolTip, Stopped
	Sleep, 500
	ToolTip
return

^F6::
	; Example to get absolute mouse position
	MouseGetPos, mouseX, mouseY ; Relative to the focused window

	; Get the position of the focused window
	WinGetPos, winX, winY, , , A ; Retrieves the window position and size of the active window

	; Calculate the absolute mouse position
	absoluteMouseX := mouseX + winX
	absoluteMouseY := mouseY + winY
    Gui, New
    Gui, Add, Text,, X
    Gui, Show, x%absoluteMouseX% y%absoluteMouseY%, Test

return

ShowMousePosTooltip:
	global mousePosTimerON
	if (mousePosTimerON) {
		; Example to get absolute mouse position
		MouseGetPos, mouseX, mouseY ; Relative to the focused window

		; Get the position of the focused window
		WinGetPos, winX, winY, , , A ; Retrieves the window position and size of the active window

		; Calculate the absolute mouse position
		absoluteMouseX := mouseX + winX
		absoluteMouseY := mouseY + winY
		ToolTip, x=%mouseX%_y=%mouseY%___ax=%absoluteMouseX%_ay=%absoluteMouseY%
	}
return



lastBeforeForced1 := 7

XButton2::
	global lastBeforeForced1
	currentDesktop := _GetCurrentDesktopNumber()
	if(currentDesktop = 1){
		SwitchToDesktopNoHistory(lastBeforeForced1)
	} else {
		lastBeforeForced1 := currentDesktop
		SwitchToDesktopNoHistory(1)
	}
	global isForced1, lastBeforeForced1
	isForced1 := !isForced1
return
