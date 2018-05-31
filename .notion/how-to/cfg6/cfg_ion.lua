--
-- Ion main configuration file
--
-- This file only includes some settings that are rather frequently altered.
-- The rest of the settings are in cfg_ioncore.lua and individual modules'
-- configuration files (cfg_modulename.lua).
--

-- Set default modifiers. Alt should usually be mapped to Mod1 on
-- XFree86-based systems. The flying window keys are probably Mod3
-- or Mod4; see the output of 'xmodmap'.
-- These may be defined in /etc/default/ion3, loaded as cfg_debian.
--dopath("cfg_debian")
META="Mod4+"
ALTMETA="Mod4+Shift+"

-- Terminal emulator
XTERM="run_term"

-- Debian sets the META and ALTMETA keys in /etc/default/ion3.
--dopath("cfg_debian")

-- Some basic settings
ioncore.set{
    -- Maximum delay between clicks in milliseconds to be considered a
    -- double click.
    --dblclick_delay=250,

    -- For keyboard resize, time (in milliseconds) to wait after latest
    -- key press before automatically leaving resize mode (and doing
    -- the resize in case of non-opaque move).
    --kbresize_delay=1500,

    -- Opaque resize?
    --opaque_resize=false,

    -- Movement commands warp the pointer to frames instead of just
    -- changing focus. Enabled by default.
    warp=false,
    
    -- Switch frames to display newly mapped windows
    --switchto=true,
    
    -- Default index for windows in frames: one of 'last', 'next' (for
    -- after current), or 'next-act' (for after current and anything with
    -- activity right after it).
    --frame_default_index='next',
    
    -- Auto-unsqueeze transients/menus/queries.
    --unsqueeze=true,
    
    -- Display notification tooltips for activity on hidden workspace.
    --screen_notify=true,

    float_placement_padding=0,
}


-- Load default settings. The file cfg_defaults loads all the files
-- commented out below, except mod_dock. If you do not want to load
-- something, comment out this line, and uncomment the lines corresponding
-- the the modules or configuration files that you want, below.
-- The modules' configuration files correspond to the names of the 
-- modules with 'mod' replaced by 'cfg'.
--dopath("cfg_defaults")

-- Load configuration of the Ion 'core'
dopath("cfg_ioncore")

-- Load some kludges to make apps behave better.
dopath("cfg_kludges")

-- Define some layouts. 
dopath("cfg_layouts")

-- Load some modules. 
dopath("mod_query")
dopath("mod_menu")
dopath("mod_tiling")
--if os.getenv("GNOME_DESKTOP_SESSION_ID") then
    dopath("mod_dock")
--else
--    dopath("mod_statusbar")
--end
--dopath("mod_sp")
dopath("mod_xrandr")

--
-- Common customisations
--

-- Uncommenting the following lines should get you plain-old-menus instead
-- of query-menus.

defbindings("WScreen", {
    kpress(META.."F12", "mod_menu.menu(_, _sub, 'mainmenu', {big=true})"),
})

defbindings("WMPlex.toplevel", {
    kpress(META.."Shift+F12", "mod_menu.menu(_, _sub, 'ctxmenu')"),
})

--
-- Personal scripts
--

--dopath("goto_multihead")
dopath("exec_on2.lua")
dopath("ewmh_pager.lua")

--
-- Personal cfg_ioncore.lua overrides
--

-- Change the default workspace type to empty
ioncore.deflayout("default")

-- By default meta-k is used for submaps.  I use it for vi-like 
-- movement so undo all the submaps first.  Do the same for the others to be
-- safe.
undo_vi_keys = {
    kpress(META.."H", nil),
    kpress(META.."J", nil),
    kpress(META.."K", nil),
    kpress(META.."L", nil),
}
defbindings("WScreen", undo_vi_keys)
defbindings("WClientWin", undo_vi_keys)
defbindings("WGroupCW", undo_vi_keys)
defbindings("WMPlex", undo_vi_keys)
defbindings("WMPlex.toplevel", undo_vi_keys)
defbindings("WFrame", undo_vi_keys)
defbindings("WFrame.toplevel", undo_vi_keys)
defbindings("WFrame.floating", undo_vi_keys)
defbindings("WMoveresMode", undo_vi_keys)

-- The bindings in this context are available all the time.
defbindings("WScreen", {
    bdoc("Clear all tags."),
    kpress(ALTMETA.."T", "ioncore.tagged_clear()"),

    bdoc("Create a new workspace of chosen default type."),
    kpress(META.."W", "ioncore.create_ws(_)"),
    kpress(ALTMETA.."W", "mod_query.query_workspace(_)"),

    bdoc("OmniPaste"),
    kpress(META.."Shift+O", "ioncore.exec('ompa --xcut')"),

    bdoc("Paste is yummy"),
    kpress(META.."U", "ioncore.exec('eatpaste')"),

    bdoc("NoPaste for you!"),
    kpress(META.."Shift+U", "ioncore.exec('nopaste --xcut')"),

    bdoc("Lock Screen"),
    kpress(META.."Z", "ioncore.exec('xscreensaver-command -lock; gnome-screensaver-command --lock')"),
})

-- Frames for transient windows ignore this bindmap
defbindings("WMPlex.toplevel", {
    bdoc("Run a terminal emulator."),
    kpress(META.."X", "ioncore.exec_on(_, XTERM or 'x-terminal-emulator')"),
    
    bdoc("Query for command line to execute."),
    kpress(META.."Shift+X", "mod_query.query_exec(_)"),

    bdoc("Query for Lua code to execute."),
    kpress(META.."C", "mod_query.query_lua(_)"),

    bdoc("Run file manager."),
    kpress(META.."F", 
           "ioncore.exec_on(_, 'nautilus')"),

    bdoc("Run browser."),
    kpress(META.."B", "ioncore.exec_on(_, 'firefox')"),

    -- this overrides the default "Display context menu"
    submap(META.."M", { 
        bdoc("xmutt-g1"),
        kpress("G", "ioncore.exec_on(_, 'xmutt-g1')"),

        bdoc("xmutt-hp"),
        kpress("H", "ioncore.exec_on(_, 'xmutt-hp')"),
    }),

    bdoc("xmutt-compose"),
    kpress(META.."Shift+M", "ioncore.exec_on(_, 'xmutt \"\"')"),

    bdoc("Detach (float) or reattach an object to its previous location."),
    -- By using _chld instead of _sub, we can detach/reattach queries
    -- attached to a group. The detach code checks if the parameter 
    -- (_chld) is a group 'bottom' and detaches the whole group in that
    -- case.
    kpress(META.."Shift+A", "ioncore.detach(_chld, 'toggle')", "_chld:non-nil"),
})

-- These bindings affect client windows directly.
defbindings("WClientWin", {
    bdoc("Nudge the client window. This might help with some "..
         "programs' resizing problems."),
    kpress_wait(META.."5", "WClientWin.nudge(_)"),
    
    submap(META.."I", {
       bdoc("Kill client owning the client window."),
       kpress("K", "WClientWin.kill(_)"),
       
       bdoc("Send next key press to the client window. "..
            "Some programs may not allow this by default."),
       kpress("Q", "WClientWin.quote_next(_)"),
    }),
})

-- These bindings work in frames and on screens. The innermost of such
-- contexts/objects always gets to handle the key press. 
defbindings("WMPlex", {
    -- move this into a submap
    kpress(META.."C", nil),
    submap(META.."I", {
        bdoc("Close current object."),
        kpress_wait("C", "WRegion.rqclose_propagate(_, _sub)"),
    }),
})

-- Frames for transient windows ignore this bindmap
defbindings("WFrame.toplevel", {
    bdoc("Tag current object within the frame."),
    kpress(META.."T", "WRegion.set_tagged(_sub, 'toggle')", "_sub:non-nil"),
    
    bdoc("Attach tagged objects to this frame."),
    kpress(META.."A", "ioncore.tagged_attach(_)"),
        
    bdoc("Switch to next/previous object within the frame."),
    kpress(META.."N", "WFrame.switch_next(_)"),
    kpress(META.."P", "WFrame.switch_prev(_)"),

    bdoc("Move current object within the frame left/right."),
    kpress(META.."Shift+P", "WFrame.dec_index(_, _sub)", "_sub:non-nil"),
    kpress(META.."Shift+N", "WFrame.inc_index(_, _sub)", "_sub:non-nil"),

--  bdoc("Maximize the frame horizontally/vertically."),
--  kpress(META.."7", "WFrame.maximize_horiz(_)"),
--  kpress(META.."6", "WFrame.maximize_vert(_)"),
})

--
-- Personal cfg_tiling.lua overrides
--

defbindings("WTiling", {
    bdoc("Split current frame vertically."),
    kpress(META.."V", "WTiling.split_at(_, _sub, 'right', true)"),
    bdoc("Split current frame horizontally."),
    kpress(META.."S", "WTiling.split_at(_, _sub, 'bottom', true)"),

    -- replace the defaults with vi-like movement
    kpress(META.."P", nil),
    kpress(META.."N", nil),
    kpress(META.."Tab", nil),
    bdoc("Go to frame above/below/right/left of current frame."),
    kpress(META.."K", "ioncore.goto_next(_sub, 'up', {no_ascend=_})"),
    kpress(META.."J", "ioncore.goto_next(_sub, 'down', {no_ascend=_})"),
    kpress(META.."L", "ioncore.goto_next(_sub, 'right')"),
    kpress(META.."H", "ioncore.goto_next(_sub, 'left')"),

    submap(META.."I", {
        bdoc("Destroy current frame."),
        kpress("X", "WTiling.unsplit_at(_, _sub)"),
    }),
})

defbindings("WFrame.floating", {
    -- move this submap from 'K' to 'I' ...
    -- must be an easier way
    kpress(META.."K", nil),
    submap(META.."I", {
        bdoc("Tile frame, if no tiling exists on the workspace"),
        kpress("B", "mod_tiling.mkbottom(_)"),
    }),

    -- shade windows with win-space
    bdoc("Toggle shade mode"),
    kpress(META.."space", "WFrame.set_shaded(_, 'toggle')"),
})

dopath("directions")
defbindings("WFrame.floating", {
    kpress(ALTMETA.."H", "_:push_direction('left')"),
    kpress(ALTMETA.."J", "_:push_direction('down')"),
    kpress(ALTMETA.."K", "_:push_direction('up')"),
    kpress(ALTMETA.."L", "_:push_direction('right')"),
    kpress(META.."6", "_:maximize_fill_toggle('vert')"),
    kpress(META.."7", "_:maximize_fill_toggle('vh')"),
})
defbindings("WScreen", {
    kpress(META.."H", "_chld:focus_direction('left')", "_chld:non-nil"),
    kpress(META.."J", "_chld:focus_direction('down')", "_chld:non-nil"),
    kpress(META.."K", "_chld:focus_direction('up')", "_chld:non-nil"),
    kpress(META.."L", "_chld:focus_direction('right')", "_chld:non-nil"),
})

--
-- Personal cfg_kludges.lua overrides
--

defwinprop{ class = "Gnome-panel", instance = "gnome-panel", target = "*dock*", oneshot = true, }
defwinprop{ class = "Xfce4-panel", instance = "xfce4-panel", target = "*dock*", oneshot = true, }
