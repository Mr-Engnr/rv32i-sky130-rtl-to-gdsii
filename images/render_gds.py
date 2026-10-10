# Usage: klayout -b -r render_gds.py -rd gds=<in.gds> -rd lyp=<layers.lyp> -rd out=<out.png>
import pya
lv = pya.LayoutView()
lv.load_layout(gds, True)
lv.load_layer_props(lyp)
lv.max_hier()
lv.zoom_fit()
lv.save_image(out, 2400, 2400)
print("saved", out)
