class Post < ActiveRecord::Base
  belongs_to :user
  attr_accessible :id, :content, :name, :user_id, :created_at, :updated_at
  after_save    :expire_post_all_cache
  after_destroy :expire_post_all_cache
  
  def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << column_names
        all.each do |post|
          csv << post.attributes.values_at(*column_names)
        end
      end
    end
  
  def self.all_cached
    Rails.cache.fetch('Post.all') { all }
  end

  def expire_post_all_cache
    Rails.cache.delete('Post.all')
  end
end
