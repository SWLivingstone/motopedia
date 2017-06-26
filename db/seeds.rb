# Create users
5.times do
  User.create!(
    email: "#{RandomData.random_word}@#{RandomData.random_word}.com",
    password: "password"
  )
end

# Create wikis
20.times do
  Wiki.create!(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph,
    user_id: User.all.sample.id,
    private: false,
    category: 'adventure',
    final_drive: 'chain',
    hp: 100,
    torque: 50,
    cylinders: 2,
    year: 2010,
    displacement: 650,
    manufacture: 'Honda'
    )
end

User.create!(
  email: 'standard@motopedia.wiki',
  password: 'password'
)

User.create!(
  email: 'premium@motopedia.wiki',
  password: 'password',
  account: 'premium'
)

User.create!(
  email: 'admin@motopedia.wiki',
  password: 'password',
  account: 'admin'
)

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
