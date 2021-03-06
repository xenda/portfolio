class CreatePortfolioStructure < ActiveRecord::Migration
  def self.up
	  create_table :images_portfolio_entries, :id => false, :force => true do |t|
	    t.integer :image_id
	    t.integer :portfolio_entry_id
	  end

    # people should be allowed to have the same image twice, if they really want to.
	  #add_index :images_portfolio_entries, [:image_id, :portfolio_entry_id], :name => :composite_key_index, :unique => true

	  create_table :portfolio_entries, :force => true do |t|
	    t.string   :title
	    t.text     :body
	    t.integer  :position
	    t.integer  :parent_id
	    t.datetime :created_at
	    t.datetime :updated_at
	  end
	
		User.find(:all).each do |user|
			user.plugins.create(:title => "Portfolio", :position => (user.plugins.maximum(:position) || -1) +1)
		end
		
		page = Page.create(:title => "Portfolio", :link_url => "/portfolio", :deletable => false, :position => ((Page.maximum(:position, :conditions => "parent_id IS NULL") || -1)+1))
		RefinerySetting.find_or_set(:default_page_parts, ["body", "side_body"]).each do |default_page_part|
			page.parts.create(:title => default_page_part, :body => nil)
		end
		
		RefinerySetting[:image_thumbnails] = RefinerySetting.find_or_set(:image_thumbnails, {}).merge!({:portfolio_thumb => 'c96x96', :portfolio => '600x512'})
  end

  def self.down
		UserPlugin.destroy_all({:title => "Portfolio"})
		
		Page.find_all_by_link_url("/portfolio").each do |page|
			page.link_url, page.menu_match, page.deletable = nil
			page.destroy
		end
		Page.destroy_all({:link_url => "/portfolio"})
	
		RefinerySetting.find_or_set(:image_thumbnails, {}).delete_if {|key, value| key == :portfolio_thumb or key == :portfolio }
	
		drop_table :images_portfolio_entries
		drop_table :portfolio_entries
  end
end
