return {
  {
    "polarmutex/git-worktree.nvim",
    version = "^2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function() require("telescope").load_extension "git_worktree" end,
  },
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      maps.n["<leader>gw"] = {
        function() require("telescope").extensions.git_worktree.git_worktree() end,
        desc = "Switch worktrees",
      }
      maps.n["<leader>gW"] = {
        function() require("telescope").extensions.git_worktree.create_git_worktree() end,
        desc = "Create worktree",
      }
    end,
  },
}
