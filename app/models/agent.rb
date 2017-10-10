class Agent < ActiveRecord::Base
    has_many :ships
    has_secure_password
end