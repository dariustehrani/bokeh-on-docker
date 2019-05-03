from bokeh.io import curdoc, show
from bokeh.plotting import figure
from bokeh.resources import CDN
from bokeh.embed import file_html

p = figure(title='Hello world!')
p.line([1, 2, 3, 4, 5], [6, 7, 2, 4, 5], line_width=2)
curdoc().add_root(p)
show(p)
