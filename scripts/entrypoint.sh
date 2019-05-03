#!/bin/bash
set -e
exec /opt/conda/bin/bokeh serve bokeh-app --port 8080 --address 0.0.0.0