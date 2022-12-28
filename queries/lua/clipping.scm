;; A query for lua files

(function_call
  name: (_) @funcname
  arguments: (arguments (string) @clip)
  (#eq? @funcname "vim.cmd")
  (#set! "filetype" "vim")
  (#offset! @clip 1 0 -1 0)
  )

(function_call
  name: (_)
  arguments: (arguments (string) @clip)
  (#offset! @clip 1 0 -1 0)
  )

(
 (comment) @clip_seq
 (#set! "prefix_pattern" "\\s*---\\?\\s*")
 )
