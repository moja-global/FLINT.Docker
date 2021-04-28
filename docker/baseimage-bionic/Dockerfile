# ========================================================================================================================
#
# Docker Image - based on Ubuntu 18.04 - for building moja flint libraries and executables:
#
# Building this Docker: 
#   docker build --build-arg NUM_CPU=4  -t mojaglobal/flint-baseimage:bionic .
#
# ========================================================================================================================


# ------------------------------------------------------------------------------------------------------------------------
# Specify the Parent Image from which our image should be built: In this case Ubuntu 18.04 Bionic Beaver.
# ------------------------------------------------------------------------------------------------------------------------

FROM ubuntu@sha256:9b1702dcfe32c873a770a32cfd306dd7fc1c4fd134adfb783db68defc8894b3c


# ------------------------------------------------------------------------------------------------------------------------
# Add a little metadata to describe our image.
# ------------------------------------------------------------------------------------------------------------------------

LABEL project="=FLINT Docker Builds" \
  	  image="FLINT Base Image" \
  	  version="1.0" \
  	  maintainer="Moja Global <info@moja.global>"


# ------------------------------------------------------------------------------------------------------------------------
# Add a build time variable that will allow us to specify the Debian Interface to use during the build.
# Set it to noninteractive by default i.e an interface that never interacts with its users at all.
# ------------------------------------------------------------------------------------------------------------------------

ARG DEBIAN_FRONTEND=noninteractive


# ------------------------------------------------------------------------------------------------------------------------
# Add an environmental variable that declares our desired root path i.e the path where the docker data should be stored. 
# Set it to /usr/local
# ------------------------------------------------------------------------------------------------------------------------

ENV ROOTDIR /usr/local


# ------------------------------------------------------------------------------------------------------------------------
# Set the preferred working directory for the next set of RUN instructions: In this case the docker root path
# ------------------------------------------------------------------------------------------------------------------------

WORKDIR $ROOTDIR/


# ------------------------------------------------------------------------------------------------------------------------
# Install a set of third party libraries from the default Ubuntu Package Archive:
#
# - automake							=	Tool for generating GNU Standards-compliant Makefiles
# - bash-completion						=	Tool for creating complex command lines with just a few keystrokes
# - build-essential						=	Meta-packages that are necessary for compiling software
# - ca-certificates						=	Package containing certificates provided by the Certificate Authorities										
# - gcc-8							    =	The GNU C Compiler from the GCC (GNU Compiler Collection)
# - g++-8							    =	The GNU C++ Compiler from the GCC (GNU Compiler Collection)
# - git								    =	Fast, scalable, distributed revision control system
# - libtool							    =	Generic library support script for generating special library types											
# - libcurl4-gnutls-dev					=	Easy-to-use client-side URL transfer library
# - libexpat-dev						=	XML parsing C library - runtime library
# - libgeos-dev							=	Geometry engine for GIS
# - libpoppler-dev						=	PDF rendering library
# - libproj-dev							=	Cartographic projection library
# - libpq-dev							=	Header files for libpq5 (PostgreSQL library)
# - libspatialite-dev					=	Geospatial extension for SQLite
# - libsqlite3-dev						=	Header files and static libraries for SQLite database engine
# - libssl-dev							=	Secure Sockets Layer toolkit
# - libxerces-c-dev						=	Validating XML parser library for C++
# - libxml2-dev							=	GNOME XML library
# - libzstd1-dev						=	Fast lossless compression algorithm
# - nasm							    =	General-purpose x86 assembler
# - openssl							    =	Secure Sockets Layer toolkit - cryptographic utility
# - postgresql-client-10				=	Front-end programs for PostgreSQL 10
# - postgresql-server-dev-10			=	PostgreSQL 10 server-side
# - pkg-config							=	A tool to help manage compile and link flags for libraries
# - python3-dev							=	Header files and a static library for Python
# - python3-numpy						=	Fast array facility to the Python 3 language
# - python3-pip							=	Python package installer
# - software-properties-common			=	A software repositories management tool
# - sqlite3							    =	A C library that implements an SQL database engine
# - wget							    =	Retrieves files from the web
# - zlib1g-dev							=	A compression library
# ------------------------------------------------------------------------------------------------------------------------

RUN apt-get update -y \
	&& apt-get install -y --fix-missing --no-install-recommends \
		software-properties-common \
		build-essential \
		ca-certificates \
		libtool \
		automake \
		zlib1g-dev \
		libspatialite-dev \
		pkg-config \
		libsqlite3-dev \
		sqlite3 \
		python3-dev \
		python3-numpy \
		python3-pip \
		openssl \
		libssl-dev \
		libpq-dev \
		libcurl4-gnutls-dev \
		libproj-dev \
		libxml2-dev \
		libexpat-dev \
		libxerces-c-dev \
		libgeos-dev \
		libpoppler-dev \
		libzstd1-dev \
		gcc-8 \
		g++-8 \
		git \
		wget \
		bash-completion \
		nasm \
		postgresql-client-10 \
		postgresql-server-dev-10 \
	&& apt-get -y autoremove \
	&& apt-get clean 


# ------------------------------------------------------------------------------------------------------------------------
# Make a new executable called gcc and install gcc-7 & gcc-8 as its alternatives - with their priorities set to 700 & 800 
# respectively. Use the --slave option with g++ to cause g++ to be switched, along with gcc, to the same version
# ------------------------------------------------------------------------------------------------------------------------

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7    
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8


# ------------------------------------------------------------------------------------------------------------------------
# Add environmental variables that declare the directories that we have executables and linkable format libraries 
# installed in:
#
# - LD_LIBRARY_PATH						=	The directories containing Executable and  Linkable Format (ELF) libraries
# - PATH							    =	The directories to search for executable files in response to user commands
# - PYTHONPATH							=	The directories where python will look for modules and packages	
# ------------------------------------------------------------------------------------------------------------------------

ENV LD_LIBRARY_PATH $ROOTDIR/lib:$LD_LIBRARY_PATH
ENV PATH $ROOTDIR/bin:$PATH
ENV PYTHONPATH $ROOTDIR/lib:$PYTHONPATH


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
# Add environmental variables that collectively declare the versions of 3rd party libraries that we intend to use.
#
# - boost								=	Peer-reviewed, portable C++ source libraries
# - cmake								=	Build process manager
# - fmt									=	Open-source formatting library
# - gdal								=	Raster and vector translation library
# - poco								=	C++ libraries for building network /internet apps
# ------------------------------------------------------------------------------------------------------------------------

ENV BOOST_VERSION 1_72_0
ENV BOOST_VERSION_DOT 1.72.0
ENV CMAKE_VERSION 3.15.0
ENV FMT_VERSION 6.1.2
ENV GDAL_VERSION 2.4.1
ENV POCO_VERSION 1.9.2


# ------------------------------------------------------------------------------------------------------------------------
# Download and install cmake library from sources
# ------------------------------------------------------------------------------------------------------------------------
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz \
	&& tar xzf cmake-${CMAKE_VERSION}.tar.gz \
	&& cd cmake-${CMAKE_VERSION} \
	&& ./bootstrap --system-curl --parallel=$NUM_CPU \
	&& make --quiet -j $NUM_CPU \
	&& make --quiet install \
	&& make clean \
	&& cd ..


# ------------------------------------------------------------------------------------------------------------------------
# Download and install poco library from sources
# ------------------------------------------------------------------------------------------------------------------------   

RUN wget https://pocoproject.org/releases/poco-${POCO_VERSION}/poco-${POCO_VERSION}-all.tar.gz \
    && tar -xzf poco-${POCO_VERSION}-all.tar.gz \
	&& mkdir poco-${POCO_VERSION}-all/cmake-build \
	&& cd poco-${POCO_VERSION}-all/cmake-build \
	&& cmake -DCMAKE_BUILD_TYPE=RELEASE \
			 -DCMAKE_INSTALL_PREFIX=$ROOTDIR \
			 -DPOCO_UNBUNDLED=ON \
			 -DPOCO_STATIC=OFF \
			 -DENABLE_ENCODINGS=OFF \
			 -DENABLE_ENCODINGS_COMPILER=OFF \
			 -DENABLE_XML=OFF \
			 -DENABLE_JSON=ON \
			 -DENABLE_MONGODB=OFF \
			 -DENABLE_REDIS=OFF \
			 -DENABLE_PDF=OFF \
			 -DENABLE_UTIL=OFF \
			 -DENABLE_NET=OFF \
			 -DENABLE_NETSSL=OFF \
			 -DENABLE_CRYPTO=OFF \
			 -DENABLE_DATA=ON \
			 -DENABLE_DATA_SQLITE=ON \
			 -DENABLE_DATA_MYSQL=OFF \
			 -DENABLE_DATA_ODBC=OFF \
			 -DENABLE_SEVENZIP=OFF \
			 -DENABLE_ZIP=OFF \
			 -DENABLE_PAGECOMPILER=OFF \
			 -DENABLE_PAGECOMPILER_FILE2PAGE=OFF \
			 -DENABLE_TESTS:BOOL=OFF .. \
	&& make --quiet -j $NUM_CPU \
    && make --quiet install/strip \
    && make clean \
    && cd $ROOTDIR/src
   

# ------------------------------------------------------------------------------------------------------------------------
# As a precusor to setting up the boost library, edit user-config.jam file to tell Boost.Build how to invoke Python
# ------------------------------------------------------------------------------------------------------------------------ 

RUN echo "using python : 3.6 : /usr ;" > ~/user-config.jam


# ------------------------------------------------------------------------------------------------------------------------
# Download and install boost library from sources
# ------------------------------------------------------------------------------------------------------------------------

RUN wget -c https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION_DOT}/boost_${BOOST_VERSION}.tar.bz2/download -O boost_${BOOST_VERSION}.tar.bz2 \
    && tar --bzip2 -xf boost_${BOOST_VERSION}.tar.bz2 \
	&& cd boost_${BOOST_VERSION}  \
    && ./bootstrap.sh --prefix=$ROOTDIR \
    && ./b2 -d0 -j $NUM_CPU cxxstd=14 install variant=release link=shared  \
    && ./b2 clean \
    && cd $ROOTDIR/src


# ------------------------------------------------------------------------------------------------------------------------
# Download and install fmt library from sources
# ------------------------------------------------------------------------------------------------------------------------ 

RUN wget https://github.com/fmtlib/fmt/archive/${FMT_VERSION}.tar.gz \
    && mkdir libfmt-${FMT_VERSION} \
	&& tar -xzf ${FMT_VERSION}.tar.gz -C libfmt-${FMT_VERSION} --strip-components=1 \
	&& cd libfmt-${FMT_VERSION} \
    && cmake -G"Unix Makefiles" \
			 -DCMAKE_BUILD_TYPE=RELEASE \
			 -DCMAKE_INSTALL_PREFIX=$ROOTDIR \
             -DFMT_DOC=OFF \
             -DFMT_TEST=OFF . \
    && make --quiet -j $NUM_CPU install/strip \
    && make clean \
    && cd $ROOTDIR/src
	

# ------------------------------------------------------------------------------------------------------------------------
# Download and install gdal library from sources
# ------------------------------------------------------------------------------------------------------------------------ 

RUN wget http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz \
    && tar -xvf gdal-${GDAL_VERSION}.tar.gz && cd gdal-${GDAL_VERSION} \
    && ./configure  --without-libtool --with-hide-internal-symbols \
        --with-python --with-spatialite --with-pg --with-curl --prefix=$ROOTDIR \
        --with-libtiff=internal --with-rename-internal-libtiff-symbols \
        --with-geotiff=internal --with-rename-internal-libgeotiff-symbols \        
    && make --quiet -j $NUM_CPU \
    && make install \
    && make clean \
    && cd $ROOTDIR/src 
	

# ------------------------------------------------------------------------------------------------------------------------
# Strip symbols from  gdal object files to minimize their file size and streamline them for distribution.
# ------------------------------------------------------------------------------------------------------------------------

RUN strip -s $ROOTDIR/lib/libgdal.so 
RUN for i in $ROOTDIR/lib/python3/dist-packages/osgeo/*.so; do strip -s $i 2>/dev/null || /bin/true; done 
RUN strip -s $ROOTDIR/bin/gdal_contour \
	&& strip -s $ROOTDIR/bin/gdal_grid \
    && strip -s $ROOTDIR/bin/gdal_rasterize \
	&& strip -s $ROOTDIR/bin/gdal_translate \
	&& strip -s $ROOTDIR/bin/gdaladdo \
    && strip -s $ROOTDIR/bin/gdalbuildvrt \
	&& strip -s $ROOTDIR/bin/gdaldem \
	&& strip -s $ROOTDIR/bin/gdalenhance \
    && strip -s $ROOTDIR/bin/gdalinfo \
	&& strip -s $ROOTDIR/bin/gdallocationinfo \
	&& strip -s $ROOTDIR/bin/gdalmanage \
    && strip -s $ROOTDIR/bin/gdalserver \
	&& strip -s $ROOTDIR/bin/gdalsrsinfo \
	&& strip -s $ROOTDIR/bin/gdaltindex \
    && strip -s $ROOTDIR/bin/gdaltransform \
	&& strip -s $ROOTDIR/bin/gdalwarp \
	&& strip -s $ROOTDIR/bin/gnmanalyse \
    && strip -s $ROOTDIR/bin/gnmmanage \
	&& strip -s $ROOTDIR/bin/nearblack \
	&& strip -s $ROOTDIR/bin/ogr2ogr \
    && strip -s $ROOTDIR/bin/ogrinfo \
	&& strip -s $ROOTDIR/bin/ogrlineref \
	&& strip -s $ROOTDIR/bin/ogrtindex \
    && strip -s $ROOTDIR/bin/testepsg 


# ------------------------------------------------------------------------------------------------------------------------
# Add an environmental variable that declares the Custom Certificate Authority (CA) certificate that we intend to use.
# ------------------------------------------------------------------------------------------------------------------------

ENV CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt


# ------------------------------------------------------------------------------------------------------------------------
# Add environmental variables that declare the GDAL settings that we intend to use.
#
# - GDAL_DATA							=	Location of supporting files used by GDAL libraries / GDAL and OGR utilities								
# - GDAL_HTTP_MERGE_CONSECUTIVE_RANGES	=	Whether consecutive ranges of a single ReadMultiRange request should be merged 
# - GDAL_HTTP_MULTIPLEX					=	Whether multiplexing can be used to download multiple ranges in parallel
# - GDAL_HTTP_VERSION					=	The HTTP version to use with GDAL
# ------------------------------------------------------------------------------------------------------------------------

ENV GDAL_DATA $ROOTDIR/share/gdal
ENV GDAL_HTTP_MERGE_CONSECUTIVE_RANGES YES
ENV GDAL_HTTP_MULTIPLEX YES
ENV GDAL_HTTP_VERSION 2


# ------------------------------------------------------------------------------------------------------------------------
# Set up Python packages and extensions for programming and manipulating the GDAL Library.
# Note: SWIG is an interface compiler that connects programs written in C and C++ with scripting languages such as Python.
# ------------------------------------------------------------------------------------------------------------------------

RUN apt-get update -y \
    && apt-get remove -y --purge build-essential \
    && cd $ROOTDIR/src/gdal-${GDAL_VERSION}/swig/python \
    && python3 setup.py build \
    && python3 setup.py install 
   

# ------------------------------------------------------------------------------------------------------------------------
# Update library links and cache
# ------------------------------------------------------------------------------------------------------------------------
RUN ldconfig


# ------------------------------------------------------------------------------------------------------------------------
# Clear all downloaded source code files:  
# ------------------------------------------------------------------------------------------------------------------------

RUN rm -Rf $ROOTDIR/src/*

