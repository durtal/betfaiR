HTML_FILES := $(pathsubst %.Rmd, %.html ,$(wildcard *.Rmd)) \
			  $(pathsubst %.md, %.html ,$(wildcard *.md))

all: clean html

html: $(HTML_FILES)

%.html: %.Rmd
		R --vanilla --slave -e "rmarkdown::render('$<')"

%.html: %.md
		R --vanilla --slave -e "rmarkdown::render('$<')"

.PHONY: clean

clean:
		$(RM) $(HTML_FILES)
		
