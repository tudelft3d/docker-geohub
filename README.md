# Geohub docker image

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/tudelft3d/geohub)

The docker image is meant for a Jupyter notebook-based workflows on spatial data. It is based on the `jupyter/datascience-notebook:latest` image, therefore includes libraries for data analysis from the Julia, Python, and R communities.

It provides a computational environment for runniing parameterized analysis and reporting.

**Note: This image creates users and groups that are specific to our server. If you reuse the image, best if you modify the users to your needs.**

Available languages:

+ Python
+ R
+ Julia
+ C++

See the Dockerfile for the installed packages additional to the base image.

## Install

```sh
docker pull tudelft3d/geohub:latest
```

## Usage

On Godzilla.

You need to set the correct *user* and *group* to make sure that the permissions are set correctly on the output notebook when using bind mounts. This is done with the `--user $(id -u $(whoami)):staff3d` and `--group-add users` flags.

```sh
docker run \
    --rm \
    --user $(id -u $(whoami)):staff3d \   
    --group-add users \                   
    -w /tmp \                             
    -v "$(pwd)":/tmp \
    --network=jupyterhub-network \   
    geohub \
    papermill /tmp/quality_classification.ipynb /tmp/quality_classification.ipynb \
        -p user <database user>
        -p password <database pw>
        -p dbname <database name>
        -p schema <schema>
        -p table <3d bag table>
```

