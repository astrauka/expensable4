module Expensable
  DEFAULT_PARAMS = {
    allow_simulate_invite: false,
  }

  class << self
    attr_accessor :configuration

    # Allows default params to be accessed on module directly to prevent chaining
    delegate(*(DEFAULT_PARAMS.keys << { to: :configuration }))

    def configure
      self.configuration ||= OpenStruct.new(DEFAULT_PARAMS)
      yield(configuration)
    end
  end
end
