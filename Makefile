all: work

work:
	mdbook build
	rsync -a --delete book/html/* docs
