local queries = require "nvim-treesitter.query"

local M = {}

function M.init()
  require "nvim-treesitter".define_modules {
    module_template = {
      module_path = "clipping.internal",
      is_supported = function(lang)
        -- TODO: you don't want your queries to be named `awesome-query`, do you ?
        return queries.get_query(lang, 'clipping') ~= nil
      end
    }
  }
end

return M
