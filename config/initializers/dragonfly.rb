require 'dragonfly'
app = Dragonfly[:images]

app.configure_with(:imagemagick)
app.configure_with(:rails)

app.define_macro(ActiveRecord::Base, :image_accessor)
app.define_macro(ActiveRecord::Base, :file_accessor)

app.configure do |c|
  c.protect_from_dos_attacks = true
  c.secret = 'dfd123ghjhjkiouom34ojoijwe98dfngovsm58lty58sgg32543vt442kjf5h2k3jvlni3485c834yl85nv23485ni34nxpop24m'
  if Rails.env.production?
    c.datastore = Dragonfly::DataStorage::S3DataStore.new(
      :bucket_name => ENV['S3_BUCKET'],
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    )
  end
end