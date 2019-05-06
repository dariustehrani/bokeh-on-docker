# bokeh-on-docker
Docker Image intended to deploy data-science apps based on Python Bokeh.

# contents
* ubuntu 18.04 base
* Microsoft ODBC Driver
* miniconda3
* bokeh, tornado, nodejs

# serving
by default the dockerfile will copy all files contained in the bokeh-app folder into the image. 
please make sure to have a main.py in there.

# azure devops docker build
* you can point your azure devops pipeline setup to the repository.
TODO
