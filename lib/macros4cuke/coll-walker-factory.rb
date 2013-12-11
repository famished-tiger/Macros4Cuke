# File: coll-walker-factory.rb
# Purpose: Implementation of the CollWalkerFactory class.

require_relative 'macro-collection'


module Macros4Cuke # Module used as a namespace


# A Coll(ection)WalkerFactory object is a factory that creates
# an enumerator that itself walks in the passed macro collection object.
# The walker performs a depth-first visit and yields visit events.
class CollWalkerFactory
  # Structure used internally by the walker
  StringNode = Struct.new(:event, :text, :extra)

  def build_walker(aMacroCollection)
    level = 0
    collection = aMacroCollection
    current_node = collection
    backlog = collection.macro_steps.values

    visitor = Enumerator.new do
      |result_receiver|	# 'result_receiver' is a Yielder
      loop do
        case current_node
        when MacroCollection
          result_receiver << [:on_collection, level, current_node]
          level += 1
          backlog << StringNode.new(:on_collection_end, nil)

        when MacroStep
          result_receiver << emit_on_step(current_node, level, backlog)
          level += 1

        when StringNode
          level -= 1 if current_node.event.to_s =~ /_end$/
          event = [current_node.event, level, current_node.text]
          event << current_node.extra unless current_node.extra.nil?
          result_receiver << event

        when Templating::Engine
          result_receiver << emit_on_renderer(current_node, level, backlog)
          level += 1

        when Templating::StaticText
          result_receiver << [:on_static_text, level, current_node.source]

        when Templating::Comment
          result_receiver << [:on_comment, level, current_node.source]

        when Templating::EOLine
          result_receiver << [:on_eol, level, nil]

        when Templating::Placeholder
          result_receiver << [:on_placeholder, level, current_node.name]

        when Templating::Section
          result_receiver << emit_on_section(current_node, level, backlog)
          level += 1

        else
          err_msg = "Don't know how to format a #{current_node.class}."
          fail(InternalError, err_msg)
        end

        current_node = backlog.shift
        break if current_node.nil?
      end
    end


    return visitor
  end

  private

  # Add children elements to the visit backlog
  def add_children(anEnumerable, theBacklog)
    anEnumerable.reverse.each do |elem|
      theBacklog.unshift(elem)
    end
  end
  
  # Generate an on_step event
  def emit_on_step(current_node, nesting_level, backlog)  
    backlog.unshift(StringNode.new(:on_step_end, nil))
    backlog.unshift(current_node.renderer)
    # Does the step use a table argument?
    use_table = current_node.key =~ /_T$/ ? true : false
    backlog.unshift(StringNode.new(:on_phrase, current_node.phrase, use_table))
    
    return [:on_step, nesting_level, current_node]
  end
  
  # Generate an on_renderer event
  def emit_on_renderer(current_node, nesting_level, backlog)
    backlog.unshift(StringNode.new(:on_renderer_end, nil))
    add_children(current_node.representation, backlog)
    backlog.unshift(StringNode.new(:on_source, current_node.source))
          
    return [:on_renderer, nesting_level, current_node]      
  end
  
  
    # Generate an on_section event
  def emit_on_section(current_node, nesting_level, backlog)
    backlog.unshift(StringNode.new(:on_section_end, nil))
    add_children(current_node.children, backlog)
          
    return [:on_section, nesting_level, current_node.name]     
  end
  



end # class

end # module

# End of file
