# File: formatting-service.rb
# Purpose: Implementation of the FormattingService class.

require_relative 'exceptions'
require_relative 'coll-walker-factory'
require_relative './formatter/all-notifications'


module Macros4Cuke # Module used as a namespace
# A worker class that drives the rendering of macro-steps in
# any registered format.
class FormattingService
  # The list of registered formatters
  attr_reader(:formatters)

  # Link to a factory of walker objects that visit macro collections
  attr_reader(:walker_factory)


  # Constructor.
  def initialize()
    @formatters = []
    @walker_factory = CollWalkerFactory.new
  end


  # Register a formatter.
  # Raises an exception when the formatter implements
  # an unknown formatting event.
  def register(aFormatter)
    # Get the list of formatted events supported by the formatter
    supported_events = aFormatter.implements

    # Complain if list is empty or nil
    if supported_events.nil? ||  supported_events.empty?
      fail(NoFormattingEventForFormatter.new(aFormatter))
    end

    # Check that each event from the event list the formatter is known.
    supported_events.each do |event|
      next if Formatter::AllNotifications.include? event
      
      fail(UnknownFormattingEvent.new(aFormatter, event))
    end

    formatters << aFormatter
  end

  # Launch the rendering(s) of the given macro collection.
  def start!(aMacroCollection)
    # Create a walker (that will visit the collection)
    walker = walker_factory.build_walker(aMacroCollection)

    walker.each do |visit_event|
      (msg, nesting_level) = visit_event[0..1]

      # Notify each formatter of the visit event.
      formatters.each do |fmt|
        accepted_notifications = fmt.implements
        next unless accepted_notifications.include? msg
        
        # Assumption: all nil argument(s) are at the end
        arg_vector = visit_event[2..-1].reject(&:nil?)
        fmt.send(msg, nesting_level, *arg_vector)
      end
    end
  end
end # class
end # module

# End of file
