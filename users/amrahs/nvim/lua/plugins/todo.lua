return {
  {
  "thestaccato/todo.nvim",
    config = function()
      require("todo").setup({ file = "~/.todos.txt" })
    end,
  },
}
