# Copyright (c) 3D geoinformation research group.
# Distributed under the terms of the MIT License.

FROM jupyter/datascience-notebook:latest

LABEL maintainer.email="b.dukai@tudelft.nl" maintainer.name="Balázs Dukai"
LABEL description="Image for Jupyter notebooks with spatial libraries"
LABEL org.name="3D Geoinformation Research Group, Delft University of Technology, Netherlands" org.website="https://3d.bk.tudelft.nl/"

USER root
# Add the staff and student groups from Godzilla
RUN groupadd -g 1006 staff3d \
 && groupadd -g 1024 student3d

# from https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile
USER $NB_UID

RUN conda install nodejs \
 ;  jupyter labextension install \ 
        @jupyter-widgets/jupyterlab-manager \
        @jupyterlab/toc \
        @jupyterlab/debugger \
        @jupyterlab/git \
        @jupyterlab/shortcutui \
 ;  conda install -c conda-forge -c QuantStack \
        xeus-python=0.9.0 \
        ptvsd \
        xeus-cling \
        xwidgets \
        boost-cpp \
        gdal \
        cgal \
        lastools \
        pdal \
 ;  jupyter serverextension enable --sys-prefix --py jupyterlab 

# python, R libraries
RUN conda install --quiet --yes \
    psycopg2 \
    shapely \
    fiona \
    rasterio \
    plotly \
    geopandas \
    python-pdal \
    papermill \
    black \
 && conda clean --all -f -y \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}" 

# Install R packages
RUN conda install --quiet --yes \
    'r-rpostgres' \
    'r-dbplot' \
    'r-hrbrthemes' \
    'rpy2' \
    'r-formatr' \
 && conda clean --all -f -y \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

# Need the latest ipython-sql from pypi, because it is not available on anaconda, 
# also jupyterlab-git needs to be installed with pip
RUN /opt/conda/bin/pip3 install --upgrade \
       ipython-sql \
       jupyterlab-git

# Do a jupyterlab build to include all the installed exetensions
RUN jupyter lab build
 
# Install fonts of hrbrthemes
RUN mkdir -p ~/.local/share/fonts \
 && cp -R /opt/conda/lib/R/library/hrbrthemes/fonts/* ~/.local/share/fonts \ 
 && cd ~/.local/share/fonts \
 && wget https://download.jetbrains.com/fonts/JetBrainsMono-2.001.zip \
 && unzip JetBrainsMono-2.001.zip \
 && rm JetBrainsMono-2.001.zip \
 && fc-cache -f -v

# Clean up
RUN conda clean --all -y
