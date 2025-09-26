;; I looked at grammar.js of the git repo used to build the jinja2 parser to find out the `source_file` name.
((source_file) @injection.content
  (#inject-tmpl!)
  (#set! injection.combined))
