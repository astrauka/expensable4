# encoding : utf-8

MoneyRails.configure do |config|
  config.default_currency = :eur
  config.include_validations = true

  # Default ActiveRecord migration configuration values for columns:
  config.amount_column = { prefix: '',           # column name prefix
                           postfix: '_cents',    # column name  postfix
                           column_name: nil,     # full column name (overrides prefix, postfix and accessor name)
                           type: :integer,       # column type
                           present: true,        # column will be created
                           null: false,          # other options will be treated as column options
                           default: 0
                         }

  config.currency_column = { prefix: '',
                             postfix: '_currency',
                             column_name: nil,
                             type: :string,
                             present: false,
                             null: false,
                             default: 'EUR'
                           }
end
