return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable "make" == 1
			end,
		},
	},
	opts         = function()
		local actions = require("telescope.actions")
		return {
			extensions = {
				fzf = {
					fuzzy = true,    -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				}
			},
			defaults = {
				layout_config = {
					horizontal = {
						preview_width = 0.55,
						results_width = 0.8,
					},
					vertical = {
						mirror = false,
					},
					width = 0.95,
					height = 0.95,
					preview_cutoff = 120,
				},
				winblend = 0,
				mappings = {
					i = {
						["<C-k>"] = "move_selection_previous",
						["<C-j>"] = "move_selection_next",
						["<esc>"] = actions.close,
					}
				}
			},
		}
	end,
	config       = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("fzf")
	end,
	keys         = {
		{ "<leader>fF", function() require("telescope.builtin").find_files({ hidden = true }) end },
		{ "<leader>ff", " <cmd>Telescope git_files<CR>" },
		{ "<leader>fg", " <cmd>Telescope live_grep<CR>" },
		{ "<leader>fb", " <cmd>Telescope current_buffer_fuzzy_find<CR>" },
		{ "<leader>fh", " <cmd>Telescope help_tags<CR>" },
		{ "<leader>fs", " <cmd>Telescope spell_suggest<CR>" },
	}
}
