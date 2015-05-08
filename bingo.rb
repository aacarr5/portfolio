### README###
# The BingoBoard class initializes only needing the player's name for which it creates a unique rule conforming board.
# Only one method may be called upon an instance (start), which is a loop that runs until a match is found. The other 
# method is the class method #stats, which outputs the winner's name, tries, and how they won. Vertical, 
# horizontal, and diagonal matches are the only ways to qualify as a win. Any more and that's just desparate. 

class BingoBoard

  @@b_numbers =[*1..15]
  @@i_numbers =[*16..30]
  @@n_numbers =[*31..45]
  @@g_numbers =[*46..60]
  @@o_numbers =[*61..75]

  @@winners = Hash.new

  @@number = [*1..75].shuffle!

  attr_reader :name, :counter

  def initialize(name)
    # This allows for really weird 'names' like @#$$$#@ or '         ' or 'L()L!T@'
    # Chill if that's what you're going for, but it might be easier to match what IS
    # a valid name (like /[AZ-az]+/ or something like that) rather than matching what
    # isn't valid
    raise ArgumentError.new("Please enter valid name") if name =~/[0-9]/ || name.class != String
    @bingo_board = board.transpose
    @solved = false
    @counter = 1
    @name = name
  end

  def start #Loop to attempt to solve. 
    while @solved == false
      draw
    end
    @@winners[@name] = [@counter,solved?]
  end

  def BingoBoard.stats
    puts "There were #{@@winners.keys.count} player(s) in this game."
    puts "The winner was #{@@winners.sort_by{|name, score| score}[0][0]}, winning after #{@@winners.sort_by{|name, score| score}[0][1][0]} tries with a #{@@winners.sort_by{|name, score| score}[0][1][1]}"
  end

private

  def board # This creates board. 
    r1 = @@b_numbers.shuffle.first(5)
    r2 = @@i_numbers.shuffle.first(5)
    r3 = @@n_numbers.shuffle.first(5)
    r4 = @@g_numbers.shuffle.first(5)
    r5 = @@o_numbers.shuffle.first(5)
    r3[2] = "X"
    Array.new.push(r1,r2,r3,r4,r5)
  end

  def show #...
    @bingo_board.each{|row| p row}
    puts
  end

  def draw # Draws according to the counter's index on the @@number array, ensuring player gets the same random order
    ticket = @@number[@counter]
    p caller(ticket)
    replace(ticket)
  end

  def caller(number)
    return case number
      when 1..15 then "B #{number} was called!"
      when 16..30 then "I #{number} was called!"
      when 31..45 then "N #{number} was called!"
      when 46..60 then "G #{number} was called!"
      when 61..75 then "O #{number} was called!"
    end     
  end

  def replace(number) # This method appropriately switches numbers for X's, increases @counter, and checks if solved.
    @bingo_board.each do |row|
      row.map! do |element|
        element == number ? element = "X" : element
      end
    end
    @counter+=1
    # show
    solved?
  end

    def solved? ## This method will change the @solved variable if match is found, and return the type of match.
      answer = ""

      @bingo_board.each do |row|
        if row.uniq.length == 1
          answer = "Horizontal Win!"
          @solved = true
        end
      end

      @bingo_board.transpose.each do |row|
        if row.uniq.length == 1
          answer = "Vertical Win!"
          @solved = true
        end
      end

      if ( #is there a better way to write this?
        # Maybe like this? Extracts the diagonal elements and checks to see if they are all "X"s
        # Relies on the fact that if you have a diagonal going from bottom left to top right
        # You can transpose and reverse to convert it to a diagonal going from top left to bottom right
        (0..@bingo_board.length()-1).collect{|i|@bingo_board[i][i]}.map{|e|e=="X"}.reduce(:&) ||
        (0..@bingo_board.length()-1).collect{|i|@bingo_board.transpose().reverse()[i][i]}.map{|e|e=="X"}.reduce(:&))
            answer = "Diagonal Win!"
            @solved = true
        end
        answer
    end

end

a = BingoBoard.new("Andrew")

b = BingoBoard.new("Bob")

c = BingoBoard.new("Cathy")

a.start

b.start

c.start

BingoBoard.stats






