# src/bash/qto/funcs/build-docker-image.test.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doTestBuildQtoDockerImage comments ...
# cat doc/txt/qto/tests/build-docker-image.test.txt
# ---------------------------------------------------------
doTestBuildQtoDockerImage(){

	doLog "DEBUG START doTestBuildQtoDockerImage"
	
	# Action !!!
   bash "$PRODUCT_INSTANCE_DIR/src/bash/qto/qto.sh" -a build-docker-image
	doLog "DEBUG STOP  doTestBuildQtoDockerImage"
}
# eof func doTestBuildQtoDockerImage


# eof file: src/bash/qto/funcs/build-docker-image.test.sh
