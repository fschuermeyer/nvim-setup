;; injection of sql in golang queries
(
[
    (raw_string_literal_content) 
    (interpreted_string_literal_content)
] @injection.content
    (#match? @injection.content "(WITH|with|SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete).+(FROM|from|INTO|into|VALUES|values|SET|set).*(WHERE|where|GROUP BY|group by|RETURNING|returning|TABLESAMPLE|tablesample|ORDER BY|order by|LIMIT|limit|OFFSET|offset|ON CONFLICT|on conflict|FROM|from|INTO|into|VALUES|values|SET|set)")
    (#set! injection.language "sql")
)
