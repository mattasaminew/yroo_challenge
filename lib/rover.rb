class Rover
	COMPASS_DIRECTIONS = %w(N E S W).freeze # must be in clockwise order
	VALID_CMDS = %w(L R M).freeze

  attr_accessor :mission
	attr_reader :completed, :result, :errors

  def initialize x, y, dir, cmd_string
		@completed = false
		@result = nil
		@errors = []

		@cmd_string = cmd_string
		@loc_x = x
		@loc_y = y

		if COMPASS_DIRECTIONS.index(dir)
			@direction = dir
		else
			@errors << "Invalid direction: #{dir}"
		end
  end

	def run_commands
		if errors.empty?
			@cmd_string.split('').each do |cmd|
				command_rover(cmd)
				break if @errors.last == "Out of bounds"
			end

			@result = "#{@loc_x} #{@loc_y} #{@direction}"
		end

		@completed = true
	end

	private

	def command_rover cmd
		if VALID_CMDS.index(cmd)
			case cmd
			when 'L', 'R'
				turn_rover(cmd)
			when 'M'
				move_rover
			end
		else
			@errors << "Invalid command: #{cmd}"
		end
	end

	def turn_rover turn_direction
		i = COMPASS_DIRECTIONS.index(@direction)

		if turn_direction == 'R'
			if i < COMPASS_DIRECTIONS.length - 1
				i += 1
			else
				i = 0
			end
		elsif turn_direction == 'L'
			if i > 0
				i -= 1
			else
				i = COMPASS_DIRECTIONS.length - 1
			end
		end

		@direction = COMPASS_DIRECTIONS[i]
	end

	def move_rover
		x, y = @loc_x, @loc_y

		case @direction
		when 'N'
			p !check_obstacles('N') && (@loc_y < mission.max_y)

			@loc_y += 1 if !mission || (mission && (!check_obstacles('N') && (@loc_y < mission.max_y)))
		when 'E'
			@loc_x += 1 if !mission || (mission && (@loc_x < mission.max_x))
		when 'S'
			@loc_y -= 1 if @loc_y > 0
		when 'W'
			@loc_x -= 1 if @loc_x > 0
		end

		if x == @loc_x && y == @loc_y
			@errors << "Out of bounds"
		end
	end

	def check_obstacles dir
		mission.obstacles.each do |o|
			if dir == "N"
				return true if o[0] == @loc_x && @loc_y == o[1] - 1
			elsif dir == "E"
				return true if o[0] == @loc_x && @loc_y == o[1] - 1
			elsif dir == "S"
				return true if o[0] == @loc_x && @loc_y == o[1] - 1
			elsif dir == "W"
				return true if o[0] == @loc_x && @loc_y == o[1] - 1
			end
		end
	end
end
