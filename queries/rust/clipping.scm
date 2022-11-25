(
 (line_comment) @clip_seq
 (#match? @clip_seq "^///.*$")
 (#set! "filetype" "markdown")
 (#set! "prefix_pattern" "\\s*///\\s*")
 )

(
 (line_comment) @clip_seq
 (#match? @clip_seq "^//!.*$")
 (#set! "filetype" "markdown")
 (#set! "prefix_pattern" "\\s*//!\\s*")
 )

(
 (line_comment) @clip_seq
 (#match? @clip_seq "^//[^/].*$")
 (#set! "prefix_pattern" "\\s*//\\s*")
 )

(
 (block_comment) @clip
 (#match? @clip "^/\\*\\*[^*]")
 (#offset! @clip 1 0 -1 0)
 (#set! "filetype" "markdown")
 (#set! "prefix_pattern" "\\s*\\*\\s*")
 )

(
 (block_comment) @clip
 (#offset! @clip 1 0 -1 0)
 (#set! "prefix_pattern" "\\s*\\*\\s*")
 )
