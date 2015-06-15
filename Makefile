cv.pdf: cv.tex
	arara cv.tex
	mkdir -p ~/blog/assets
	cp cv.pdf ~/blog/assets/cv.pdf
