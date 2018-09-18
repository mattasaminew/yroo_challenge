require_relative '../lib/mission'

describe Mission do

	it "should set max x, y" do
		m = Mission.new('input/1.txt')
		expect(m.max_x).to eq 5
		expect(m.max_y).to eq 5
	end

	it "should set rovers" do
		m = Mission.new('input/1.txt')
		expect(m.rovers.length).to eq 2
	end

	it "should be completed after calling #run_mission" do
		m = Mission.new('input/1.txt')
		expect(m.completed).to eq false
		m.run_mission
		expect(m.completed).to eq true
	end

	it "should set result" do
		m = Mission.new('input/1.txt')
		m.run_mission
		expect(m.result).to eq ['1 3 N', '5 1 E']
	end

	it "should return no errors" do
		m = Mission.new('input/1.txt')
		m.run_mission
		expect(m.errors.empty?).to eq true
	end

	context "when a rover initialized out of bounds" do
		it "skips the rovers" do
			m = Mission.new('input/1a.txt') # same as 1.txt w 1 extra rover initialized out of bounds
			expect(m.rovers.length).to eq 2
		end
	end

	context "when a rover doesn't have cmd" do
		it "skips the rovers" do
			m = Mission.new('input/1b.txt') # same as 1.txt w 1 extra rover no cmd
			expect(m.rovers.length).to eq 2
		end
	end

	context "when rover has error" do
		it "returns error at index of rover" do
			m = Mission.new('input/1c.txt') # same as 1.txt w 1 extra rover cmd out of bounds
			m.run_mission
			expect(m.result).to eq ['1 3 N', '5 1 E', '3 0 S']
			expect(m.errors.empty?).to eq false
			expect(m.errors[0]).to eq nil
			expect(m.errors[1]).to eq nil
			expect(m.errors[2]).to eq ["Out of bounds"]
		end
	end
end
