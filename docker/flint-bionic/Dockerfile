# ========================================================================================================================
#
# Docker Image - based on Ubuntu 18.04 - for building moja flint libraries and executables
#
# Building this Docker: 
#   docker build --build-arg BUILD_TYPE=RELEASE \
#				 --build-arg NUM_CPU=4 \
#				 --build-arg FLINT_BRANCH=develop \
#				 -t mojaglobal/flint:bionic .
#
# ========================================================================================================================


# ------------------------------------------------------------------------------------------------------------------------
# Specify the Parent Image from which our image should be built: In this case mojaglobal/flint-baseimage:bionic.
# ------------------------------------------------------------------------------------------------------------------------

FROM mojaglobal/flint-baseimage:bionic


# ------------------------------------------------------------------------------------------------------------------------
# Add a little metadata to describe the image:
# ------------------------------------------------------------------------------------------------------------------------

LABEL project="=FLINT Docker Builds"\
  	  image="FLINT Image"\
  	  version="1.0"\
  	  maintainer="Moja Global <info@moja.global>"


# ------------------------------------------------------------------------------------------------------------------------
# Add a build time variable that will allow us to specify the Debian Interface to use during the build.
# Set it to noninteractive by default i.e an interface that never interacts with its users at all.
# ------------------------------------------------------------------------------------------------------------------------

ARG DEBIAN_FRONTEND=noninteractive


# ------------------------------------------------------------------------------------------------------------------------
# Add a build time variable that will allow us to specify the flint repository branch to use during the build.
# Do not set a default value for it forcing us to provide it at build time
# ------------------------------------------------------------------------------------------------------------------------

ARG FLINT_BRANCH


# ------------------------------------------------------------------------------------------------------------------------
# Add a build time variable that will allow us to specify the type of build that we want: Debug or release.
# Set its default value to debug
# ------------------------------------------------------------------------------------------------------------------------

ARG BUILD_TYPE=DEBUG


# ------------------------------------------------------------------------------------------------------------------------
# Set the preferred working directory for the next set of RUN instructions: In this case the docker root path.
# ------------------------------------------------------------------------------------------------------------------------

WORKDIR $ROOTDIR/


# ------------------------------------------------------------------------------------------------------------------------
# Install additional third party libraries, specific to this image build, from the default Ubuntu Package Archive:
#									
# - doxygen							=	Documentation generation tool
# - doxygen-latex						=	Doxygen dependency package
# - graphviz							=	Open source graph visualization software
# - postgis							=	Geographic objects support for PostgreSQL
# ------------------------------------------------------------------------------------------------------------------------

RUN apt-get update -y \
	&& apt-get install -y \
		doxygen \
		doxygen-latex \
		graphviz \
		postgis \
	&& 	apt-get clean


# ------------------------------------------------------------------------------------------------------------------------
# Add a build time variable that will allow us to specify the number of CPUs to use during the build.
# Set it to 1 by default
# ------------------------------------------------------------------------------------------------------------------------

ARG NUM_CPU=1


# ------------------------------------------------------------------------------------------------------------------------
# Set the preferred working directory for the next set of RUN instructions: In this case the docker root path src subdir
# ------------------------------------------------------------------------------------------------------------------------

WORKDIR $ROOTDIR/src


# ------------------------------------------------------------------------------------------------------------------------
# Download and install an additional third party library called zipper, that's specific to this image build, from sources:
# Zipper is a C++ wrapper around minizip compression library.
# ------------------------------------------------------------------------------------------------------------------------

RUN	git clone --recursive https://github.com/sebastiandev/zipper.git \
	&& cd zipper && git checkout e9f150516cb55d194b5e01d21a9527783e98311d \
	&& mkdir build  \
	&& cd build \
	&& cmake .. \
	&& make --quiet -j $NUM_CPU \
    && make --quiet install \
    && make clean \
    && cd $ROOTDIR/src


# ------------------------------------------------------------------------------------------------------------------------
# Download and install the FLINT library from sources:
# ------------------------------------------------------------------------------------------------------------------------

RUN git clone --recursive --depth 1 -b ${FLINT_BRANCH} https://github.com/moja-global/FLINT.git flint \
    && mkdir -p flint/Source/build \
    && cd flint/Source/build \
    && cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE  \
             -DCMAKE_INSTALL_PREFIX=$ROOTDIR \
             -DENABLE_TESTS:BOOL=OFF \
             -DENABLE_MOJA.MODULES.GDAL=ON \
             -DENABLE_MOJA.MODULES.LIBPQ=ON \
             -DBoost_USE_STATIC_LIBS=OFF \
             -DBUILD_SHARED_LIBS=ON .. \
	&& make --quiet -j $NUM_CPU \
	&& make --quiet install \
	&& make clean \
    && cd $ROOTDIR/src   


# ------------------------------------------------------------------------------------------------------------------------
# Create a symbolic link between $ROOTDIR/bin and the moja modules installed at $ROOTDIR/lib/:
# ------------------------------------------------------------------------------------------------------------------------

RUN ln -s $ROOTDIR/lib/libmoja.modules.* $ROOTDIR/bin


# ------------------------------------------------------------------------------------------------------------------------
# Add environmental variables that declare the language settings that we intend to use.
#
# - LANG								=	The locale to use
# - LC_ALL								=	An override for all LC_xxx environmental variables
# ------------------------------------------------------------------------------------------------------------------------

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8


# ------------------------------------------------------------------------------------------------------------------------
# Install setuptools from the Python Package Index to help download, build, install, upgrade & uninstall Python packages.
# ------------------------------------------------------------------------------------------------------------------------
	
RUN pip3 install setuptools


# ------------------------------------------------------------------------------------------------------------------------
# Download and install the FLINT Data preprocessing tools from sources:
# ------------------------------------------------------------------------------------------------------------------------

RUN git clone --recursive --depth 1 -b ${FLINT_BRANCH}  \
	https://github.com/moja-global/FLINT.Data_Preprocessing.git FLINT.Data_Preprocessing \
    && cd FLINT.Data_Preprocessing \
    && pip3 install .


# ------------------------------------------------------------------------------------------------------------------------
# Update library links and cache
# ------------------------------------------------------------------------------------------------------------------------
RUN ldconfig


# ------------------------------------------------------------------------------------------------------------------------
# Clear all downloaded source code files:  
# ------------------------------------------------------------------------------------------------------------------------

RUN rm -Rf $ROOTDIR/src/*


