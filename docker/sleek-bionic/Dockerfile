# ========================================================================================================================
#
# Docker Image based on Ubuntu 18.04 for building moja sleek libraries and executables
#
# Building this Docker: 
#   docker build --build-arg BUILD_TYPE=RELEASE \
#                --build-arg NUM_CPU=4 \
#				 --build-arg GITHUB_AT=[TOKEN] \
#				 --build-arg SLEEK_BRANCH=release/sleek/1_0_6 \
#				 -t mojaglobal/sleek:bionic .
#
# ========================================================================================================================


# ------------------------------------------------------------------------------------------------------------------------
# Specify the Parent Image from which our image should be built: In this case mojaglobal/flint:bionic.
# ------------------------------------------------------------------------------------------------------------------------

FROM mojaglobal/flint:bionic


# ------------------------------------------------------------------------------------------------------------------------
# Add a little metadata to describe the image:
# ------------------------------------------------------------------------------------------------------------------------

LABEL project="=FLINT Docker Builds" \
  	  image="SLEEK Image" \
  	  version="1.0" \
  	  maintainer="Moja Global <info@moja.global>"


# ------------------------------------------------------------------------------------------------------------------------
# Add a build time variable that will allow us to specify the Debian Interface to use during the build.
# Set it to noninteractive by default i.e an interface that never interacts with its users at all.
# ------------------------------------------------------------------------------------------------------------------------

ARG DEBIAN_FRONTEND=noninteractive


# ------------------------------------------------------------------------------------------------------------------------
# Add a build time variable that will allow us to specify the sleek repository branch to use during the build.
# Do not set a default value for it forcing us to provide it at build time
# ------------------------------------------------------------------------------------------------------------------------

ARG SLEEK_BRANCH


# ------------------------------------------------------------------------------------------------------------------------
# Add a build time variable that will allow us to specify the type of build that we want: Debug or release.
# Set its default value to debug
# ------------------------------------------------------------------------------------------------------------------------

ARG BUILD_TYPE=DEBUG


# ------------------------------------------------------------------------------------------------------------------------
# Add a build time variable that will allow us to specify the Github Access Token to use during the build.
# Do not set a default value for it forcing us to provide it at build time
# ------------------------------------------------------------------------------------------------------------------------

ARG GITHUB_AT


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
# Add environmental variables that collectively declare the versions of additional 3rd party libs that we intend to use.
#
# - rabbitmq-c							=	C-language AMQP client library for use with v2.0+ of the RabbitMQ broker
# - SimpleAmqpClient					=	C++ wrapper around the rabbitmq-c C library
# ------------------------------------------------------------------------------------------------------------------------

ENV RABBITMQ_C_VERSION 0.9.0
ENV SIMPLE_AMQP_CLIENT_VERSION 2.4.0


# ------------------------------------------------------------------------------------------------------------------------
# Download and install rabbitmq-c from sources:
# ------------------------------------------------------------------------------------------------------------------------

RUN wget https://github.com/alanxz/rabbitmq-c/archive/v${RABBITMQ_C_VERSION}.tar.gz \
	&& tar xzf v${RABBITMQ_C_VERSION}.tar.gz \
    && mkdir -p rabbitmq-c-${RABBITMQ_C_VERSION}/build \
	&& cd rabbitmq-c-${RABBITMQ_C_VERSION}/build \
    && cmake -DCMAKE_BUILD_TYPE=Release \
             -DCMAKE_INSTALL_PREFIX=$ROOTDIR .. \
	&& make --quiet -j $NUM_CPU \
    && make --quiet install \
    && make clean \
    && cd $ROOTDIR/src


# ------------------------------------------------------------------------------------------------------------------------
# Download and install SimpleAmqpClient from sources:
# ------------------------------------------------------------------------------------------------------------------------
	
RUN wget https://github.com/alanxz/SimpleAmqpClient/archive/v${SIMPLE_AMQP_CLIENT_VERSION}.tar.gz \
    && tar xzf v${SIMPLE_AMQP_CLIENT_VERSION}.tar.gz  \
    && mkdir -p SimpleAmqpClient-${SIMPLE_AMQP_CLIENT_VERSION}/build \
	&& cd SimpleAmqpClient-${SIMPLE_AMQP_CLIENT_VERSION}/build \
    && cmake -DCMAKE_BUILD_TYPE=RELEASE \
             -DBoost_USE_STATIC_LIBS=OFF \
             -DBUILD_SHARED_LIBS=ON \
             -DCMAKE_INSTALL_PREFIX=$ROOTDIR .. \
	&& make --quiet -j $NUM_CPU \
    && make --quiet install \
    && make clean \
    && cd $ROOTDIR/src	


# ------------------------------------------------------------------------------------------------------------------------
# Download and install SLEEK modules from sources:
# ------------------------------------------------------------------------------------------------------------------------

RUN git clone --recursive --depth 1 -b ${SLEEK_BRANCH} https://${GITHUB_AT}@github.com/SLEEK-TOOLS/moja.sleek.git moja.sleek \
    && mkdir -p moja.sleek/Source/build \
    && cd moja.sleek/Source/build \
    && cmake -DCMAKE_BUILD_TYPE==$BUILD_TYPE -DCMAKE_INSTALL_PREFIX=$ROOTDIR .. \
             -DENABLE_TESTS:BOOL=OFF \
             -DBoost_USE_STATIC_LIBS=OFF \
             -DBUILD_SHARED_LIBS=ON \
             -DMOJA_INCLUDE_DIR=$ROOTDIR/include .. \
 	&& make --quiet -j $NUM_CPU \
    && make --quiet install \
    && make clean \
    && cd $ROOTDIR/src
	

# ------------------------------------------------------------------------------------------------------------------------
# Add a new user account:
# ------------------------------------------------------------------------------------------------------------------------

RUN useradd -ms /bin/bash moja

# ------------------------------------------------------------------------------------------------------------------------
# Make the newly created user the default user:
# ------------------------------------------------------------------------------------------------------------------------

USER moja

# ------------------------------------------------------------------------------------------------------------------------
# Update the working directory for all the RUN, CMD, ENTRYPOINT, COPY and ADD instructions that follow:
# ------------------------------------------------------------------------------------------------------------------------

WORKDIR /home/moja
