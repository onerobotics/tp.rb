module TP
  module AST
    class SelectStmt
      def initialize(numreg, value, action)
        @numreg = numreg
        @value = value
        @action = action
      end
    end
  end
end
