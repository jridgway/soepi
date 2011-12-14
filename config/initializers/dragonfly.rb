require 'dragonfly'
app = Dragonfly[:images]

app.configure_with(:imagemagick)
app.configure_with(:rails)
app.configure_with(:heroku, 'soepi') if Rails.env.production?

app.define_macro(ActiveRecord::Base, :image_accessor)
app.define_macro(ActiveRecord::Base, :file_accessor)

app.configure do |c|
  c.protect_from_dos_attacks = true
  c.secret = 'dfd123ghjhjkiouom34ojoijwe98dfngovsm58lty58sgg32543vt442kjf5h2k3jvlni3485c834yl85nv23485ni34nxpop24m'
end