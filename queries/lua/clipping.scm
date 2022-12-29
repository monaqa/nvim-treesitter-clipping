;; A query for lua files

; vim.cmd [[
;   %% HERE %%
; ]]
(function_call
  name: (_) @funcname
  arguments: (arguments (string) @clip)
  (#eq? @funcname "vim.cmd")
  (#match? @clip "^\\[")  ; enable only [[ .. ]] string
  (#set! "filetype" "vim")
  (#set! "exclude_bounds" "true")
  )

; some_func [[
;   %% HERE %%
; ]]
(function_call
  name: (_)
  arguments: (arguments (string) @clip)
  (#match? @clip "^\\[")
  (#set! "exclude_bounds" "true")
  ; (#offset! @clip 1 0 -1 0)
  )

; comment lines
(
 (comment) @clip_group
 (#set! "prefix_pattern" "\\s*---\\?\\s*")
 )
