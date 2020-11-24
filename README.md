# Geohub docker image

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/tudelft3d/geohub)

[The geohub image on Docker Hub](https://hub.docker.com/r/tudelft3d/geohub)

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

### Locally

For example:

```sh
docker run
    -v "$(pwd)":/tmp
    --name geohub_container
    -w /tmp
    --network host
    tudelft3d/geohub:latest
```


### On Godzilla.

You need to set the correct *user* and *group* to make sure that the permissions are set correctly on the output notebook when using bind mounts. This is done with the `--user $(id -u $(whoami)):staff3d` and `--group-add users` flags.

```sh
docker run \
    --rm \
    --user $(id -u $(whoami)):staff3d \   
    --group-add users \                   
    -w /tmp \                             
    -v "$(pwd)":/tmp \
    --network=jupyterhub-network \   
    tudelft3d/geohub:latest \
    papermill /tmp/<input notebook>.ipynb /tmp/<output notebook>.ipynb 
```
