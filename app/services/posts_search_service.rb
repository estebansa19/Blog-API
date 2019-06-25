class PostsSearchService
  def self.search(current_posts, query)
    post_ids = Rails.cache.fetch("posts_search/#{query}", expires_in: 1.hours) do
      current_posts.where("title LIKE '%#{query}%'").map(&:id)
    end

    current_posts.where(id: post_ids)
  end
end