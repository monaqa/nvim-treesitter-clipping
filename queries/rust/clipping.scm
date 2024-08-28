(
 (
  line_comment
   outer: (outer_doc_comment_marker)
   doc: (doc_comment)
   ) @clip_group

 (#set! "exclude_bounds" "end")
 (#set! "filetype" "markdown")
 (#set! "prefix_pattern" "\\s*///\\s*")
 )

(
 (
  line_comment
   inner: (inner_doc_comment_marker)
   doc: (doc_comment)
   ) @clip_group

 (#set! "exclude_bounds" "end")
 (#set! "filetype" "markdown")
 (#set! "prefix_pattern" "\\s*//!\\s*")
 )

(
 (line_comment) @clip_group
 (#set! "filetype" "markdown")
 (#set! "prefix_pattern" "\\s*//\\s*")
 )
