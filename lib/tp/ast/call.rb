module TP
  module AST
    class Call
      def initialize(program_name, arguments=[])
        @program_name = program_name
        @arguments = arguments
      end
    end
  end
end
