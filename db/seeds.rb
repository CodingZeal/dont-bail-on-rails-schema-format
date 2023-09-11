foo = User.find_or_initialize_by(email: 'foo@example.com')
foo.update!(name: 'FOO', super_secret: 'secret-foo')

bar = User.find_or_initialize_by(email: 'bar@example.com')
bar.update!(name: 'BAR', super_secret: 'secret-bar')

baz = User.find_or_initialize_by(email: 'baz@example.com')
baz.update!(name: 'BAZ', super_secret: 'secret-baz')

puts "User Count: #{User.count}"
