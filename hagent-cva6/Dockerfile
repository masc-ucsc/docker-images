FROM mascucsc/hagent-builder:latest

# Set environment variable for CVA6 RTL path
ENV CVA6_HOME=/code/cva6
ENV DUT_ROOT=/code/cva6

# Set working directory
WORKDIR /code

# Switch to user early (assumes 'user' is in base image)
USER user

# Clone only CVA6 with submodules
RUN git clone --recursive https://github.com/openhwgroup/cva6.git ${CVA6_HOME}

#
