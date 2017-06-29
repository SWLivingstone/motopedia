class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_save { self.account = :standard if self.account.nil?}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
        #  :confirmable

  has_many :wikis
  has_many :collaborators

  enum account: [:admin, :standard, :premium]
end
