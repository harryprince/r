all: setup build

setup:
	Rscript -e 'install.packages(c("devtools","roxygen2","testthat","covr"),repo="http://cloud.r-project.org/")'
	Rscript -e 'devtools::install_github("hadley/pkgdown")'

build:
	Rscript -e 'devtools::document()'
	R CMD build .

install:
	Rscript -e 'devtools::install()'

docs:
	Rscript -e 'devtools::document(); pkgdown::build_site()'
.PHONY: docs

# The tryCatch here is simply to catch teh `ignoring SIGPIPE signal` that occurs (on Ubuntu Linux at least)
run:
	echo 'library(stencila); host$$start(); tryCatch(Sys.sleep(10), error=identity); Sys.sleep(1e6)' | R --no-save --quiet

check:
	R CMD check $$(ls stencila_*.tar.gz | tail -n 1)

check-as-cran:
	R CMD check $$(ls stencila_*.tar.gz | tail -n 1) --as-cran

test:
	Rscript -e 'library(R6); devtools::document(); devtools::test()'

cover:
	Rscript -e 'covr::package_coverage(".")'

clean:
	rm -rf ..Rcheck
