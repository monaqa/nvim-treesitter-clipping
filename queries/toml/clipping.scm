(
 (pair
  (bare_key) @_key
  (string) @clip)
 (#vim-match? @_key "^hook_\w*")
 (#vim-match? @clip "^('''|\"\"\")")
 (#set! "exclude_bounds" "both")
 (#set! "filetype" "vim")
 )

(
 (pair
  (bare_key) @_key
  (string) @clip)
 (#vim-match? @_key "^lua_\w*")
 (#vim-match? @clip "^('''|\"\"\")")
 (#set! "exclude_bounds" "both")
 (#set! "filetype" "lua")
 )

(
 (table
  (dotted_key) @_key
  (pair
   (string) @clip))
 (#vim-match? @_key "^%(plugins\.)?ftplugin$")
 (#vim-match? @clip "^('''|\"\"\")")
 (#set! "exclude_bounds" "both")
 (#set! "filetype" "vim")
 )

(
 (string) @clip
 (#vim-match? @clip "^('''|\"\"\")")
 (#set! "exclude_bounds" "both")
 )
