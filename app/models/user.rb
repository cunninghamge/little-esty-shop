class User < ApplicationRecord
  has_secure_password
  validates :username, uniqueness: true, presence: true
  validates_presence_of :password, require: true

  belongs_to :merchant, optional: true
  belongs_to :customer, optional: true
  enum role: %w(customer merchant admin)
end
