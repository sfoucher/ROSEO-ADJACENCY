# Use a small Python 3.11 base image
FROM python:3.11-slim

# Set environment variables to ensure non-interactive installs
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies required for compilation and downloading
# gfortran: for compiling the Fortran code
# make: for executing the Makefile
# wget: for downloading the source
RUN apt-get update && apt-get install -y \
    gfortran \
    make \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory to /content
WORKDIR /content

# Create the directory structure as requested
RUN mkdir -p /content/source /content/build/6SV/1.1

# Download the 6SV source code
RUN wget https://rtwilson.com/downloads/6SV-1.1.tar -O /content/source/6SV-1.1.tar

# Change to build directory and extract the tarball
WORKDIR /content/build
RUN tar -xvf /content/source/6SV-1.1.tar

# Change to the extracted directory
WORKDIR /content/build/6SV1.1

# Copy the local Makefile from the Docker build context into the container
# Ensure a file named 'Makefile' exists in the same folder as this Dockerfile
COPY Makefile .

# Execute the Makefile to build the software
RUN make

# Make the binary executable and create the symlink
RUN chmod +x /content/build/6SV1.1/sixsV1.1 && \
    ln -s /content/build/6SV1.1/sixsV1.1 /usr/local/bin/sixs


# (Optional) Run the verification example mentioned in the prompt
# This assumes the tarball extracted an 'Examples' directory parallel to '6SV1.1'
RUN if [ -f "../Examples/Example_In_1.txt" ]; then \
        /content/build/6SV1.1/sixsV1.1 < ../Examples/Example_In_1.txt; \
    fi
WORKDIR /content
COPY test_tmart.py .
RUN git clone https://github.com/yulunwu8/tmart
RUN pip install -e ./tmart
RUN pip install -q numpy>=2.0 Py6S rasterio>=1.3.9

# Set the default command to run the installed binary
CMD ["sixs"]
