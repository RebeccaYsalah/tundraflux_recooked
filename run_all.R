script <- commandArgs(trailingOnly = TRUE)[1]
exprs <- parse(script)
for (e in exprs) {
  res <- tryCatch(withVisible(eval(e, globalenv())),
                  error = function(err) {
                    cat("\n### ERROR in:", deparse(e)[1], "\n###", conditionMessage(err), "\n")
                    NULL
                  })
  if (!is.null(res) && res$visible) print(res$value)
}