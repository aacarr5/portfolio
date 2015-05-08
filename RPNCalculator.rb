## This is your standard Reverse Polish calculator. Feel free to check out more info 
## here -> http://en.wikipedia.org/wiki/Reverse_Polish_notation
## Hoping to add functionality that prevents too many numbers being added as well as calling
## value and pushing afterwards.

class RPNCalculator
  attr_reader :array

      def initialize
        @array = Array.new
        @flag = false
      end

      def evaluate(string)
        @array = tokens(string)
        value
      end

      def tokens(string)
          string.split.map!{|x| x == "*" ||x == "/" ||x == "-" ||x == "+" ? x.to_sym : x.to_i * 1.0}
      end

      def push(number)
        @array.push(number*1.0)
      end

      def plus
        @array.push(:+)
        raise_error
      end

      def minus
        @array.push(:-)
        raise_error
      end

      def times
        @array.push(:*)
        raise_error
      end

      def divide
        @array.push(:/)
        raise_error
      end

      def raise_error
        if @array.count{|x| x.class == Float} == 0
          raise "calculator is empty"
        end

        if (@array.count{|x| x.class == Symbol}) >= (@array.count{|x| x.class == Float})
          raise "too many operators"
        end

        # if (@array.count{|x| x.class == Symbol}) < (@array.count{|x| x.class == Float}) 
        #   raise "too many numbers"
        # end

      end

      # def value_opt
      #   @flag == false ? : @array.unshift(stack.shift(2))
      # end
      
      def value

        stack = Array.new

        tester = @array.clone
        
        tester.each {|item|
        
        if item.class == Float
            stack.unshift(@array.shift)
        end
        
        if item == :+
            @array.shift
            stack.unshift(stack.shift(2).inject(:+))
        end
        
        if item == :-
            @array.shift

            set = stack.shift(2)
            add = set[1]-set[0]

            stack.unshift(add)
        end
        
        if item == :*
            @array.shift
            stack.unshift(stack.shift(2).inject(:*))
        end
        
        if item == :/
            @array.shift

            set = stack.shift(2)
            add = set[1] / set[0]
            
            stack.unshift(add)
        end         
        } #=>each_with_index 
        @flag = true
        stack[0] #this return should always preceed method end
      end #==> end of value method


end ## <= end of class


