compile:
	arara cv
	make upload

upload:
	scp cv.pdf seaall6@beehive.dreamhost.com:seanallred.com/sean-allred.pdf
