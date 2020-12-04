class Meter < ApplicationRecord
  belongs_to :operator
  belongs_to :company

  has_many :readings
end
