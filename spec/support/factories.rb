Factory.define :about do |f|
  f.text     "Thats what its all *about*"
  f.contact  "Mikake mikakhil 0316655332"
end

Factory.define :person do |f|
  f.first_name 'Mikakhil'
  f.last_name  'Mekakil'
end

Factory.define :student, :class => 'person' do |f|
  f.first_name 'Mikakhil'
  f.last_name  'Mekakil'
  f.student     true
end

Factory.define :parent, :class => 'person' do |f|
  f.first_name 'Tata'
  f.last_name  'Mekakil'
  f.student     false
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
  f.name 'Mentor'
  f.surname 'Joza'
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

