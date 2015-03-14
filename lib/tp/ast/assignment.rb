module TP
  module AST
    class Assignment
      def initialize(operand, value)
        @operand = operand
        @value = value
      end
    end
  end
end
