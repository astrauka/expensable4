class UserMailer < ActionMailer::Base
  def group_invite(current_user, group, invited_user)
    @current_user = current_user
    @group = group
    @invited_user = invited_user

    mail to: invited_user.email,
         subject: "Expensable: #{current_user} invited you to join #{group} group"
  end

  def expense_notification(current_user, expense, updating = false)
    @current_user = current_user
    @expense = expense
    @group = expense.group

    emails = (expense.participating_users - [current_user]).map(&:email)
    subject =
      if updating
        "Expensable: #{current_user} has updated an expense"
      else
        "Expensable: #{current_user} has shared an expense with you"
      end

    mail to: emails,
         subject: subject
  end

  def euros(user_email)
    mail to: user_email,
         subject: "Expensable: Litas converted to Euros"
  end
end
