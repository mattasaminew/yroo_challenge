require_relative 'lib/mission'

input_filepath = ARGV[0]

if input_filepath
	m = Mission.new("input/1.txt")
	m.run_mission

	puts m.result
else
	puts "Please provide input filepath"
end
