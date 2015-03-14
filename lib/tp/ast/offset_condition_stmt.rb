module TP
  module AST
    class OffsetConditionStmt
      def initialize(type, condition)
        @type = type
        @condition = condition
      end
    end
  end
end
