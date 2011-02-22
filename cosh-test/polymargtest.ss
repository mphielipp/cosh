#!r6rs

(import (rnrs)
        (cosh)
        (cosh header)
        (cosh preamble)        
        (cosh polymarg)
        (cosh polygraph)
        (scheme-tools)
        (scheme-tools graph))

(define expr
  '(

    (define (foo z n)
      (rejection-query
       (define x (flip))
       x
       (if (= n 0)
           #t
           (equal? (foo x (- n 1))
                   z))))

    (foo #t 1)

    ))

(define (print-solutions solutions)
  (if (null? solutions)
      (pe "No solutions!")
      (map pretty-print solutions)))

(define (main)
  (pe "Compiling expression to procedure ...\n")
  (let ([thunk (expr->return-thunk header
                                   (with-preamble expr))])
    (pe "Building computation graph ...")
    (let ([graph (return-thunk->polygraph thunk #f)])
      (pe " size: " (graph-size graph) "\n")
      (pe "Marginalizing graph using polynomial solver ...\n")
      (print-solutions (polymarg-graph graph)))))

(define (main2)
  (print-solutions
   (polymarg-expr header
                  (with-preamble expr)
                  #f)))

(main)