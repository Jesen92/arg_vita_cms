# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css.scss, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( bootstrap.css )
Rails.application.config.assets.precompile += %w( style.css )
Rails.application.config.assets.precompile += %w( simple-sidebar.css )
Rails.application.config.assets.precompile += %w( chosen.css )
Rails.application.config.assets.precompile += %w( bootstrap-chosen.scss )
Rails.application.config.assets.precompile += %w( bootstrap-sprockets.css )
Rails.application.config.assets.precompile += %w( bootstrap-chosen.css )
Rails.application.config.assets.precompile += %w( wice_grid.css )

Rails.application.config.assets.precompile += %w( bootstrap-sprockets.js )
Rails.application.config.assets.precompile += %w( jquery.countdown.js )
Rails.application.config.assets.precompile += %w( bootstrap.min.js )
Rails.application.config.assets.precompile += %w( menu.js )
Rails.application.config.assets.precompile += %w( scaffold.coffee )
Rails.application.config.assets.precompile += %w( gallery_view.js )



