###################################################################

# Created by write_sdc on Sun Nov  3 20:49:15 2019

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
create_clock [get_ports clk]  -name clock  -period 2  -waveform {0 1}
set_clock_latency 0.2  [get_clocks clock]
set_clock_uncertainty 0.3  [get_clocks clock]
set_clock_transition -min -fall 0.5 [get_clocks clock]
set_clock_transition -min -rise 0.5 [get_clocks clock]
set_clock_transition -max -fall 0.5 [get_clocks clock]
set_clock_transition -max -rise 0.5 [get_clocks clock]
group_path -name CLOCK  -to [get_clocks clock]
set_input_delay -clock clock  1  [get_ports rst_n]
set_input_delay -clock clock  1  [get_ports {din0[7]}]
set_input_delay -clock clock  1  [get_ports {din0[6]}]
set_input_delay -clock clock  1  [get_ports {din0[5]}]
set_input_delay -clock clock  1  [get_ports {din0[4]}]
set_input_delay -clock clock  1  [get_ports {din0[3]}]
set_input_delay -clock clock  1  [get_ports {din0[2]}]
set_input_delay -clock clock  1  [get_ports {din0[1]}]
set_input_delay -clock clock  1  [get_ports {din0[0]}]
set_input_delay -clock clock  1  [get_ports {din1[7]}]
set_input_delay -clock clock  1  [get_ports {din1[6]}]
set_input_delay -clock clock  1  [get_ports {din1[5]}]
set_input_delay -clock clock  1  [get_ports {din1[4]}]
set_input_delay -clock clock  1  [get_ports {din1[3]}]
set_input_delay -clock clock  1  [get_ports {din1[2]}]
set_input_delay -clock clock  1  [get_ports {din1[1]}]
set_input_delay -clock clock  1  [get_ports {din1[0]}]
set_output_delay -clock clock  1  [get_ports {dout[7]}]
set_output_delay -clock clock  1  [get_ports {dout[6]}]
set_output_delay -clock clock  1  [get_ports {dout[5]}]
set_output_delay -clock clock  1  [get_ports {dout[4]}]
set_output_delay -clock clock  1  [get_ports {dout[3]}]
set_output_delay -clock clock  1  [get_ports {dout[2]}]
set_output_delay -clock clock  1  [get_ports {dout[1]}]
set_output_delay -clock clock  1  [get_ports {dout[0]}]
set_output_delay -clock clock  1  [get_ports equal]
