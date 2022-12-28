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
  (#offset! @clip 1 0 -1 0)
  )

; some_func [[
;   %% HERE %%
; ]]
(function_call
  name: (_)
  arguments: (arguments (string) @clip)
  (#match? @clip "^\\[")
  (#offset! @clip 1 0 -1 0)
  )

; comment lines
(
 (comment) @clip_seq
 (#set! "prefix_pattern" "\\s*---\\?\\s*")
 )
