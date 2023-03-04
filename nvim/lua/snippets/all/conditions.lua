local M = {}

-- filetypes
function M.is_cppfile()
    return vim.bo.filetype == "cpp"
end

function M.is_luafile()
    return vim.bo.filetype == "lua"
end

function M.is_pyfile()
    return vim.bo.filetype == "python"
end

function M.is_texfile()
    return vim.bo.filetype == "tex"
end

return M
