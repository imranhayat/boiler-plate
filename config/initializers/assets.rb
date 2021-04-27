# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w(

  application-991.scss application-992.scss application-767.scss application-768.scss application-575.scss application-576.scss 

  signed_in.scss signed_in-991.scss signed_in-992.scss signed_in-767.scss signed_in-768.scss signed_in-575.scss signed_in-576.scss signed_in.js

  dashboard.scss dashboard-992.scss dashboard-767.scss dashboard.js

  datatables.scss datatables.js swal.scss swal.js 
)