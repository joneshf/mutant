module Mutant
  # Abstract base class for reporters
  class Reporter
    include AbstractType

    # Write warning message
    #
    # @param [String] message
    #
    # @return [self]
    #
    # @api private
    #
    abstract_method :warn

    # Report collector state
    #
    # @param [Runner::Collector] collector
    #
    # @return [self]
    #
    # @api private
    #
    abstract_method :report

    # Report progress on object
    #
    # @param [Object] object
    #
    # @return [self]
    #
    # @api private
    #
    abstract_method :progress

  end # Reporter
end # Mutant
