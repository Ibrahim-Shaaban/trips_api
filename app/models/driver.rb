class Driver < ApplicationRecord
    has_secure_password
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, length: { minimum: 6 }
  
    has_many :assignments, dependent: :destroy
    has_many :trucks, through: :assignments
  
  
    def self.create_new_one(name, email, password)
      new(
        name: name,
        email: email.downcase,
        password: password
      )
    end
  
    def self.handle_login(email,password)
      unless email.present? || password.present?
        raise "Invalid credentials"
      end
      driver = find_by(email: email.downcase)
      unless driver.present?
        raise "Invalid credentials"
      end
  
      unless driver.authenticate(password).present?
        raise "Invalid credentials"
      end
  
      # generate token
      expires_at = Time.zone.now + 4.days
      token =JsonWebToken.encode({id: driver.id}, expires_at)
      {token: token, expires_at: expires_at}
    end
  
    
  end
  