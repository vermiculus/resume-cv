compile:
	arara cv
	$(MAKE) upload

upload:
	scp cv.pdf seaall6@beehive.dreamhost.com:seanallred.com/sean-allred.pdf
