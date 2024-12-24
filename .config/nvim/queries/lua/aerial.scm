;; extends

; top-level table variables
(chunk
  (variable_declaration
    (assignment_statement
      (variable_list
        (identifier) @name)
      (expression_list
        (table_constructor)))
    (#set! "kind" "Class")) @symbol
  )
