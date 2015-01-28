SOURCE_FILE_NAME = erlang.md
BOOK_FILE_NAME = erlang

PDF_BUILDER = pandoc
PDF_BUILDER_FLAGS = \
	--latex-engine xelatex \
	--template ../common/pdf-template.tex \
	--listings

EPUB_BUILDER = pandoc
EPUB_BUILDER_FLAGS = \
	-f markdown_github \
	--epub-cover-image

MOBI_BUILDER = kindlegen

all: pl/$(BOOK_FILE_NAME).pdf pl/$(BOOK_FILE_NAME).epub

pl/$(BOOK_FILE_NAME).pdf: pl/$(SOURCE_FILE_NAME) common/pdf-template.tex
	cd pl && $(PDF_BUILDER) $(PDF_BUILDER_FLAGS) $(SOURCE_FILE_NAME) -o $(BOOK_FILE_NAME).pdf

pl/$(BOOK_FILE_NAME).epub: pl/title.png pl/title.txt pl/erlang.md
	$(EPUB_BUILDER) $(EPUB_BUILDER_FLAGS) $^ -o $@

pl/$(BOOK_FILE_NAME).mobi: pl/$(BOOK_FILE_NAME).epub
	$(MOBI_BUILDER) $^


clean:
	rm -f */$(BOOK_FILE_NAME).pdf
	rm -f */$(BOOK_FILE_NAME).epub
	rm -f */$(BOOK_FILE_NAME).mobi
