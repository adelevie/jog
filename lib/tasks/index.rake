task :index_posts => :environment do
  if ENV['SWIFTYPE_API_KEY'].blank?
    abort("SWIFTYPE_API_KEY not set")
  end

  if ENV['SWIFTYPE_ENGINE_SLUG'].blank?
    abort("SWIFTYPE_ENGINE_SLUG not set")
  end

  client = Swiftype::Easy.new

  Post.find_in_batches(:batch_size => 100) do |posts|
    documents = posts.map do |post|
      url = Rails.application.routes.url_helpers.post_url(post)
      {:external_id => post.id,
       :fields => [{:name => 'name', :value => post.name, :type => 'string'},
                   {:name => 'content', :value => post.content, :type => 'text'},
                   {:name => 'url', :value => url, :type => 'enum'},
                   {:name => 'created_at', :value => post.created_at.iso8601, :type => 'date'}]}
    end

    results = client.create_or_update_documents(ENV['SWIFTYPE_ENGINE_SLUG'], Post.model_name.downcase, documents)

    results.each_with_index do |result, index|
      puts "Could not create #{posts[index].name} (##{posts[index].id})" if result == false
    end
  end
end