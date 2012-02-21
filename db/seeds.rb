# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Group.create :name => 'Researcher'
Group.create :name => 'Research Assistant'
Group.create :name => 'Database Admin'
Group.create :name => 'Admin'

# Do not delete 'open' and 'closed' statuses...those are required
Status.create :name => 'Open'
Status.create :name => 'Closed'
Status.create :name => 'Re-opened'
Status.create :name => 'Hold'
Status.create :name => 'Unresolved'

Priority.create :name => 'High'
Priority.create :name => 'Medium'
Priority.create :name => 'Low'

user_attrs = {
  :username => 'manisa',
  :password => 'manisa',
  :password_confirmation => 'manisa',
  :email => 'manisa@hisro.or.th',
  :email_confirmation => 'manisa@hisro.or.th',
  :first_name => 'Manisa',
  :last_name => 'Homsiri',
  :time_zone => 'Bangkok'
}
User.create(user_attrs)

# allow admin to have admin rights
admin = User.find(1)
admin.admin = true
admin.save
