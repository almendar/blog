serve:
	bundle exec jekyll serve --drafts

build:
	bundle exec jekyll build

publish: build
	./publish.sh
