;; Injection: SQL
(
[
    (raw_string_literal_content) 
    (interpreted_string_literal_content)
] @injection.content
    (#match? @injection.content "(WITH|with|SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete).+(FROM|from|INTO|into|VALUES|values|SET|set).*(WHERE|where|GROUP BY|group by|RETURNING|returning|TABLESAMPLE|tablesample|ORDER BY|order by|LIMIT|limit|OFFSET|offset|ON CONFLICT|on conflict|FROM|from|INTO|into|VALUES|values|SET|set)")
    (#set! injection.language "sql")
)

;; Injection: Regular Expression
(call_expression
  function: (selector_expression
    operand: (identifier) @operand (#eq? @operand "regexp")
    field: (field_identifier) @field (#match? @field "Compile|MustCompile|Match|MatchString|MatchReader")
  )
  arguments: (argument_list
    [
      (raw_string_literal
        (raw_string_literal_content) @injection.content
        (#set! injection.language "regex")
      )
      (interpreted_string_literal
        (interpreted_string_literal_content) @injection.content
        (#set! injection.language "regex")
      )
    ]+
  )
)


;; (testing) Injection: JSON / very unstable!!
(keyed_element
    key: (literal_element) @identifier (#match? @identifier "OutJson|outJson|expectedJson|ExpectedJson|InJson|inJson|json|JSON")
        value: (literal_element
        (call_expression
            arguments: (argument_list
                [
                    (raw_string_literal
                        (raw_string_literal_content) @injection.content
                        (#set! injection.language "json")
                    )
                    (interpreted_string_literal
                        (interpreted_string_literal_content) @injection.content
                        (#set! injection.language "json")
                    )
                ]+
            ) 
        )
    ) 
) 

(short_var_declaration
    left: (expression_list
        (identifier) @identifier (#match? @identifier "OutJson|outJson|expectedJson|ExpectedJson|InJson|inJson|json|JSON")
    )
    right: (expression_list
        [
            (raw_string_literal
                (raw_string_literal_content) @injection.content
                (#set! injection.language "json")
            )
            (interpreted_string_literal
                (interpreted_string_literal_content) @injection.content
                (#set! injection.language "json")
            )
        ]+
    )
) 
