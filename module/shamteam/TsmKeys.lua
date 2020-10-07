keys[71] = {
    func = function(pn, enable) -- g (display GUI for shamans)
        if not ThisRound.is_lobby and ThisRound:isShaman(pn) then
            if enable then
                TsmWindow.open(WINDOW_GUI, pn)
            else
                TsmWindow.close(WINDOW_GUI, pn)
            end
        end
    end,
    trigger = DOWN_UP
}

keys[72] = {
    func = function(pn) -- h (display help)
        if TsmWindow.isOpened(WINDOW_HELP, pn) then
            TsmWindow.close(WINDOW_HELP, pn)
        else
            TsmWindow.open(WINDOW_HELP, pn)
        end
    end,
    trigger = DOWN_ONLY
}

keys[79] = {
    func = function(pn) -- o (display player options)
        if TsmWindow.isOpened(WINDOW_OPTIONS, pn) then
            TsmWindow.close(WINDOW_OPTIONS, pn)
        else
            TsmWindow.open(WINDOW_OPTIONS, pn)
        end
    end,
    trigger = DOWN_ONLY
}

keys[80] = {
    func = function(pn) -- p (display player profile)
        if TsmWindow.isOpened(WINDOW_PROFILE, pn) then
            TsmWindow.close(WINDOW_PROFILE, pn)
        elseif players[pn] then
            TsmWindow.open(WINDOW_PROFILE, pn)
        end
    end,
    trigger = DOWN_ONLY
}

keys[85] = {
    func = function(pn) -- u (undo spawn)
        if ThisRound:isShaman(pn) and not ThisRound.is_lobby then
            ThisRound:doUndo(pn)
        end
    end,
    trigger = DOWN_ONLY
}
