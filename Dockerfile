# Copyright (c) 3D geoinformation research group.
# Distributed under the terms of the MIT License.
LABEL maintainer.email="b.dukai@tudelft.nl" maintainer.name="Balázs Dukai"
LABEL description="Image for Jupyter notebooks with spatial libraries"
LABEL org.name="3D Geoinformation Research Group, Delft University of Technology, Netherlands" org.website="https://3d.bk.tudelft.nl/"

FROM jupyter/datascience-notebook:latest

USER root
# Add the staff and student groups from Godzilla
RUN groupadd -g 1006 staff3d \
 && groupadd -g 1024 student3d
USER jovyan

RUN conda install nodejs \
 ;  jupyter labextension install \ 
        @jupyter-widgets/jupyterlab-manager \
        @jupyterlab/toc \
        @jupyterlab/debugger \
        @jupyterlab/git \
        @jupyterlab/shortcutui \
 ;  conda install -c conda-forge -c QuantStack \
        xeus-python=0.8.0 \
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
RUN conda install -c conda-forge \
        psycopg2 \
        shapely \
        fiona \
        rasterio \
        python-pdal \
        papermill \
        black \
        r-rpostgres \
        r-dbplot \
        r-hrbrthemes \
        rpy2 \
        r-formatr
# Need the latest ipython-sql from pypi, because it is not available on anaconda, 
# also jupyterlab-git needs to be installed with pip
RUN /opt/conda/bin/pip3 install --upgrade \
       ipython-sql \
       jupyterlab-git

# Do a jupyterlab build to include all the installed exetensions
RUN jupyter lab build
 
# Install fonts of hrbrthemes
RUN mkdir ~/.fonts \
 && cp -R /opt/conda/lib/R/library/hrbrthemes/fonts/*/* ~/.fonts/

# Clean up
RUN conda clean --all -y
