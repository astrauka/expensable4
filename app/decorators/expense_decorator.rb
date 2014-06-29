class ExpenseDecorator < ApplicationDecorator
  def created_at
    l object.created_at, format: :date
  end
end
