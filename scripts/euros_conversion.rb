Share.update_all("single_price_cents = single_price_cents * 0.2896")
Expense.update_all("spent_cents = spent_cents * 0.2896")
UserGroupRelationship.update_all("balance_cents = balance_cents * 0.2896")
User.pluck(:email).each { |email| UserMailer.euros(email).deliver_now! }
