all: publish

publish:
	mdbook build
	rsync -a --delete book/html/* docs
	git add docs/*

test:
	mdbook build
	./scripts/test.sh
