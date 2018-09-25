require_relative 'rover'

class Mission
  attr_reader :max_x, :max_y, :rovers, :completed, :result, :errors
	attr_accessor :obstacles

  def initialize txt
		@completed = false
		@result = []
		@errors = []
		@obstacles = []

		@rovers = []
		parse_rover_data(txt)
  end

	def run_mission
		rovers.each_with_index do |r, i|
			r.run_commands
			@result << r.result

			if r.errors.empty?
				@obstacles << r.result.split(' ')
			else
				@errors[i] = r.errors
			end
		end

		@completed = true
	end

	private

	def parse_rover_data txt
		rover_loc = []
		rover_cmd = []

		File.open(txt).each_with_index do |line, index|
			if index == 0
				max_values = line.split(' ')
				@max_x = max_values[0].to_i
				@max_y = max_values[1].to_i
			else
				if index.odd?
					rover_loc << line.split(' ')
				else
					rover_cmd << line.chomp
				end
			end
		end

		rover_loc.tap(&:pop) if rover_loc.length != rover_cmd.length

		rover_loc.each_with_index do |loc, i|
			x = loc[0].to_i
			y = loc[1].to_i
			dir = loc[2]
			cmd = rover_cmd[i]

			if (0..@max_x).include?(x) && (0..@max_y).include?(y)
				add_rover(Rover.new(x, y, dir, cmd))
			end
		end
	end

	def add_rover rover
		@rovers << rover
		rover.mission = self
	end
end
