vim.keymap.set('n', '<leader>rh', function()
  -- Prompt for the pattern to find
  vim.ui.input({ prompt = 'Find: ' }, function(find_pattern)
    if not find_pattern then return end -- User cancelled

    -- Prompt for the replacement string
    vim.ui.input({ prompt = 'Replace with: ' }, function(replace_string)
      -- If replace_string is nil, user cancelled, or they want to replace with nothing
      replace_string = replace_string or ''

      -- Execute the substitute command globally on the file with confirmation
      vim.cmd(string.format('%%s/%s/%s/gc', find_pattern, replace_string))
    end)
  end)
end, { desc = 'Find and Replace (File)' })
