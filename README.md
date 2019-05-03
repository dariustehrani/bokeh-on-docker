# bokeh-on-docker
Docker Image intended to deploy data-science apps based on Python Bokeh.

# contents
* ubuntu 18.04 base
* Microsoft ODBC Driver
* miniconda3
* bokeh, tornado, nodejs

# serving
by the dockerfile will copy all files contained in the bokeh-app folder into the image. make sure to have a main.py in this folder.