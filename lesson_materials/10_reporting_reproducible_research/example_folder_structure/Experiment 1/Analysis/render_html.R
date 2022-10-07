# render document and save in the outputs folder
rmarkdown::render('test_html_document.Rmd', 
                  output_file = '../Output/test_html_document.html'
                  )