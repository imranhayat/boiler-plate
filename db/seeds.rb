[User].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE #{table.table_name} RESTART IDENTITY CASCADE")
end
User.create(name: 'Saqib', email: "user@test.com", password: "admin123")
User.create(name: 'Admin', email: "admin@test.com", password: "admin123", admin: true)