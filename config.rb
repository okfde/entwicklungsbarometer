set :protocol, "http://"
set :host, "okfde.github.io/entwicklungsbarometer"
set :port, 80
###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
  set :host, Middleman::PreviewServer.host
  set :port, Middleman::PreviewServer.port
end

# Methods defined in the helpers block are available in templates
helpers do
  def host_with_port
    [host, optional_port].compact.join(':')
  end

  def optional_port
    port unless port.to_i == 80
  end

  def iframe_embed(path, width=600, height=300)
    "<iframe src='#{protocol + host_with_port + path}' width='#{width}' height='#{height}'></iframe>"
  end
end

data.experten.each do |experte|
  proxy "/experten/#{experte.slug}.html", "/experten/experte.html", locals: { experte: experte }, ignore: true
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

ready do
  sprockets.append_path File.join root, 'bower_components'
end

# Build-specific configuration
configure :build do
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
end
activate :deploy do |deploy|
  deploy.build_before = true # default: false
  deploy.method = :git
end
activate :relative_assets
set :relative_links, true
activate :directory_indexes
