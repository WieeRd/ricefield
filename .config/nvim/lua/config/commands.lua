return {
  ["Shrug"] = "echo 'Works On My Machine ¯\\_(ツ)_/¯'",
  ["Bind"] = "windo set cursorline! cursorbind! scrollbind!",
  ["Eval"] = {
    function(opts)
      local cmd = opts.args
      local result = vim.api.nvim_exec2(cmd, { output = true })
      vim.api.nvim_paste(result.output, true, -1)
    end,
    nargs = 1,
    complete = "command",
    desc = "Paste the output of the given command",
  },
}
