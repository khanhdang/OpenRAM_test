set SRC_FOLDER "../src"

set OSU_FREEPDK [format "%s%s"  [getenv "FREEPDK45"] "/osu_soc/lib/files"]
set MEM_GEN [format "%s%s"  [getenv "PWD"] "/../output_w8_b512_freepdk45"] 
set TSV_PATH [format "%s%s"  [getenv "HOME"] "/lib/TSV_lib"] 
set search_path [concat  $search_path $OSU_FREEPDK $MEM_GEN $TSV_PATH]
set alib_library_analysis_path $OSU_FREEPDK

set link_library [set target_library [concat [list TSV.db] [list gscl45nm.db] [list dw_foundation.sldb] [list sram_w8_b512_freepdk45_TT_1p0V_25C.db]]]
set target_library "gscl45nm.db"
define_design_lib WORK -path ./WORK

analyze -library WORK -format verilog {../src/no_macro.v}
#analyze -library WORK -format verilog {$SRC_FOLDER/TSV.v}
read_file -format verilog {../src/no_macro.v}
#read_file -format verilog {$SRC_FOLDER/TSV.v}

source -echo $SRC_FOLDER/top+_s0.sdc


link
#set_fix_multiple_port_nets -all -buffer_constants [get_designs top]


# compile	-exact_map -gate_clock
compile

#change_names -rules verilog -verbose -hier
## report_clock_gating > x.txt


#set_fix_hold [all_clocks]
#report_constraints  -min_delay
compile -incremental -only_design


report_area > ./output_files/top_ra.txt
write -f verilog -h -out   ./output_files/no_macro.vnet
write -f  ddc -h -out       ./output_files/no_macro.ddc
write_sdc       ./output_files/no_macro.sdc


exit


