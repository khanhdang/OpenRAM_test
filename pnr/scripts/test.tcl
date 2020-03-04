# place and route script
# version : 1.0
#
#
global env

set OSU_FREEPDK $env(FREEPDK45)/osu_soc
set model_name "top"

win

source scripts/$model_name.globals

set init_mmmc_file scripts/$model_name.view

init_design
#
# Step 2: FloorPlan & Macro(Floorplan --> Specify Floorplan)
#

floorPlan -r 1.2 0.6  15 15 15 15

# Create Power structures

#set halo#
#addHaloToBlock 0.5 0.5 0.5 0.5 -allBlock


# question on this number? how you select it?

placeInstance R0 15 15

set TSV_reg_dim 15
set TSV_X 125
for {set tsv_i 0} {$tsv_i < 8} {incr tsv_i} {
  set TSV_Y [expr {$tsv_i*$TSV_reg_dim+25}] 
  placeInstance \TSV_GEN[$tsv_i].TSV0 $TSV_X $TSV_Y
  createObstruct [expr {$TSV_X-$TSV_reg_dim/3}] [expr {$TSV_Y-$TSV_reg_dim/3}] [expr {$TSV_X+$TSV_reg_dim*2/3}] [expr {$TSV_Y+$TSV_reg_dim*2/3}]  
} 
#amoebaPlace
# Place your hard-macro manually
#saveDesign floor.enc

#
# Step 3: Power ring (Power --> Power Planning --> Add Ring)
##
#createPGPin VDD -net VDD
#createPGPin VSS -net VSS
#globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
#globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose

addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -center 1 -stacked_via_top_layer TM -type core_rings -jog_distance 1.0 -threshold 1.0 -nets {VDD VSS} -follow core -stacked_via_bottom_layer metal1 -layer {bottom metal10 top metal10 right metal9 left metal9} -width 4 -spacing 2

#addRing -nets {VSS VDD} -type core_rings \
#  -spacing_top 2 -spacing_bottom 2 -spacing_right 2 -spacing_left 2 \
#  -width_top 4 -width_bottom 4 -width_right 4 -width_left 4 \
#  -around core -jog_distance 0.095 -threshold 0.095 \
# -layer_top metal10 -layer_bottom metal10 -layer_right metal9 \
# -layer_left metal9 \
# -stacked_via_top_layer metal10 -stacked_via_bottom_layer metal1 
# addRing -nets {VDD VSS} -follow core -stacked_via_top_layer metal10 -stacked_via_bottom_layer metal1 -layer {bottom metal1 top metal1 right metal2 left metal2} -width 3 -spacing 1

##
## Step 4: Power stripe (Power --> Power Planning --> Add Striple)
##
#addStripe -nets {VSS VDD} -layer metal8 -width 1 -spacing 6 \
  #-block_ring_top_layer_limit metal9 -block_ring_bottom_layer_limit metal7 \
  #-padcore_ring_top_layer_limit metal9 -padcore_ring_bottom_layer_limit metal7 \
  #-stacked_via_top_layer metal10 -stacked_via_bottom_layer metal1 \
  #-set_to_set_distance 15 -xleft_offset 6 -merge_stripes_value 0.095 \
  #-max_same_layer_jog_length 1.6 

##
## Step 5: Power route (Route --> Special Router)
##


#addRing -nets {VDD VSS} -width 0.6 -spacing 0.5 \
           #-layer [list top 7 bottom 7 left 6 right 6]
#addStripe -nets {VSS VDD} -layer 6 -direction vertical \
           #-width 0.4 -spacing 0.5 -set_to_set_distance 5 -start 0.5
#addStripe -nets {VSS VDD} -layer 7 -direction horizontal \
           #-width 0.4 -spacing 0.5 -set_to_set_distance 5 -start 0.5

#sroute -nets { VDD VSS }
#sroute -noBlockPins -noPadRings
##
