;; Injection: jq
(command
  name: (command_name) @name (#match? @name "jq")
  argument: (raw_string) @injection.content
  (#set! injection.language "jq")
) 
