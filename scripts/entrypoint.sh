#!/bin/bash
set -e
cd /bokeh-app
exec /opt/conda/bin/bokeh serve . \
--port 8080 \
--address 0.0.0.0 \
--use-xheaders \
--allow-websocket-origin=*
