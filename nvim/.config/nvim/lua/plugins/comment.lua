return {
	'numToStr/Comment.nvim',
	event = 'BufRead',
	dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
	config = function()
		local comment_status, comment = pcall(require, "Comment")
		if (not comment_status) then return end

		comment.setup({
			pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
		})
	end
}
