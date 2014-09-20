activate :react

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :haml, { :ugly => true, :format => :html5 }

# configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
# end

after_configuration do
  sprockets.append_path File.dirname(::React::Source.bundled_path_for('react.js'))
end

# For Private Password
file = File.open("password", "r")
password = file.read
file.close

file = File.open("username", "r")
username = file.read
file.close

activate :deploy do |deploy|
  deploy.build_before = true # default: false
  deploy.method   = :ftp
  deploy.host     = "ftp.andrewstamm.com"
  deploy.path     = "/public_html/hosting/jenkorff"
  deploy.user     = username
  deploy.password = password
end