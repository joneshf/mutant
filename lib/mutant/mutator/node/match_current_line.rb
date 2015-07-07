module Mutant
  class Mutator
    class Node
      # Emitter for perl style match current line node
      class MatchCurrentLine < self

        handle :match_current_line

        children :regexp

      private

        # Emit mutants
        #
        # @return [undefined]
        #
        # @api private
        def dispatch
          emit_singletons
          emit_regexp_mutations
        end

      end # MatchCurrentLine
    end # Node
  end # Mutator
end # Mutant
