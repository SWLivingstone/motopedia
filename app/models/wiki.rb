class Wiki < ActiveRecord::Base
  belongs_to :user

  default_scope { order('title')}

  validates :body, presence: true
  validates :title,
    presence: true,
    uniqueness: { case_sensitve: false, scope: [:year]},
    length: { minimum: 3, maximum: 254}

  enum category: [:adventure, :dual_sport, :sport, :naked,
    :touring, :cruiser, :custom, :dirt, :roadster]

  enum final_drive: [:belt, :chain, :shaft]
end
