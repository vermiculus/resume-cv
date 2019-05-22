cv.pdf: cv.tex
	arara cv.tex
.PHONY: blog
blog: cv.pdf
	mkdir -p ~/blog/assets
	cp cv.pdf ~/blog/assets/cv.pdf
publish: cv.pdf
	mkdir -p ~/git/seanallred.com/static
	cp cv.pdf ~/git/seanallred.com/static/resume--allred-sean.pdf
	@printf "Don't forget to git-push"
cv.png: cv.pdf
	convert -density 150 -alpha remove cv.pdf +append cv.png
