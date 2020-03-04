#set PERIOD  2
set PERIOD  2
set INPUT_DELAY  1
set OUTPUT_DELAY  1
set CLOCK_LATENCY 0.2
set MIN_IO_DELAY 1.0
set MAX_TRANSITION 0.5

##added by me 
#set_fix_multiple_port_nets -all
#set_fix_multiple_port_nets -feedthroughs
#set_fix_multiple_port_nets -outputs

## CLOCK BASICS
create_clock -name "clock" -period $PERIOD [get_ports clk]
set_clock_latency $CLOCK_LATENCY [get_clocks clock]
set_clock_uncertainty 0.3 [get_clocks clock]
set_clock_transition 0.5 [get_clocks clock]


## GROUPING
group_path  -name CLOCK\
            -to clock\
            -weight 1

puts [all_inputs]
## IN/OUT
set INPUTPORTS [remove_from_collection [all_inputs] [get_ports clk]]
set OUTPUTPORTS [all_outputs]
  
set_input_delay -clock "clock" -max $INPUT_DELAY $INPUTPORTS 
set_output_delay -clock "clock" -max $OUTPUT_DELAY $OUTPUTPORTS
set_input_delay -clock "clock" -min $MIN_IO_DELAY $INPUTPORTS 
set_output_delay -clock "clock" -min $MIN_IO_DELAY $OUTPUTPORTS
