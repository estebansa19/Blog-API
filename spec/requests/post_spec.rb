require "rails_helper"

RSpec.describe "Posts", type: :request do

  describe "GET /posts" do
    it "should return ok" do
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end

    describe "Search" do
      let!(:hola_mundo) { create(:post, published: true, title: 'Hola mundo') }
      let!(:hola_rails) { create(:post, published: true, title: 'Hola Rails') }
      let!(:curso_rails) { create(:post, published: true, title: 'Curso Rails') }

      it "should filter posts by title" do
        get "/posts?search=Hola"
        payload = JSON.parse(response.body)
        expect(payload).not_to be_empty
        expect(payload.size).to eq(2)
        expect(payload.map { |post| post["id"] }.sort).to eq([hola_mundo.id, hola_rails.id].sort)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "with data in the DB" do
    let!(:posts) { create_list(:post, 10, published: true) }

    it "should return all the posts published" do
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /posts/{id}" do
    let(:post) { create(:post, published: true) }

    it "should return a post" do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(payload["id"]).to eq(post.id)
      expect(payload["title"]).to eq(post.title)
      expect(payload["content"]).to eq(post.content)
      expect(payload["published"]).to eq(post.published)
      expect(payload["author"]["name"]).to eq(post.user.name)
      expect(payload["author"]["email"]).to eq(post.user.email)
      expect(payload["author"]["id"]).to eq(post.user.id)
      expect(response).to have_http_status(200)
    end
  end
end