class Package < ActiveRecord::Base
  # Validations
  validates :name,
    length: {
      in: 2..25,
      message: "must be between 2 and 25 characters (package)"
    },
    presence: true
  validates :pin_number,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 4
    },
      presence: true
  validates :shape,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 1
    },
    presence: true

  # Associations
  has_many :chips,
    dependent: :destroy
end
