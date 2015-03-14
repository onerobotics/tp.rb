module TP
  module AST
    class Label
      def initialize(id_hash)
        @id = id_hash[:id]
        @comment = id_hash[:comment]
      end
    end
  end
end
