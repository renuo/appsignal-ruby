# frozen_string_literal: true

module Appsignal
  # @api private
  module Rack
    # Alias constants that have moved with a warning message that points to the
    # place to update the reference.
    def self.const_missing(name)
      case name
      when :GenericInstrumentation
        require "appsignal/rack/generic_instrumentation"

        callers = caller
        Appsignal::Utils::StdoutAndLoggerMessage.warning \
          "The constant Appsignal::Rack::GenericInstrumentation has been deprecated. " \
            "Please use the new Appsignal::Rack::InstrumentationMiddleware middleware. " \
            "This new middleware does not default the action name to 'unknown'. " \
            "Set the action name for the endpoint using the Appsignal.set_action helper. " \
            "Read our Rack docs for more information " \
            "https://docs.appsignal.com/ruby/integrations/rack.html " \
            "Update the constant name to " \
            "Appsignal::Rack::InstrumentationMiddleware in the following file to " \
            "remove this message.\n#{callers.first}"
        # Return the alias so it can't ever get stuck in a recursive loop
        Appsignal::Rack::GenericInstrumentationAlias
      else
        super
      end
    end
  end
end