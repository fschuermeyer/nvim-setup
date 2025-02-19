;; Injection: jq
(command
  name: (command_name) @name (#match? @name "jq")
  argument: (raw_string) @injection.content
  (#set! injection.language "jq")
) 

;; Injection: awk
(command
  name: (command_name) @name (#match? @name "awk")
  argument: (raw_string) @injection.content
  (#set! injection.language "awk")
) 


;; Injection: json for Variable Assignment
;; All Variables thats contain "json" in their name will be treated as json
(variable_assignment
    name: (variable_name) @name (#match? @name "json")
    value: (raw_string) @injection.content
    (#set! injection.language "json")
)
