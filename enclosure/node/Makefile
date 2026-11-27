# SPDX-License-Identifier: CERN-OHL-P-2.0
# thesada node case. Needs openscad 2025+ (manifold backend) and python3.

SCAD   := node-case.scad
OPENSCAD ?= openscad
OSCAD  := $(OPENSCAD) --backend=manifold --quiet
# OUT moves the STLs, the repo test renders into a scratch dir and compares with stl/
OUT    ?= stl
PARTS  := body lid_with_label_recess lid_solid label_insert gasket gland_grommet gland_cap jack_boot jack_cap dcjack_adapter dcjack_adapter_gasket ear_magnet_adapter body_magnets modifier_inserts modifier_carrier_mounts coupon_body coupon_lid coupon_gasket insert_test insert_test_fine insert_test_fine_small
STLS   := $(PARTS:%=$(OUT)/%.stl)
# freenove variant: only the parts that change with the case size, the small parts are shared
FPARTS := body lid_with_label_recess lid_solid label_insert gasket body_magnets modifier_inserts modifier_carrier_mounts
FSTLS  := $(FPARTS:%=$(OUT)/freenove/%.stl)
FRE    := -D 'variant="freenove"'
VIEW   := --render --colorscheme=Tomorrow --projection=p

.DEFAULT_GOAL := help
.PHONY: help stl png stl-freenove png-freenove test fresh clean

##@ General
help: ## List targets (changes nothing)
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "  %-10s %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) }' $(MAKEFILE_LIST)

##@ Build
stl: $(STLS) ## Render every part to stl/, in print orientation

# OpenSCAD exits 0 when it cannot write the file, so an empty one fails too
$(STLS): $(OUT)/%.stl: $(SCAD)
	@mkdir -p $(OUT)
	$(OSCAD) --export-format binstl -D 'part="$*"' -o $@ $(SCAD)
	@test -s $@ || { rm -f $@; echo "FAIL no output: $@"; exit 1; }

stl-freenove: $(FSTLS) ## Render the Freenove FNK0085 variant to stl/freenove/
$(FSTLS): $(OUT)/freenove/%.stl: $(SCAD)
	@mkdir -p $(OUT)/freenove
	$(OSCAD) --export-format binstl $(FRE) -D 'part="$*"' -o $@ $(SCAD)
	@test -s $@ || { rm -f $@; echo "FAIL no output: $@"; exit 1; }

png: ## Render the closed and exploded previews to png/
	@mkdir -p png
	$(OSCAD) $(VIEW) --imgsize=1600,1200 -D 'part="assembly"' --camera=38,62,22,66,0,300,350 -o png/assembly.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1600,1600 -D 'part="exploded"' -D explode=90 --camera=38,62,80,68,0,325,620 -o png/exploded.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=2000,1300 -D 'part="inside"' --camera=45,-30,20,40,0,255,560 -o png/inside.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1600,1200 -D 'part="coupon_body"' --camera=8,8,20,55,0,35,170 -o png/coupon.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1800,1200 -D 'part="modifiers"' --camera=38,62,60,60,-10,40,330 -o png/modifiers.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1600,1200 -D 'part="gland_wall"' --camera=88,46,24,80,0,75,250 -o png/gland_wall.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1600,1200 -D 'part="gland_wall_in"' --camera=80,46,24,70,0,255,240 -o png/gland_wall_in.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1600,1200 -D 'part="sma_wall"' --camera=44,132,24,80,0,165,200 -o png/sma_wall.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1600,1200 -D 'part="port_wall"' --camera=-14,36,18,80,0,255,200 -o png/port_wall.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1600,1200 -D 'part="port_wall_in"' --camera=-6,40,18,65,0,75,190 -o png/port_wall_in.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1200,1400 -D 'part="dcjack_adapter_view"' --camera=4,0,14,75,0,30,150 -o png/dcjack_adapter.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1600,1100 -D 'part="ear_adapter_back"' --camera=38,-14,6,215,0,10,230 -o png/ear_adapter_back.png $(SCAD)
	$(OSCAD) --render --colorscheme=Tomorrow --projection=o --imgsize=1800,900 -D 'part="ear_adapter_side"' --camera=38,60,22,90,0,90,260 -o png/ear_adapter_side.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1400,1600 -D 'part="body_magnets_back"' --camera=38,59,10,205,0,15,430 -o png/body_magnets_back.png $(SCAD)
	$(OSCAD) --render --colorscheme=Tomorrow --projection=o --imgsize=1800,1200 -D 'part="section"' --camera=48,-6,46,90,0,90,22 -o png/section.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1400,1000 -D 'part="insert_test"' --camera=15,-6,8,50,0,20,110 -o png/insert_test.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1400,1000 -D 'part="insert_test_fine"' --camera=15,-6,8,50,0,20,110 -o png/insert_test_fine.png $(SCAD)
	$(OSCAD) $(VIEW) --imgsize=1400,1000 -D 'part="insert_test_fine_small"' --camera=15,-6,8,50,0,20,110 -o png/insert_test_fine_small.png $(SCAD)

png-freenove: ## Render the Freenove variant previews to png/freenove/
	@mkdir -p png/freenove
	$(OSCAD) $(VIEW) $(FRE) --imgsize=1600,1200 -D 'part="assembly"' --camera=38,30,22,66,0,300,300 -o png/freenove/assembly.png $(SCAD)
	$(OSCAD) $(VIEW) $(FRE) --imgsize=1600,1600 -D 'part="exploded"' -D explode=80 --camera=38,30,70,68,0,325,520 -o png/freenove/exploded.png $(SCAD)
	$(OSCAD) $(VIEW) $(FRE) --imgsize=2000,1300 -D 'part="inside"' --camera=40,-30,20,40,0,250,430 -o png/freenove/inside.png $(SCAD)
	$(OSCAD) --render --colorscheme=Tomorrow --projection=o $(FRE) --imgsize=1800,1200 -D 'part="section_board"' --camera=46,30,26,90,0,90,150 -o png/freenove/section.png $(SCAD)
	$(OSCAD) --render --colorscheme=Tomorrow --projection=o $(FRE) --imgsize=1800,1200 -D 'part="dcjack_section"' --camera=40,30,22,90,0,270,200 -o png/freenove/dcjack_section.png $(SCAD)
	$(OSCAD) $(VIEW) $(FRE) --imgsize=1800,1400 -D 'part="dcjack_inside"' --camera=38,30,18,30,0,20,300 -o png/freenove/dcjack_inside.png $(SCAD)
	$(OSCAD) $(VIEW) $(FRE) --imgsize=1600,1200 -D 'part="gland_wall"' --camera=88,30,28,80,0,75,190 -o png/freenove/gland_wall.png $(SCAD)
	$(OSCAD) $(VIEW) $(FRE) --imgsize=1600,1200 -D 'part="gland_wall_in"' --camera=80,30,26,70,0,255,190 -o png/freenove/gland_wall_in.png $(SCAD)

##@ Check
test: stl stl-freenove ## Overhang check on every printed part (flat ceilings are listed as bridges)
	@for f in $(STLS) $(FSTLS); do echo "== $$f"; python3 check_overhang.py $$f || exit 1; done

fresh: ## Compare stl/ with a render in OUT (make fresh OUT=../../build/fresh)
	python3 ../../tools/stl_compare.py $(OUT) stl $(PARTS:%=%.stl) $(FPARTS:%=freenove/%.stl)

clean: ## Remove rendered files
	rm -rf $(OUT) png
