local config = vim.fs.normalize(vim.fn.stdpath('config'))
local home = assert(vim.uv.fs_realpath(vim.uv.os_homedir()))
local config_real = vim.uv.fs_realpath(config) or config

local function contains(parent, path)
  return parent == '/' or path == parent or path:sub(1, #parent + 1) == parent .. '/'
end

local targets = {}
for _, kind in ipairs({ 'data', 'state', 'cache' }) do
  table.insert(targets, { path = vim.fn.stdpath(kind), recursive = true, runtime = true })
end
for _, name in ipairs({ 'nvim-pack-lock.json', '.codex-lsp-cache', 'nvim.log' }) do
  table.insert(targets, { path = config .. '/' .. name, recursive = name == '.codex-lsp-cache' })
end

-- Validate every target before removing anything, including resolved parent links.
for _, target in ipairs(targets) do
  target.path = vim.fs.normalize(target.path)
  assert(target.path:sub(1, 1) == '/', 'Refusing non-absolute cleanup path: ' .. target.path)

  local stat, err, code = vim.uv.fs_lstat(target.path)
  if not stat and code ~= 'ENOENT' then
    error(err)
  end
  assert(not stat or stat.type ~= 'link', 'Refusing symlinked cleanup root: ' .. target.path)

  local resolved = stat and assert(vim.uv.fs_realpath(target.path)) or target.path
  assert(not contains(resolved, home), 'Refusing cleanup of home or its ancestors: ' .. target.path)
  if target.runtime then
    assert(
      not contains(resolved, config_real) and not contains(config_real, resolved),
      'Refusing cleanup overlapping configuration: ' .. target.path
    )
  end
end

for _, target in ipairs(targets) do
  print('Removing ' .. target.path)
  vim.fs.rm(target.path, { recursive = target.recursive, force = true })
end
