require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.
  
  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    Customer.where(first: "Candice")
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    Customer.where("email LIKE ?", "%@%")
  end
  # etc. - see README.md for more details

  def self.with_dot_org_email
    Customer.where("email LIKE ?", "%.org")
  end

  def self.with_invalid_email
    Customer.where.not("email LIKE ?", "%@%")
  end

  def self.with_blank_email
    Customer.where(email: nil)
  end

  def self.born_before_1980
    Customer.where(birthdate: DateTime.new(0, 1, 1)...DateTime.new(1980, 1, 1))
  end

  def self.with_valid_email_and_born_before_1980
    Customer.where("email LIKE ?", "%@%").where(birthdate: DateTime.new(0, 1, 1)...DateTime.new(1980, 1, 1))
  end

  def self.last_names_starting_with_b
    Customer.where("last LIKE ?", "b%").order(:birthdate)
  end

  def self.twenty_youngest
    Customer.order(birthdate: :desc).limit(20)
  end

  def self.update_gussie_murray_birthdate
    customer = Customer.find_by(:first => 'Gussie')
    customer.update(birthdate: DateTime.new(2004, 2, 8))
  end

  def self.change_all_invalid_emails_to_blank
    Customer.where.not("email LIKE ?", "%@%").update_all(email: nil)
  end

  def self.delete_meggie_herman
    Customer.delete_by(:first => 'Meggie', :last => 'Herman')
  end

  def self.delete_everyone_born_before_1978
    Customer.delete_by('birthdate < ?', Time.parse("1 January 1978"))
  end

end
