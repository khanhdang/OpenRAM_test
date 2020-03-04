word_size = 8
num_words = 512

# num_rw_ports = 1
# num_r_ports = 1
# num_w_ports = 0


tech_name = "freepdk45"
process_corners = ["TT"]
supply_voltages = [1.0]
temperatures = [25]

route_supplies = True
check_lvsdrc = False

output_path = "output_w{0}_b{1}_{2}".format(word_size,
                                        num_words,
                                        tech_name)
output_name = "sram_w{0}_b{1}_{2}".format(word_size,
                                        num_words,
                                        tech_name)
