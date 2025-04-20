# 🧘 commentless.nvim

Hide comments, focus on the code flow, and reveal them if needed.

This plugin lets you fold comments to better visualize your code’s logic,
and unfold them whenever needed.

<div align="center">
  <img src="https://i.imgur.com/32JkGlQ.gif" alt="commentless.nvim usage" width="90%">
</div>

## 📦 Installation

Use your favorite plugin manager to install it, and then run
`require("soemre/commentless.nvim").setup({})` to start it up.

Also, check out the [Some Recommendations for Global Folding Behavior](some-recommendations-for-global-folding-behavior) section.

### lazy.nvim

The `setup` call is handled internally by `lazy.nvim`.

```lua
{
    "soemre/commentless.nvim",
    keys = {
        {
            "<leader>/",
            function()
                require("commentless").toggle()
            end,
            desc = "Toggle Comments",
        },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        -- Customize Configuration
    },
}
```

## 🛠️ Configuration

Check `:help commentless` for full documentation.

### Default Configuration

```lua
{
    hide_following_blank_lines = true,
    foldtext = function(folded_count)
        return "(" .. folded_count .. " comments)"
    end,
}
```

### Some Recommendations for Global Folding Behavior

```lua
vim.opt.foldminlines = 0 -- Allow folding/hiding single lines
vim.opt.fillchars = "fold: " -- Remove the trailing dots
```
