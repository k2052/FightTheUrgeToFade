$:.unshift File.dirname(__FILE__) + '/lib'

require 'redcarpet'
require 'slim'
require 'markdown_ext_renderer'
compass_config do |config|
  config.output_style = :compressed
end

set :css_dir,         'css'
set :js_dir,          'js'
set :images_dir,      'images'
set :slim,            :pretty => true
set :layout,          :main
set :markdown_engine, :redcarpet
set :markdown,        :renderer => MarkdownExtRenderer, :with_toc_data => true

# Build-specific configuration
configure :build do
  activate :cache_buster
  activate :relative_assets
end
