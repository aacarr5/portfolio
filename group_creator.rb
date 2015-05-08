### README ###
# This file attempts to create a way for you to create groups from a standard list. 
# It initializes with a list of names and your ideal size for each group. 
# Once a group is created, you are allowed to either add or delete. 


class Groups
	# binding.pry
	attr_reader :names, :max, :final

	@@classes = Array.new

	def initialize(names, max=4)
		@names = names
		@max = max
		@final = groupify
	end

private
	def groupify

		final = Hash.new

		answer = @names.shuffle!.each{|item| item.capitalize!}.each_slice(@max).to_a

		if answer.last.count < max - 1 
			selector = [*1..answer.length-2].shuffle!
			answer.pop.each {|word| answer[selector.shift.to_i] << word}
		end

		answer.each_with_index {|item, index| final["Group #{index+1}"] = item}

		@@classes << final
		final
	end

public

	def remove_student(student)
		if @names.include? student.capitalize! 
			@final.each {|groups,names| names.select! {|name| name !=student}}
		else
			raise ArgumentError.new("Hmm. It appears that student is not in the class")
		end
	end

	def add_student(student)
		preferred_groups = @final.select{|group,number| number.count < max + 1}.keys
		preferred_numbers = preferred_groups.map{|item| item.scan(/\d+/)}.flatten.map{|item| item.to_i}

		puts "To which group would you like #{student} to be added? I would advise #{preferred_groups}."
		choice = gets.scan(/\d+/).join.to_i
		
		if preferred_numbers.include? choice
			@final["Group #{choice}"] << student
		else
			raise ArgumentError.new("Sorry. Have to choose a preferred number")
		end

	end

	def self.show
		@@classes
	end

end 