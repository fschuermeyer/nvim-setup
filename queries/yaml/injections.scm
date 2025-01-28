;; Support for Docker Compose, Github Actions

(block_mapping_pair
  key: (flow_node
            (plain_scalar
                (string_scalar) @identifier (#match? @identifier "command|run|shell|before_script|after_script")
            )
       )
  value: [
          (block_node
            (block_scalar) @injection.content
            (#set! injection.language "bash")
          )
          (flow_node
            (plain_scalar
                     (string_scalar) @injection.content
                     (#set! injection.language "bash")
            )
          )
        ]
) 
