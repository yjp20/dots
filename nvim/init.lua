vim.cmd([[
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
	let &packpath=&runtimepath
	source ~/.vimrc
]])
--------------------------
-- FOLDING              --
--------------------------

vim.cmd([[
	autocmd BufRead,BufNewFile *.ts set fdm=expr foldexpr=nvim_treesitter#foldexpr()
]])

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require('ufo').setup({
	open_fold_hl_timeout = 0,
	enable_get_fold_virt_text = true,
	provider_selector = function(_, filetype)
    return { 'treesitter', 'indent' }
  end,
  fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
    local result = {}
    local _end = end_lnum - 1
    local final_text = vim.trim(vim.api.nvim_buf_get_text(0, _end, 0, _end, -1, {})[1])
    local suffix = final_text:format(end_lnum - lnum)
    local suffix_width = vim.fn.strdisplaywidth(suffix)
    local target_width = width - suffix_width
    local cur_width = 0
    for _, chunk in ipairs(virt_text) do
      local chunk_text = chunk[1]
      local chunk_width = vim.fn.strdisplaywidth(chunk_text)
      if target_width > cur_width + chunk_width then
        table.insert(result, chunk)
      else
        chunk_text = truncate(chunk_text, target_width - cur_width)
        local hl_group = chunk[2]
        table.insert(result, { chunk_text, hl_group })
        chunk_width = vim.fn.strdisplaywidth(chunk_text)
        -- str width returned from truncate() may less than 2nd argument, need padding
        if cur_width + chunk_width < target_width then
          suffix = suffix .. (' '):rep(target_width - cur_width - chunk_width)
        end
        break
      end
      cur_width = cur_width + chunk_width
    end
    table.insert(result, { ' ⋯ ', 'NonText' })
    table.insert(result, { suffix, 'TSPunctBracket' })
    return result
  end,
})

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWithExact, {})
