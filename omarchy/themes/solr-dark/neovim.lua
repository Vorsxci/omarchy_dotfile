return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "macchiato", -- dark base
			transparent_background = false, -- set true if you want Hyprland blur behind
			term_colors = true,

			-- Map catppuccin palette -> your Solr-dark palette
			color_overrides = {
				macchiato = {
					base = "#2E3440",
					mantle = "#252b36",
					crust = "#1f2430",

					text = "#efe9d8",
					subtext1 = "#d9d2c4",
					subtext0 = "#c6bfaf",

					surface0 = "#343c4a",
					surface1 = "#3b4352",
					surface2 = "#465064",

					overlay0 = "#6C6F85",
					overlay1 = "#7C7F93",
					overlay2 = "#9CA0B0",

					-- accents
					rosewater = "#ffca98",
					flamingo = "#ff9898",
					pink = "#ff9898",
					mauve = "#8839EF", -- your kitty active border
					red = "#ff6557",
					maroon = "#ff6557",
					peach = "#f4a340",
					yellow = "#ffca98",
					green = "#40A02B",
					teal = "#179299",
					sky = "#179299",
					sapphire = "#179299",
					blue = "#1E66F5",
					lavender = "#1E66F5",
				},
			},

			-- Fine-grain: make UI elements look like your Waybar/Hyprland borders
			custom_highlights = function(C)
				local fire_orange = "#f4a340"
				local fire_coral = "#ff6557"
				local fire_pink = "#ff9898"
				local fire_gold = "#ffca98"

				return {
					-- Editor UI
					Normal = { fg = C.text, bg = C.base },
					NormalFloat = { fg = C.text, bg = C.mantle },
					FloatBorder = { fg = fire_orange, bg = C.mantle },

					CursorLine = { bg = C.surface0 },
					CursorLineNr = { fg = fire_orange, style = { "bold" } },

					LineNr = { fg = C.overlay0 },
					VertSplit = { fg = C.surface1 },
					WinSeparator = { fg = C.surface1 },

					Visual = { bg = C.surface2 },
					Search = { fg = C.base, bg = fire_gold, style = { "bold" } },
					IncSearch = { fg = C.base, bg = fire_orange, style = { "bold" } },

					Pmenu = { fg = C.text, bg = C.mantle },
					PmenuSel = { fg = C.base, bg = fire_gold, style = { "bold" } },
					PmenuSbar = { bg = C.surface0 },
					PmenuThumb = { bg = C.overlay0 },

					-- Diagnostics (fire for severity)
					DiagnosticError = { fg = fire_coral },
					DiagnosticWarn = { fg = fire_orange },
					DiagnosticInfo = { fg = C.blue },
					DiagnosticHint = { fg = C.teal },

					-- Git
					GitSignsAdd = { fg = C.green },
					GitSignsChange = { fg = fire_orange },
					GitSignsDelete = { fg = fire_coral },

					-- LSP / UI popups
					LspInfoBorder = { fg = fire_orange },
					TelescopeBorder = { fg = fire_orange },
					TelescopePromptBorder = { fg = fire_orange },
					TelescopeSelection = { bg = C.surface0 },
					TelescopeMatching = { fg = fire_pink, style = { "bold" } },

					-- WhichKey
					WhichKeyBorder = { fg = fire_orange },
					WhichKeyFloat = { bg = C.mantle },

					-- Statusline vibe (matches your “chip” borders)
					StatusLine = { fg = C.text, bg = C.mantle },
					StatusLineNC = { fg = C.overlay0, bg = C.mantle },
				}
			end,
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin") -- uses flavour above (macchiato)
		end,
	},

	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
		},
	},
}
