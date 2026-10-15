-- Commands
local diff_clipboard = require('funcset.diff_clipboard')
local notify_file_detail_info = require('funcset.notify_file_detail_info')

vim.api.nvim_create_user_command('DiffClipboard', diff_clipboard, {})
vim.api.nvim_create_user_command("FileDetail", notify_file_detail_info, {})
vim.api.nvim_create_user_command("RemoveInactivePlugins", function()
  vim.pack.del(vim.iter(vim.pack.get()):filter(function(x) return not x.active end) :map(function(x) return x.spec.name end):totable())
end, {})

vim.api.nvim_create_user_command("BufferAbsolutePath", function()
  local full_path = vim.fn.expand('%:p')
  vim.fn.setreg('+', full_path)
  print(full_path)
end, {desc = "Copy the full path of the current buffer to the clipboard"})

vim.api.nvim_create_user_command("BufferWorkspacePath", function()
  local workspace_path = vim.fn.expand('%:.:p')
  vim.fn.setreg('+', workspace_path)
  print(workspace_path)
end, {desc = "Copy the workspace path of the current buffer to the clipboard"})

local function markdown_heading(text)
  local hashes, heading = text:match("^%s*(#+)(.*)$")
  if not hashes or #hashes > 6 then
    return nil, nil
  end

  if heading ~= "" and not heading:match("^%s") then
    return nil, nil
  end

  heading = heading:gsub("^%s+", ""):gsub("%s+#+%s*$", ""):gsub("%s+$", "")
  return heading, #hashes
end

local function markdown_heading_slug(text)
  local slug = text:lower()
    :gsub("!?%[([^%]]*)%]%([^%)]+%)", "%1")
    :gsub("!?%[([^%]]*)%]%[[^%]]*%]", "%1")
    :gsub("`", "")
    :gsub("<[^>]->", "")
    :gsub("[%*_~]", "")
    :gsub("[^%w%s%-_]", "")
    :gsub("%s+", "-")
    :gsub("%-+", "-")
    :gsub("^%-", "")
    :gsub("%-$", "")

  return slug
end

vim.api.nvim_create_user_command("MarkdownTableOfContents", function()
  local buffer = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
  local headings = {}
  local slug_counts = {}
  local in_fence = false
  local fence_character
  local fence_length
  local previous_text

  for _, line in ipairs(lines) do
    local content = line:gsub("^%s+", "")
    local indentation = #line - #content
    local backtick_fence = content:match("^(`+)")
    local tilde_fence = content:match("^(~+)")
    local fence = backtick_fence or tilde_fence

    if in_fence then
      local closing_fence = fence and fence:sub(1, 1) == fence_character and #fence >= fence_length
      if closing_fence and content:sub(#fence + 1):match("^%s*$") then
        in_fence = false
        previous_text = nil
      end
    elseif indentation <= 3 and fence and #fence >= 3 then
      in_fence = true
      fence_character = fence:sub(1, 1)
      fence_length = #fence
      previous_text = nil
    else
      local setext_level
      if indentation <= 3 and content:match("^=+%s*$") then
        setext_level = 1
      elseif indentation <= 3 and content:match("^%-+%s*$") then
        setext_level = 2
      end

      local heading, level
      if indentation <= 3 then
        heading, level = markdown_heading(line)
      end
      if heading then
        headings[#headings + 1] = { text = heading, level = level }
        previous_text = nil
      elseif setext_level and previous_text then
        headings[#headings + 1] = { text = previous_text, level = setext_level }
        previous_text = nil
      else
        previous_text = line:match("^%s*$") and nil or line
      end
    end
  end

  if #headings == 0 then
    vim.notify("No Markdown headings found in the current buffer", vim.log.levels.WARN)
    return
  end

  local toc = {}
  local base_level = headings[1].level
  for _, heading in ipairs(headings) do
    base_level = math.min(base_level, heading.level)
  end

  for _, heading in ipairs(headings) do
    local slug = markdown_heading_slug(heading.text)
    local count = slug_counts[slug] or 0
    slug_counts[slug] = count + 1
    if count > 0 then
      slug = slug .. "-" .. count
    end
    toc[#toc + 1] = string.rep("  ", heading.level - base_level)
      .. "* [" .. heading.text .. "](#" .. slug .. ")"
  end

  toc[#toc + 1] = ""
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  vim.api.nvim_buf_set_lines(buffer, row, row, false, toc)
end, { desc = "Insert a Markdown Table of Contents at the cursor" })
