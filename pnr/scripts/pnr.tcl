# place and route script
# version : 1.0
global env

set OSU_FREEPDK $env(FREEPDK45)/osu_soc
set model_name "top"

win

source scripts/$model_name.globals

set init_mmmc_file scripts/$model_name.view

init_design
set_ccopt_property buffer_cells  "CLKBUF1 CLKBUF2 CLKBUF3"
setDesignMode -process 45
#
# Step 2: FloorPlan & Macro(Floorplan --> Specify Floorplan)
#

floorPlan -r 1.2 0.6  15 15 15 15

#set halo#
addHaloToBlock 0.5 0.5 0.5 0.5 -allBlock


# question on this number? how you select it?

placeInstance R0 15 15

set TSV_reg_dim 15
set TSV_X 125
for {set tsv_i 0} {$tsv_i < 8} {incr tsv_i} {
  set TSV_Y [expr {$tsv_i*$TSV_reg_dim+25}] 
  placeInstance \TSV_GEN[$tsv_i].TSV0 $TSV_X $TSV_Y
  createObstruct [expr {$TSV_X-$TSV_reg_dim/3}] [expr {$TSV_Y-$TSV_reg_dim/3}] [expr {$TSV_X+$TSV_reg_dim*2/3}] [expr {$TSV_Y+$TSV_reg_dim*2/3}]  
} 
# Place your hard-macro manually
#saveDesign floor.enc

#
# Step 3: Power ring (Power --> Power Planning --> Add Ring)
##
#createPGPin VDD -net VDD
#createPGPin VSS -net VSS
#globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
#globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose

createPGPin vdd -net vdd
createPGPin gnd -net gnd
globalNetConnect vdd -type pgpin -pin vdd -inst * -verbose
globalNetConnect gnd -type pgpin -pin gnd -inst * -verbose

addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -center 1 -stacked_via_top_layer TM -type core_rings -jog_distance 1.0 -threshold 1.0 -nets {gnd vdd} -follow core -stacked_via_bottom_layer metal1 -layer {bottom metal10 top metal10 right metal9 left metal9} -width 4 -spacing 2
#addRing -nets {VSS VDD} -type core_rings \
#  -spacing_top 2 -spacing_bottom 2 -spacing_right 2 -spacing_left 2 \
#  -width_top 4 -width_bottom 4 -width_right 4 -width_left 4 \
#  -around core -jog_distance 0.095 -threshold 0.095 \
# -layer_top metal10 -layer_bottom metal10 -layer_right metal9 \
# -layer_left metal9 \
# -stacked_via_top_layer metal10 -stacked_via_bottom_layer metal1 

#addRing -nets {gnd vdd} -follow core -stacked_via_top_layer metal10 -stacked_via_bottom_layer metal1 -layer {bottom metal1 top metal1 right metal2 left metal2} -width 3 -spacing 1

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

#sroute -nets { vdd gnd }

sroute -connect {corePin} -nets vdd
sroute -connect {corePin} -nets gnd


##
## Step 6: Placement (Place --> Standard Cell)
##
placeDesign -prePlaceOpt


##
## Step 7: Optimization (preCTS) (Optimize --> Optimize Design)
##
optDesign -preCTS
report_timing -unconstrained -delay_limit 20 > reports/timing_report_postPlace.rpt

##
## Step 8: Clock tree synthesis (CTS) (Clock --> Cynthesize Clock Tree)
##
#addCTSCellList {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3}
#clockDesign -genSpecOnly Clock.ctstch
#clockDesign -specFile Clock.ctstch -outDir clock_report -fixedInstBeforeCTS

#addCTSCellList {CLKBUF1 CLKBUF2 CLKBUF3}


setCTSMode -engine ccopt
# set_ccopt_property target_max_trans 0.08
# set_ccopt_property target_skew 0.5
create_ccopt_clock_tree -name MY_CLK -source clk
ccopt_design
report_ccopt_clock_trees -file reports/clock_trees.rpt
report_ccopt_skew_groups -file reports/skew_groups.rpt
report_timing -unconstrained -delay_limit 20 > reports/timing_report_postCCopt.rpt


##saveDesign cts.enc

##
## Step 9: Clock tree check (Clock --> Display --> Display Clock Tree)
##

##
## Step 9: Optimization (postCTS) (Optimize --> Optimize Design)
##
 #optDesign -postCTS
 #optDesign -postCTS -hold

##
## Step 10: Detailed route (Route --> Nano Route --> Route)
##
 #setNanoRouteMode -quiet -routeWithTimingDriven true
 #setNanoRouteMode -quiet -routeTopRoutingLayer default
 #setNanoRouteMode -quiet -routeBottomRoutingLayer default
 #setNanoRouteMode -quiet -drouteEndIteration default
 #setNanoRouteMode -quiet -routeWithTimingDriven true
 #routeDesign -globalDetail
routeDesign -globalDetail


##
## Step 11: Optimization (postRoute) (Optimize --> Optimize Design)
##
 #optDesign -postRoute
 #optDesign -postRoute -hold

##saveDesign route.enc

##
## Step 12: Add fillers (Place --> Physical Cells --> Add Filler)
##
addFiller -prefix FILLER -cell FILL

##
## Step 13: Verification (LVS) (Verify --> Verify Connectivity)
##
verifyConnectivity -type all -error 1000 -warning 50 -report reports/top.connect

##
## Step 14: Verification (DRC) (Verify --> Verify Geometry)
##
verifyGeometry -report reports/top.geo
verify_drc   -report reports/top_soc.drc


##
## Step 15: Data out (Timing --> Extract RC, Timing --> Write SDF,
##                    File --> Save --> Netlist)
#saveNetlist output_files/${model_name}_final.vnet
#isExtractRCModeSignoff
#rcOut -spef output_files/${model_name}.spef
#delayCal -sdf output_files/${model_name}.sdf -idealclock

##
## Power report
##
#set_power_analysis_mode -reset
#set_power_analysis_mode -method static -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true
#set_power_output_dir -reset
#set_power_output_dir ./powerReports
#set_default_switching_activity -reset
#set_default_switching_activity -input_activity 0.2 -period 10.0
#read_activity_file -reset
#set_power -reset
#set_powerup_analysis -reset
#set_powerup_analysis -mode accurate -ultrasim_simulation_mode msset_dynamic_power_simulation -reset
#report_power -rail_analysis_format VS -outfile ./powerReports/${model_name}.rpt

saveDesign ${model_name}_final.enc
