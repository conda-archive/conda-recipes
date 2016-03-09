# Taken from http://zetcode.com/gfx/pycairo/backends/

import tempfile
import os

import cairo

svg_file = os.path.join(tempfile.gettempdir(), "svgfile.svg")

if os.path.isfile(svg_file):
    os.remove(svg_file)

ps = cairo.SVGSurface(svg_file, 390, 60)
cr = cairo.Context(ps)

cr.set_source_rgb(0, 0, 0)
cr.select_font_face("Sans", cairo.FONT_SLANT_NORMAL,
                    cairo.FONT_WEIGHT_NORMAL)
cr.set_font_size(40)

cr.move_to(10, 50)
cr.show_text("Hello world!")
cr.show_page()
