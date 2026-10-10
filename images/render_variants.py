# Usage: klayout -b -r render_variants.py -rd mode=zoom|overview -rd gds=... -rd lyp=... -rd out=...
# zoom    : ~100x100 um box at the die centre, all layers, no text labels
# overview: whole die, only areaid.standardc (81/4), met1.drawing (68/20), met2.drawing (69/20), no text labels
import pya
lv = pya.LayoutView()
lv.load_layout(gds, True)
lv.load_layer_props(lyp)
lv.set_config("text-visible", "false")
lv.max_hier()
bb = lv.box()  # um
if mode == "zoom":
    cx, cy = (bb.left + bb.right) / 2, (bb.bottom + bb.top) / 2
    lv.zoom_box(pya.DBox(cx - 50, cy - 50, cx + 50, cy + 50))
else:
    keep = {(81, 4), (68, 20), (69, 20)}
    for l in lv.each_layer():
        l.visible = (l.source_layer, l.source_datatype) in keep
    lv.zoom_fit()
lv.save_image(out, 2000, 2000)
print("saved", out, "bbox", bb)
