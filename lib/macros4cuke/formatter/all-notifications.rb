# File: all_notifications.rb

module Macros4Cuke # Module used as a namespace
  # Namespace for all formatters of MacroCollection and MacroStep objects
  module Formatter
    # The list of all formatting notifications
    AllNotifications = [
      :on_collection,
      :on_collection_end,
      :on_step,
      :on_step_end,
      :on_phrase,
      :on_renderer,
      :on_renderer_end,
      :on_source,
      :on_static_text,
      :on_eol,
      :on_comment,
      :on_placeholder,
      :on_section,
      :on_section_end
    ]
  end # module
end # module

# End of file
