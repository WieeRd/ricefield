local vim = vim
local M = {}

-- FEAT: add management commands
-- FEAT: keep both original and evaluated config table

local function tbl_or_mod(target)
    if type(target) == "table" then
        return target
    else
        package.loaded[target] = nil
        return require(target)
    end
end

function M.setup(cfg)
    local loaders = require("setup.loaders")
    local modules = {
        "globals",
        "options",
        "keymaps",
        "autocmds",
        "commands",
        "signs",
        "diagnostics",
    }

    cfg = tbl_or_mod(cfg or {})
    for _, mod in ipairs(modules) do
        if cfg[mod] then
            local opts = tbl_or_mod(cfg[mod])
            loaders[mod](opts)
        end
    end

    if loaders.plugins(tbl_or_mod(cfg.plugins or {})) then
        vim.cmd.colorscheme(cfg.colorscheme.plugin or "default")
    else
        vim.cmd.colorscheme(cfg.colorscheme.builtin or "default")
    end
end

function M.deactivate()
    -- local unloaders = require("setup.unloaders")
    -- FEAT: add unloaders
end

return M
