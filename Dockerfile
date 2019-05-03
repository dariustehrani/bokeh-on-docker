# use Ubuntu 18.04 as base image
FROM ubuntu:18.04

# give our new image a name
LABEL Name=bokeh-on-docker 
LABEL Version=0.0.1

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

CMD [ "/bin/bash" ]

# update os & install some basic packages needed later
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y -qq \
    && apt-get dist-upgrade -y -qq \
    && apt-get install -y -qq --no-install-recommends wget gnupg curl bzip2 ca-certificates apt-transport-https unzip unixodbc unixodbc-dev \
    && apt-get autoremove -y -qq \
    && apt-get clean -qq \
    && rm -rf /var/lib/apt/lists/*

# install ODBC driver for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update -y
RUN ACCEPT_EULA=Y apt-get install msodbcsql17 -y

# set the required versions
ARG PYTHON=3
ARG MINICONDA3_VERSION=4.6.14

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA3_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ARG TINI_VERSION=v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# set default conda channels
RUN conda config --set auto_update_conda off
RUN conda config --append channels bokeh
RUN conda config --append channels conda-forge
RUN conda config --get channels

# Do not update conda for now
RUN conda install --quiet --yes \
    conda \
    && conda clean -a -y -q

#ARG BOKEH_VERSION=1.1.0
#ARG TORNADO_VERSION=6.0.2
RUN conda install --quiet --yes \
    bokeh=$BOKEH_VERSION \
    nodejs \ 
    tornado=$TORNADO_VERSION \
    pyodbc \
    && conda clean -a -y -q

# In case old tornado version is required
# ARG TORNADO_VERSION
# RUN sh -c 'if [[ ! -z "$TORNADO_VERSION" ]]; then echo Installing old tornado $TORNADO_VERSION; conda install --quiet --yes tornado=$TORNADO_VERSION; conda clean -ay; fi'

RUN python -c "import tornado; print('tornado version=' + tornado.version)"
# Workaround, just calling `bokeh info` crashes
RUN env BOKEH_RESOURCES=cdn bokeh info

# prepare the entrypoint for bokeh
COPY ./scripts/entrypoint.sh /usr/local/bin/

# copy your application into the container
RUN mkdir /bokeh-app
COPY bokeh-app/* /bokeh-app/

EXPOSE 5006
ENTRYPOINT ["entrypoint.sh"]
