[User].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE #{table.table_name} RESTART IDENTITY CASCADE")
end
Role.create([{ name: :admin }, { name: :normal }])
User.create([{ name: 'Admin', email: 'admin@test.com', password: 'admin123', role_ids: '1' }, {name: 'Saqib', email: 'user@test.com', password: 'admin123', role_ids: '2' } ])