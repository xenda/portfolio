Refinery::Plugin.register do |plugin|
	plugin.directory = directory
	plugin.title = "Portfolio"
	plugin.description = "Manage a portfolio"
	plugin.url = "/admin/#{plugin.title.downcase}"
	plugin.version = '0.9.1.8'
	plugin.menu_match = /admin\/((portfolio)|(portfolio_entries))/
	plugin.activity = {
		:class => PortfolioEntry,
		:title => 'title',
		:url_prefix => 'edit',
		:created_image => "layout_add.png",
		:updated_image => "layout_edit.png"
	}
end