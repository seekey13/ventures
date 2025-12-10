local imgui = require('imgui');
local config = require('configs.config');
local window = require('models.window');
local sorter = require('services.sorter');
local rows = require('ui.rows');
local sort_button = require('ui.sort_button');
local headers = require('ui.headers');
local ui = {};

-- Draw main window
function ui:draw(ventures)
    if not config.get('show_gui') then
        return;
    end

    -- Get highest completion info
    local highest = sorter:get_highest_completion(ventures);

    -- Set window title
    local window_title = window:get_title(highest.completion, highest.area, highest.position);

    -- Calculate window height based on content
    local line_height = imgui.GetTextLineHeightWithSpacing();
    local separator_height = 8; -- Approximate height of separator
    local padding = 40; -- Window padding (title bar + frame)
    local num_ventures = ventures and #ventures or 0;
    
    -- Content: Header row (1 line) + Separator + Venture rows (1 line per venture)
    local calculated_height = padding + line_height + separator_height + (num_ventures * line_height);
    
    -- Set window size constraints (width adjustable, height fixed to content)
    local min_width = 600;
    local max_width = 900;
    imgui.SetNextWindowSizeConstraints({ min_width, calculated_height }, { max_width, calculated_height });

    local open = { config.get('show_gui') };
    if imgui.Begin(window_title, open) then
        -- Set window styles
        imgui.PushStyleColor(ImGuiCol_WindowBg, {0,0.06,0.16,0.9});
        imgui.PushStyleColor(ImGuiCol_TitleBg, {0,0.06,0.16,0.7});
        imgui.PushStyleColor(ImGuiCol_TitleBgActive, {0,0.06,0.16,0.9});
        imgui.PushStyleColor(ImGuiCol_TitleBgCollapsed, {0,0.06,0.16,0.5});

        imgui.Columns(4);

        headers:draw();
        rows:draw(ventures);

        imgui.Columns(1);
        imgui.PopStyleColor(4);
    end

    window:update_state(imgui);
    imgui.End();
    config.set('show_gui', open[1])
end

return ui;