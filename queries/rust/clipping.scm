(
 (line_comment) @clip_group
 (#match? @clip_group "^///.*$")
 (#set! "filetype" "markdown")
 (#set! "prefix_pattern" "\\s*///\\s*")
 )

(
 (line_comment) @clip_group
 (#match? @clip_group "^//!.*$")
 (#set! "filetype" "markdown")
 (#set! "prefix_pattern" "\\s*//!\\s*")
 )

(
 (line_comment) @clip_group
 (#match? @clip_group "^//[^/].*$")
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
