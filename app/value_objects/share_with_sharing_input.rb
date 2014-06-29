class ShareWithSharingInput
  attr_reader :share, :sharing

  def initialize(share, sharing)
    @share = share
    @sharing = sharing
  end

  delegate :id, :multiplier, :user_id, :user, :persisted?, to: :share
end
