return {
  'williamboman/mason.nvim',
  cmd = 'Mason',
  opts = {
    max_concurrent_installers = 10,
    ui = {
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
      },
      check_outdated_packages_on_open = true,
      border = 'rounded',
      width = 0.9,
      height = 0.9,
    },
  },
}
