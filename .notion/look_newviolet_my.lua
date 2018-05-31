--
-- look_newviolet for Notion's default drawing engine. 
-- Based on look_cleanviolet
-- 

if not gr.select_engine("de") then
    return
end

de.reset()

de.defstyle("*", {

    bar_inside_border = false,

    --highlight_colour = "#e7e7ff",
    --shadow_colour = "#e7e7ff",
    --background_colour = "#b8b8c8",
    --foreground_colour = "#000000",

    highlight_colour = "#a2a2b2",
    --highlight_colour = "#5d5d6f",
    shadow_colour = "#a2a2b2",
    background_colour = "#9393a0",
    foreground_colour = "#000000",

    shadow_pixels = 1,
    highlight_pixels = 2,
    padding_pixels = 1,
    spacing = 1,
    border_style = "elevated",
    border_sides = "tb",

    font = "-*-helvetica-medium-r-normal-*-14-*-*-*-*-*-*-*",
    text_align = "center",
})


de.defstyle("tab", {
    --font = "-*-helvetica-medium-r-normal-*-12-*-*-*-*-*-*-*",
    font = "-*-helvetica-medium-r-normal-*-10-*-*-*-*-*-*-*",

    de.substyle("active-selected", {
        --highlight_colour = "#aaaacc",
        --shadow_colour = "#aaaacc",
        --background_colour = "#666699",
        --foreground_colour = "#eeeeee",

        highlight_colour = "#9999b8",
        shadow_colour = "#9999b8",
        background_colour = "#59597a",
        foreground_colour = "#d6d6d6",
    }),

    de.substyle("inactive-selected", {
        --highlight_colour = "#cfcfdf",
        --shadow_colour =    "#cfcfdf",
        --background_colour = "#9999bb",
        --foreground_colour = "#000000",

        --highlight_colour = "#8c8c95",
        --shadow_colour = "#cfcfdf",
        --background_colour = "#9999bb",
        --foreground_colour = "#000000",

        highlight_colour = "#a2a2b2",       
        shadow_colour = "#a2a2b2",
        background_colour = "#6a6a73",
        foreground_colour = "#000000",
    }),
})


de.defstyle("input", {
    text_align = "left",
    highlight_colour = "#eeeeff",
    shadow_colour = "#eeeeff",

    de.substyle("*-selection", {
        background_colour = "#666699",
        foreground_colour = "#000000",
    }),

    de.substyle("*-cursor", {
        background_colour = "#000000",
        foreground_colour = "#b8b8c8",
    }),
})


de.defstyle("input-menu", {
    highlight_pixels = 0,
    shadow_pixels = 0,
    padding_pixels = 0,
})


de.defstyle("frame", {
    based_on="*",
    transparent_background = true,

    shadow_pixels = 1,
    highlight_pixels = 1,
    padding_pixels = 0,
    border_sides = "all",
})




--(BB) begin
de.defstyle("frame-tiled", {
    based_on = "frame",
    border_style = "inlaid",
--    border_style = "ridge",
--    border_style = "elevated",
    padding_pixels = 0, --1,
    spacing = 0,
})

de.defstyle("frame-floating", {
    based_on = "frame",
    border_style = "ridge"
})
--(BB) end




dopath("lookcommon_clean")


-- Refresh objects' brushes.
gr.refresh()


