do
    TsmWindow = {}
    local INDEPENDENT = 1  -- window is able to stay open regardless of other open windows
    local MUTUALLY_EXCLUSIVE = 2  -- window will close other mutually exclusive windows that are open

    local help_ta_range = {
        ['Welcome'] = {WINDOW_HELP+21, WINDOW_HELP+22},
        ['Rules'] = {WINDOW_HELP+31, WINDOW_HELP+32},
        ['Commands'] = {WINDOW_HELP+41, WINDOW_HELP+42},
        ['Contributors'] = {WINDOW_HELP+51, WINDOW_HELP+52},
    }
    -- WARNING: No error checking, ensure that all your windows have all the required attributes (open, close, type, players)
    local windows = {
        [WINDOW_GUI] = {
            open = function(pn, p_data, tab)
                local T = {{72,"?"},{79,"O"},{80,"P"}}
                local x, y = 800-(30*(#T+1)), 25
                for i,m in ipairs(T) do
                    ui.addTextArea(WINDOW_GUI+i,"<p align='center'><a href='event:triggerkey!"..m[1].."'>"..m[2], pn, x+(i*30), y, 20, 0, 1, 0, .7, true)
                end
            end,
            close = function(pn, p_data)
                for i = 1, 3 do
                    ui.removeTextArea(WINDOW_GUI+i, pn)
                end
            end,
            type = INDEPENDENT,
            players = {}
        },
        [WINDOW_HELP] = {
            open = function(pn, p_data, tab)
                local tabs = {
                    {'Welcome', 'help_tab_welcome'},
                    {'Rules', 'help_tab_rules'},
                    {'Commands', 'help_tab_commands'},
                    {'Contributors', 'help_tab_contributors'},
                    {'Close', 'close'}
                }
                local tabs_k = {['Welcome']=true,['Rules']=true,['Commands']=true,['Contributors']=true}
                tab = tab or 'Welcome'

                if not tabs_k[tab] then return end
                if not p_data.tab then
                    ui.addTextArea(WINDOW_HELP+1,"",pn,75,40,650,340,0x133337,0x133337,1,true)  -- the background
                else  -- already opened before
                    if help_ta_range[p_data.tab] then
                        for i = help_ta_range[p_data.tab][1], help_ta_range[p_data.tab][2] do
                            ui.removeTextArea(i, pn)
                        end
                    end
                    if p_data.images[p_data.tab] then
                        for i = 1, #p_data.images[p_data.tab] do
                            tfm.exec.removeImage(p_data.images[p_data.tab][i])
                        end
                        p_data.images[p_data.tab] = nil
                    end
                end
                for i, v in pairs(tabs) do
                    local iden, tl_key = v[1], v[2]
                    local translated = players[pn]:tlFmt(tl_key)
                    local opacity = (iden == tab) and 0 or 1 
                    ui.addTextArea(WINDOW_HELP+1+i, GUI_BTN.."<font size='2'><br><font size='12'><p align='center'><a href='event:help!"..iden.."'>"..translated.."\n</a>",pn,92+((i-1)*130),50,100,24,0x666666,0x676767,opacity,true)
                end
                p_data.tab = tab

                if tab == "Welcome" then
                    local text = players[pn]:tlFmt("help_content_welcome", GUI_BTN, LINK_DISCORD)
                    ui.addTextArea(WINDOW_HELP+21,text,pn,88,95,625,nil,0,0,0,true)
                elseif tab == "Rules" then
                    local text = players[pn]:tlFmt("help_content_rules")
                    ui.addTextArea(WINDOW_HELP+31,text,pn,88,95,625,nil,0,0,0,true)
                elseif tab == "Commands" then
                    local text = players[pn]:tlFmt("help_content_commands")
                    ui.addTextArea(WINDOW_HELP+41,text,pn,88,95,625,nil,0,0,0,true)
                elseif tab == "Contributors" then
                    local text = players[pn]:tlFmt("help_content_contributors")
                    ui.addTextArea(WINDOW_HELP+51,text,pn,88,95,625,nil,0,0,0,true)
                    --local img_id = tfm.exec.addImage("172cde7e326.png", "&1", 571, 180, pn)
                    --p_data.images[tab] = {img_id}
                end
            end,
            close = function(pn, p_data)
                for i = 1, 10 do
                    ui.removeTextArea(WINDOW_HELP+i, pn)
                end
                if help_ta_range[p_data.tab] then
                    for i = help_ta_range[p_data.tab][1], help_ta_range[p_data.tab][2] do
                        ui.removeTextArea(i, pn)
                    end
                end
                if p_data.images[p_data.tab] then
                    for i = 1, #p_data.images[p_data.tab] do
                        tfm.exec.removeImage(p_data.images[p_data.tab][i])
                    end
                    p_data.images[p_data.tab] = nil
                end
                p_data.tab = nil
            end,
            type = MUTUALLY_EXCLUSIVE,
            players = {}
        },
        [WINDOW_LOBBY] = {
            open = function(pn, p_data)
                p_data.images = { main={}, mode={}, help={}, toggle={} }

                local header = players[pn]:tlFmt(ThisRound:isShaman(pn) and "chosen_shaman" or "shamans_choosing")
                ui.addTextArea(WINDOW_LOBBY+1,"<p align='center'><font size='13'>"..header,pn,75,50,650,nil,1,0,1,true)
                p_data.images.main[1] = {tfm.exec.addImage(IMG_LOBBY_BG, ":"..WINDOW_LOBBY, 70, 40, pn)}

                -- shaman cards
                ui.addTextArea(WINDOW_LOBBY+2,"<p align='center'><font size='13'><b>"..pnDisp(ThisRound.shamans[1]),pn,118,90,269,nil,1,0,1,true)
                ui.addTextArea(WINDOW_LOBBY+3,"<p align='center'><font size='13'><b>"..pnDisp(ThisRound.shamans[2]),pn,413,90,269,nil,1,0,1,true)

                -- mode
                p_data.images.mode[TSM_HARD] = {tfm.exec.addImage(ThisRound.chosen_mode == TSM_HARD and IMG_FEATHER_HARD or IMG_FEATHER_HARD_DISABLED, ":"..WINDOW_LOBBY, 202, 125, pn), 202, 125}
                p_data.images.mode[TSM_DIV] = {tfm.exec.addImage(ThisRound.chosen_mode == TSM_DIV and IMG_FEATHER_DIVINE or IMG_FEATHER_DIVINE_DISABLED, ":"..WINDOW_LOBBY, 272, 125, pn), 272, 125}

                ui.addTextArea(WINDOW_LOBBY+4, string.format("<a href='event:setmode!%s'><font size='35'>\n", TSM_HARD), pn, 202, 125, 35, 40, 1, 0, 0, true)
                ui.addTextArea(WINDOW_LOBBY+5, string.format("<a href='event:setmode!%s'><font size='35'>\n", TSM_DIV), pn, 272, 125, 35, 40, 1, 0, 0, true)

                -- difficulty
                ui.addTextArea(WINDOW_LOBBY+6,"<p align='center'><font size='13'><b>Difficulty",pn,120,184,265,nil,1,0,.2,true)
                ui.addTextArea(WINDOW_LOBBY+7,"<p align='center'><font size='13'>to",pn,240,240,30,nil,1,0,0,true)
                ui.addTextArea(WINDOW_LOBBY+8,"<p align='center'><font size='13'><b>"..ThisRound.chosen_diff[1],pn,190,240,20,nil,1,0,.2,true)
                ui.addTextArea(WINDOW_LOBBY+9,"<p align='center'><font size='13'><b>"..ThisRound.chosen_diff[2],pn,299,240,20,nil,1,0,.2,true)
                ui.addTextArea(WINDOW_LOBBY+10,GUI_BTN.."<p align='center'><font size='17'><b><a href='event:setdiff!1&1'>&#x25B2;</a><br><a href='event:setdiff!1&-1'>&#x25BC;",pn,132,224,20,nil,1,0,0,true)
                ui.addTextArea(WINDOW_LOBBY+11,GUI_BTN.."<p align='center'><font size='17'><b><a href='event:setdiff!2&1'>&#x25B2;</a><br><a href='event:setdiff!2&-1'>&#x25BC;",pn,350,224,20,nil,1,0,0,true)

                -- mods
                local mods_str = {}
                local mods_helplink_str = {}
                local i = 1
                for k, mod in pairs(GAME_MODS) do
                    mods_str[#mods_str+1] = string.format("<a href='event:modtoggle!%s'>%s", k, players[pn]:tlFmt(mod[1]))
                    local is_set = ThisRound.chosen_mods[k]
                    local x, y = 640, 120+((i-1)*25)
                    p_data.images.toggle[k] = {tfm.exec.addImage(is_set and IMG_TOGGLE_ON or IMG_TOGGLE_OFF, ":"..WINDOW_LOBBY, x, y, pn), x, y}
                    
                    x = 425
                    y = 125+((i-1)*25)
                    p_data.images.help[k] = {tfm.exec.addImage(IMG_HELP, ":"..WINDOW_LOBBY, x, y, pn), x, y}
                    mods_helplink_str[#mods_helplink_str+1] = string.format("<a href='event:modhelp!%s'>", k)

                    i = i + 1
                end
                ui.addTextArea(WINDOW_LOBBY+12, table.concat(mods_str, "\n\n").."\n", pn,450,125,223,nil,1,0,0,true)
                ui.addTextArea(WINDOW_LOBBY+13, "<font size='11'>"..table.concat(mods_helplink_str, "\n\n").."\n", pn,422,123,23,nil,1,0,0,true)

                -- help and xp multiplier text
                ui.addTextArea(WINDOW_LOBBY+14,"<p align='center'><i><J>",pn,120,300,560,nil,1,0,0,true)
                ui.addTextArea(WINDOW_LOBBY+15,"<p align='center'><font size='13'><N>Exp multiplier:<br><font size='15'>"..expDisp(ThisRound:getExpMult()),pn,330,333,140,nil,1,0,0,true)

                -- ready
                ui.addTextArea(WINDOW_LOBBY+16, GUI_BTN.."<font size='2'><br><font size='12'><p align='center'><a href='event:setready'>".."&#9744; Ready".."</a>",pn,200,340,100,24,0x666666,0x676767,1,true)
                ui.addTextArea(WINDOW_LOBBY+17, GUI_BTN.."<font size='2'><br><font size='12'><p align='center'><a href='event:setready'>".."&#9744; Ready".."</a>",pn,500,340,100,24,0x666666,0x676767,1,true)
            end,
            close = function(pn, p_data)
                for i = 1, 17 do
                    ui.removeTextArea(WINDOW_LOBBY+i, pn)
                end
                for _, imgs in pairs(p_data.images) do
                    for k, img_dat in pairs(imgs) do
                        tfm.exec.removeImage(img_dat[1])
                    end
                end
                p_data.images = {}
            end,
            type = INDEPENDENT,
            players = {}
        },
        [WINDOW_OPTIONS] = {
            open = function(pn, p_data)
                p_data.images = { main={}, toggle={}, help={} }

                p_data.images.main[1] = {tfm.exec.addImage(IMG_OPTIONS_BG, ":"..WINDOW_OPTIONS, 520, 47, pn)}
                ui.addTextArea(WINDOW_OPTIONS+1, "<font size='3'><br><p align='center'><font size='13'><J><b>Settings", pn, 588,52, 102,30, 1, 0, 0, true)
                ui.addTextArea(WINDOW_OPTIONS+2, "<a href='event:options!close'><font size='30'>\n", pn, 716,48, 31,31, 1, 0, 0, true)

                local opts_str = {}
                local opts_helplink_str = {}
                local i = 1
                for k, opt in pairs(PLAYER_OPTIONS) do
                    opts_str[#opts_str+1] = string.format("<a href='event:opttoggle!%s'>%s", k, players[pn]:tlFmt(opt[1]))
                    local is_set = players[pn].toggles[k]
                    local x, y = 716, 100+((i-1)*25)
                    p_data.images.toggle[k] = {tfm.exec.addImage(is_set and IMG_TOGGLE_ON or IMG_TOGGLE_OFF, ":"..WINDOW_OPTIONS, x, y, pn), x, y}
                    
                    x = 540
                    y = 105+((i-1)*25)
                    p_data.images.help[k] = {tfm.exec.addImage(IMG_HELP, ":"..WINDOW_OPTIONS, x, y, pn), x, y}
                    opts_helplink_str[#opts_helplink_str+1] = string.format("<a href='event:opthelp!%s'>", k)

                    i = i+1
                end
                ui.addTextArea(WINDOW_OPTIONS+3, table.concat(opts_str, "\n\n").."\n", pn,560,105,223,nil,1,0,0,true)
                ui.addTextArea(WINDOW_OPTIONS+4, "<font size='11'>"..table.concat(opts_helplink_str, "\n\n").."\n", pn,540,103,23,nil,1,0,0,true)
            end,
            close = function(pn, p_data)
                for i = 1, 5 do
                    ui.removeTextArea(WINDOW_OPTIONS+i, pn)
                end
                for _, imgs in pairs(p_data.images) do
                    for k, img_dat in pairs(imgs) do
                        tfm.exec.removeImage(img_dat[1])
                    end
                end
                p_data.images = {}
            end,
            type = MUTUALLY_EXCLUSIVE,
            players = {}
        },
        [WINDOW_PROFILE] = {
            open = function(pn, p_data)
                local player = players[pn]
                local currentExp = player.exp
                local currentLevel = expToLevel(currentExp)
                local str = ("%s\n\nEXP: %s / %s\n%s: %s"):format(
                        pn, currentExp, levelToExp(currentLevel + 1),
                        player:tlFmt("level"), currentLevel)

                ui.addTextArea(WINDOW_PROFILE+1, str, pn, 170, 60, 70, nil, 1, 0, .8, true)
            end,
            close = function(pn, p_data)
                for i = 1, 1 do
                    ui.removeTextArea(WINDOW_PROFILE+i, pn)
                end
            end,
            type = INDEPENDENT,
            players = {},
        },
        [WINDOW_DB_MAP] = {
            open = function(pn, p_data)
                local tabs = {"Add", "Remove", "&#9587; Close"}
                local tabstr = "<p align='center'><V>"..string.rep("&#x2500;", 6).."<br>"
                local t_str = {"<p align='center'><font size='15'>Modify map</font><br>"}

                for i = 1, #tabs do
                    local t = tabs[i]
                    local col = GUI_BTN
                    tabstr = tabstr..string.format("%s<a href='event:dbmap!%s'>%s</a><br><V>%s<br>", col, t, t, string.rep("&#x2500;", 6))
                end

                t_str[#t_str+1] = "<ROSE>@"..roundv.mapinfo.code.."<br><V>"..string.rep("&#x2500;", 15).."</p><p align='left'><br>"
                

                ui.addTextArea(WINDOW_DB_MAP+1, tabstr, pn, 170, 60, 70, nil, 1, 0, .8, true)
	            ui.addTextArea(WINDOW_DB_MAP+2, table.concat(t_str), pn, 250, 50, 300, 300, 1, 0, .8, true)
            end,
            close = function(pn, p_data)
                for i = 1, 2 do
                    ui.removeTextArea(WINDOW_DB_MAP+i, pn)
                end
            end,
            type = INDEPENDENT,
            players = {}
        },
        [WINDOW_DB_HISTORY] = {
            open = function(pn, p_data)
                ui.addTextArea(WINDOW_DB_HISTORY+1,"",pn,75,40,650,340,0x133337,0x133337,1,true)  -- the background
            end,
            close = function(pn, p_data)
                for i = 1, 5 do
                    ui.removeTextArea(WINDOW_DB_HISTORY+i, pn)
                end
            end,
            type = INDEPENDENT,
            players = {}
        },
    }

    TsmWindow.open = function(window_id, pn, ...)
        if not windows[window_id] then
            return
        elseif not pn then
            for name in pairs(room.playerList) do
                TsmWindow.open(window_id, name, table.unpack(arg))
            end
            return
        elseif not windows[window_id].players[pn] then
            windows[window_id].players[pn] = {images={}}
        end
        if windows[window_id].type == MUTUALLY_EXCLUSIVE then
            for w_id, w in pairs(windows) do
                if w_id ~= window_id and w.type == MUTUALLY_EXCLUSIVE then
                    TsmWindow.close(w_id, pn)
                end
            end
        end
        windows[window_id].players[pn].is_open = true
        windows[window_id].open(pn, windows[window_id].players[pn], table.unpack(arg))
    end

    TsmWindow.close = function(window_id, pn)
        if not pn then
            for name in pairs(room.playerList) do
                TsmWindow.close(window_id, name)
            end
        elseif TsmWindow.isOpened(window_id, pn) then
            windows[window_id].close(pn, windows[window_id].players[pn])
            windows[window_id].players[pn].is_open = false
        end
    end

    -- Hook this on to eventPlayerLeft, where all of the player's windows would be closed
    TsmWindow.clearPlayer = function(pn)
        for w_id in pairs(windows) do
            windows[w_id].players[pn] = nil
        end
    end

    TsmWindow.isOpened = function(window_id, pn)
        return windows[window_id]
            and windows[window_id].players[pn]
            and windows[window_id].players[pn].is_open
    end

    TsmWindow.getImages = function(window_id, pn)
        if TsmWindow.isOpened(window_id, pn) then
            return windows[window_id].players[pn].images
        end
        return {}
    end 
end
