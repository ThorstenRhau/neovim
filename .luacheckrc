-- .luacheckrc
std = "luajit"
unused = true

-- core globals
globals = {
    "vim",
}

-- allow these additional names without error
new_globals = {
    "vim",
}

include_files = { "lua/**/*.lua", "init.lua" }
exclude_files = { "README.md", "docs/*.md", "tests/data/*.lua" }

files["tests/*.lua"] = {
    std = "luajit+busted",
    max_line_length = false,
}

files["vendor/**"] = {
    std = "none",
    globals = {},
}
