# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  access_token    :string
#  address         :string
#  age             :string
#  deleted_at      :datetime
#  email           :string
#  name            :string
#  password_digest :string
#  phone_number    :string
#  reset_digest    :string
#  reset_sent_at   :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  strip_attributes
  has_paper_trail
  acts_as_paranoid
  has_secure_password
end
