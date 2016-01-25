FROM bioconductor/release_core

MAINTAINER kono@ucsd.edu

RUN apt-get update && apt-get install -y libpng-dev curl

# For Flask API server
RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python
RUN pip install flask-restful requests


ADD . /app

RUN R -e 'biocLite("clusterProfiler")'

WORKDIR /app

CMD R CMD BATCH ./R/run.R