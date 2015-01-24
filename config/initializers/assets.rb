# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.precompile += %w( movies.js )
Rails.application.config.assets.precompile += %w( index.js )
Rails.application.config.assets.precompile += %w( spots_new.js )
Rails.application.config.assets.precompile += %w( spots_show.js )
Rails.application.config.assets.precompile += %w( spots_index.js )
Rails.application.config.assets.precompile += %w( external_users_new.js )
Rails.application.config.assets.precompile += %w( tag_along_add.js )
Rails.application.config.assets.precompile += %w( tag_along_index.js )
Rails.application.config.assets.precompile += %w( notifications.js )
Rails.application.config.assets.precompile += %w( tvshows.js )

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
