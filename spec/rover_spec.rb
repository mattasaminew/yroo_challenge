require_relative '../lib/rover'

describe Rover do

	it "should be completed after calling #run_mission" do
		r = Rover.new(1, 2, 'N', 'LMLMLMLMM')
		expect(r.completed).to eq false
		r.run_commands
		expect(r.completed).to eq true
	end

	it "should set result" do
		r1 = Rover.new(1, 2, 'N', 'LMLMLMLMM')
		r1.run_commands
		expect(r1.result).to eq '1 3 N'

		r2 = Rover.new(3, 3, 'E', 'MMRMMRMRRM')
		r2.run_commands
		expect(r2.result).to eq '5 1 E'
	end

	it "should return no errors" do
		r = Rover.new(1, 2, 'N', 'LMLMLMLMM')
		r.run_commands
		expect(r.errors.empty?).to eq true
	end

	context "when invalid command provided" do
		it "skips invalid command, continues the rest" do
			r = Rover.new(1, 2, 'N', 'LMLMqLMLMM')
			r.run_commands
			expect(r.result).to eq '1 3 N'
		end
		it "returns error" do
			r = Rover.new(1, 2, 'N', 'LMLMqLMLMM')
			r.run_commands
			expect(r.errors).to eq ["Invalid command: q"]
		end
	end

	context "when cmd given to go out of bounds" do
		it "returns point it went out of bounds" do
			r = Rover.new(3, 1, 'S', 'MMMM')
			r.run_commands
			expect(r.result).to eq '3 0 S'
		end
		it "returns error" do
			r = Rover.new(3, 1, 'S', 'MMMM')
			r.run_commands
			expect(r.errors).to eq ["Out of bounds"]
		end
	end

	context "when initialized w invalid direction" do
		it "returns no results" do
			r = Rover.new(3, 1, 'Q', 'MMMM')
			r.run_commands
			expect(r.result).to eq nil
		end
		it "returns error at initialization" do
			r = Rover.new(3, 1, 'Q', 'MMMM')
			expect(r.errors).to eq ["Invalid direction: Q"]
		end
	end
end
