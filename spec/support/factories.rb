Factory.define :about do |f|
  f.text     "Thats what its all *about*"
  f.contact  "Mikake mikakhil 0316655332"
end

Factory.define :student do |f|
  f.first_name 'Mikakhil'
  f.last_name  'Mekakil'
end

Factory.define :student_contact do |f|
end

Factory.define :album_category do |f|
  f.title "Johanesberen"
end

Factory.define :album do |f|
  f.title "johanesbere"
end

Factory.define :contact do |f|
  f.name 'Josko Simac'
  f.email 'josko@fmail.com'
  f.association :instrument_ids, :factory => :instrument
  f.association :location_ids, :factory => :location
end


Factory.define :instrument do |f|
  f.title 'Habala babala'
end

Factory.define :location do |f|
  f.title 'Hungala bungala'
end

Factory.define :gig do |f|
end

