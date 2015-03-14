module TP
  module AST
    class WaitStmt
      def initialize(x, timeout)
        @x = x
        @timeout = timeout
      end
    end
  end
end
