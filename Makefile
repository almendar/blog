serve:
	bundle exec jekyll serve

build:
	bundle exec jekyll build

publish: build
	./publish.sh
