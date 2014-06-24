class ShareWithSharingInput
  attr_reader :share, :sharing

  def initialize(share, sharing)
    @share = share
    @sharing = sharing
  end

  delegate :multiplier, :user_id, :persisted?, to: :share
end
