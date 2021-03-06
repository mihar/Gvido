Factory.define :agreement do |f|
  f.text "Js se strinjam"
end

Factory.define :payment do |f|
  f.association :enrollment
end

Factory.define :monthly_lesson do |f|
  f.association :student
  f.association :mentor
end

Factory.define :invoice do |f|
  f.association :student
end

Factory.define :about do |f|
  f.text     "Thats what its all *about*"
  f.contact  "Mikake mikakhil 0316655332"
end

Factory.define :enrollment do |f|
  f.association :mentor
  f.association :instrument
  f.association :student
  f.enrollment_date Date.new(2011, 9, 1)
  f.cancel_date Date.new(2012, 6, 1)
  f.total_price BigDecimal('1000')
  f.price_per_lesson 0.0
  f.prepayment 0.0
  f.nr_of_lessons 35
  f.discount 0.0
  f.enrollment_fee 0.0
end

Factory.define :payment_period do |f|
  f.association :enrollment
  f.payment_plan_id :monthly
  f.start_date Date.new(2011, 9, 1)
  f.end_date Date.new(2012, 6, 1)
  f.discount 0.0
end

Factory.define :enrollment_with_price_per_lesson, :parent => :enrollment do |f|
  f.price_per_lesson 25.0
end

Factory.define :prepayed_enrollment_with_price_per_lesson, :parent => :enrollment_with_price_per_lesson do |f|
  f.prepayment BigDecimal('45.0')
end

Factory.define :person do |f|
  f.first_name 'Mikakhil'
  f.last_name  'Mekakil'
end

Factory.define :student do |f|
  f.first_name 'Mikakhil'
  f.last_name  'Mekakil'
  f.address "Jenkova 56"
  f.place "Velenje"
  f.association :status
  f.association :post_office
end

Factory.define :personal_contact do |f|
  f.first_name 'Grenpa'
  f.last_name  'Mekakil'
  f.association :student
end

Factory.define :parent, :parent => :personal_contact do |f|
  f.first_name 'Tata'
end

Factory.define :album_category do |f|
  f.title "Johanesberen"
end

Factory.define :album do |f|
  f.title "johanesbere"
  f.association :album_category
end

Factory.define :instrument do |f|
  f.title 'Habala babala'
end

Factory.define :location do |f|
  f.title 'Hungala famfarabis'
  f.association :location_section
end

Factory.define :location_section do |f|
  f.title 'Dungala bungala hungala'
end

Factory.define :contact do |f|
  f.name 'Josko Simac'
  f.email 'josko@fmail.com'
  f.after_build { |contact| contact.instruments << Factory(:instrument) }
  f.after_build { |contact| contact.locations << Factory(:location) }
end

Factory.define :gig do |f|
  f.title 'Kreslinov koncert'
  f.venue 'Ljubljana, cankarjev dom'
  f.when 	Time.now
end

Factory.define :link do |f|
  f.title 'The pejidz'
  f.uri 'pejidz.com'
  f.association :category, :factory => :link_category
end
  
Factory.define :mentor do |f|
  f.name "Mentorij"
  f.surname "Mentis"
  f.sequence(:email) { |n| "lolo#{n}@tralala.si" }
  f.association :user
  f.after_build { |mentor| mentor.instruments << Factory(:instrument) }
  f.price_per_private_lesson 25.0
  f.public_lesson_coefficient 1.5
end

Factory.define :movie do |f|
  f.title 'jutub'
  f.youtube 'http://www.youtube.com/watch?v=KmukuBm7Rjs'
end


Factory.define :link_category do |f|
  f.title 'Semenicenje'
end
  
Factory.define :notice do |f|
  f.title 'Special notice'
  f.body 'Tijelo iz neba'
end

Factory.define :personal_relation do |f|
  f.association :person
  f.association :related_person, :factory => :person
end

Factory.define :photo do |f|
  f.photo_file_name 'fajl.jpg'
  f.association :album
end

Factory.define :post do |f|
  f.title 'Naziv tega posta'
  f.text 'O post, ti ki si na strani'
end

Factory.define :question do |f|
  f.question 'kaj?'
  f.answer 'ne ti men kaj.'
end

Factory.define :reference do |f|
  f.title 'ref'
end

Factory.define :schedule do |f|
  f.title 'Getting real'
  f.file_file_name 'aye.pdf'
end

Factory.define :shop_advice do |f|
  f.association :instrument
end

Factory.define :post_office do |f|
  f.id 3320
  f.name "Velenje"
end

Factory.define :user do |f|
  f.first_name "Admin"
  f.last_name "Krmetic"
  f.sequence(:email) { |n| "lolo#{n}@tralala.si" }
  f.password "SimonTalek"
  f.password_confirmation "SimonTalek"
end

Factory.define :billing_option do |f|
  f.description 'Kes na roko preko mentorja na zadnjem predavanju v mescu.'
  f.short_description 'Kes na roko'
end

Factory.define :status do |f|
  f.description 'Oseba je aktiven ucenec, ki rad zapoje kako domaco.'
  f.short_description 'Aktiven'
end
