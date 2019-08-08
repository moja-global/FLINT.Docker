# ==================================================================================================================
#
# Docker to ubuntu 18.04 base image to build moja global libraries and executables
#
# Building this Docker: 
#	docker build --build-arg NUM_CPU=8 -t moja-global/baseimage:bionic .
#
# ==================================================================================================================

# Ubuntu 18.04 Bionic Beaver
FROM ubuntu@sha256:9b1702dcfe32c873a770a32cfd306dd7fc1c4fd134adfb783db68defc8894b3c

LABEL maintainer="info@moja.global"

ARG DEBIAN_FRONTEND=noninteractive

ENV ROOTDIR /usr/local
ENV GDAL_VERSION 2.4.1
ENV CMAKE_VERSION 3.15.0
ENV POCO_VERSION 1.9.2
ENV BOOST_VERSION 1_70_0
ENV BOOST_VERSION_DOT 1.70.0
ENV FMT_VERSION 5.3.0
ENV SQLITE_VERSION 3.28.0

WORKDIR $ROOTDIR/

# Install basic dependencies
RUN apt-get update -y && apt-get install -y \
    software-properties-common \
    build-essential \
    python3-dev \
    python3-numpy \
    python3-pip \
    libspatialite-dev \
    sqlite3 \
	openssl \
    libssl-dev \
    libpq-dev \
    libcurl4-gnutls-dev \
    libproj-dev \
    libxml2-dev \
    libgeos-dev \
    libnetcdf-dev \
    libpoppler-dev \
    libhdf4-alt-dev \
    libhdf5-serial-dev \
    wget \
    bash-completion \
    nasm \
    postgresql-client-10 \
	git \
    && apt-get -y autoremove \
	&& 	apt-get clean 

# set environment variables
ENV PATH $ROOTDIR/bin:$PATH
ENV LD_LIBRARY_PATH $ROOTDIR/lib:$LD_LIBRARY_PATH
ENV PYTHONPATH $ROOTDIR/lib:$PYTHONPATH

ARG NUM_CPU=1

WORKDIR $ROOTDIR/src

RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz \
    && tar xzf cmake-${CMAKE_VERSION}.tar.gz \
    && cd cmake-${CMAKE_VERSION} \
    &&./bootstrap --system-curl --parallel=$NUM_CPU \
    && make --quiet -j $NUM_CPU \
	&& make --quiet install \
	&& make clean \
    && cd ..

# build user-config.jam files
RUN echo "using python : 3.6 : /usr ;" > ~/user-config.jam

RUN wget https://pocoproject.org/releases/poco-${POCO_VERSION}/poco-${POCO_VERSION}-all.tar.gz \
    && tar -xzf poco-${POCO_VERSION}-all.tar.gz && cd poco-${POCO_VERSION}-all \
    && ./configure --omit=Data/ODBC,Data/MySQL,FSM,Redis --no-samples --no-tests --shared \
	&& make --quiet -j $NUM_CPU LINKMODE=SHARED DEFAULT_TARGET=shared_release \
    && make --quiet install \
    && make clean \
    && cd ..

RUN wget https://dl.bintray.com/boostorg/release/${BOOST_VERSION_DOT}/source/boost_${BOOST_VERSION}.tar.bz2 \
    && tar --bzip2 -xf boost_${BOOST_VERSION}.tar.bz2 && cd boost_${BOOST_VERSION}  \
    && ./bootstrap.sh --prefix=$ROOTDIR \
    && ./b2 -d0 -j $NUM_CPU cxxstd=14 install variant=release link=shared  \
    && ./b2 clean \
    && cd ..

RUN wget https://github.com/fmtlib/fmt/archive/${FMT_VERSION}.tar.gz \
    && mkdir libfmt-${FMT_VERSION} && tar -xzf ${FMT_VERSION}.tar.gz -C libfmt-${FMT_VERSION} --strip-components=1 &&  cd libfmt-${FMT_VERSION} \
    && cmake -G"Unix Makefiles" -DCMAKE_INSTALL_PREFIX=$ROOTDIR . \
    && make --quiet -j $NUM_CPU install \
    && make clean \
    && cd ..
	
RUN wget https://github.com/azadkuh/sqlite-amalgamation/archive/${SQLITE_VERSION}.tar.gz \
    && tar -xzf ${SQLITE_VERSION}.tar.gz && mkdir -p sqlite-amalgamation-${SQLITE_VERSION}/build && cd sqlite-amalgamation-${SQLITE_VERSION}/build  \
    && cmake -G"Unix Makefiles" \
			-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON \
			-DCMAKE_INSTALL_PREFIX=$ROOTDIR .. \
    && make --quiet -j $NUM_CPU install \
    && make clean \
    && cd ..
	
RUN wget http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz \
    && tar -xvf gdal-${GDAL_VERSION}.tar.gz && cd gdal-${GDAL_VERSION} \
    && ./configure \
        --with-python --with-spatialite --with-pg --with-curl \
        --with-netcdf --with-hdf5=/usr/lib/x86_64-linux-gnu/hdf5/serial \
		--with-curl \
    && make --quiet -j $NUM_CPU \
    && make install \
    && make clean \
    && cd ..

ENV GDAL_DATA=$ROOTDIR/share/gdal

RUN ldconfig \
    && apt-get update -y \
    && apt-get remove -y --purge build-essential \
    && cd $ROOTDIR/src/gdal-${GDAL_VERSION}/swig/python \
    && python3 setup.py build \
    && python3 setup.py install 

RUN rm -r $ROOTDIR/src/*

