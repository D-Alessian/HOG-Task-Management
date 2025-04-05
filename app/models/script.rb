class Script < ApplicationRecord
  belongs_to :user, optional: true
end
