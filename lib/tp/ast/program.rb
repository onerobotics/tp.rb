module TP
  module AST
    class Program
      attr_reader :name
      def initialize(name, attr, appl, lines, pos)
        @name  = name
        @attr  = attr
        @appl  = appl
        @lines = lines
        @pos   = pos
      end
    end
  end
end
