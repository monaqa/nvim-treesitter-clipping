;; A query for lua files

(function_call
  name: (_) @funcname
  arguments: (arguments) @clip
  ; (#eq? @funcname "vim.cmd")
  (#set! "filetype" "vim")
  (#offset! @clip 1 0 0 0)
  )
