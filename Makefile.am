AUTOMAKE_OPTIONS = foreign subdir-objects
bin_PROGRAMS = myprogram
myprogram_SOURCES = main.cpp func.cpp func.h HTTP_Server.cpp 
check_PROGRAMS = test
test_SOURCES = tests/test.cpp func.cpp

PACKAGE = myprogram
VERSION = 1.0
PACKAGE_BUGREPORT = senyshyn.nazar@gmail.com

.PHONY: deb debug dockerfile dockerbuild dockerpush

deb:
	echo "Package: $(PACKAGE)" > deb/DEBIAN/control
	echo "Version: $(VERSION)" >> deb/DEBIAN/control
	echo "Architecture: all" >> deb/DEBIAN/control
	echo "Maintainer: $(PACKAGE_BUGREPORT)" >> deb/DEBIAN/control
	echo "Description: MyProgram does amazing things" >> deb/DEBIAN/control

debug:
	@echo "${PACKAGE}"
	@echo "${VERSION}"
	@echo "${PACKAGE_BUGREPORT}"

check: test
	@./test

dockerfile:
	@echo "FROM alpine" > Dockerfile
	@echo "WORKDIR /home" >> Dockerfile
	@echo "COPY ./myprogram ." >> Dockerfile
	@echo "RUN apk add libstdc++" >> Dockerfile
	@echo "RUN apk add libc6-compat" >> Dockerfile
	@echo 'ENTRYPOINT ["./myprogram"]' >> Dockerfile
	@echo "Dockerfile has been generated."

dockerbuild: dockerfile
	sudo docker build -t cloudysommme/my-http-server:latest .

dockerpush: dockerbuild
	sudo docker push cloudysommme/my-http-server:latest

