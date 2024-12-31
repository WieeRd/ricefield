return {
    underline = true,
    virtual_text = {
        severity = { min = vim.diagnostic.severity.WARN },
        prefix = " ●",
        format = function(diagnostic)
            return diagnostic.message:match("([^\n]*)\n?") .. " "
        end,
    },
    signs = false,
    float = { border = "solid" },
    update_in_insert = false,
    severity_sort = true,
}
