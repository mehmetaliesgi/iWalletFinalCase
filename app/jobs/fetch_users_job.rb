class FetchUsersJob < ApplicationJob
  queue_as :default

  def perform(*arg)
    conn = Faraday.new(url: 'https://jsonplaceholder.typicode.com')
    response = conn.get('/users')
    users = JSON.parse(response.body)

    users.each do |user_data|
      user_id = user_data['id']
      @photo_url = get_photo_url(user_id)

      User.create_or_find_by(email: user_data['email']) do |user|
        user.update(
          name: user_data['name'],
          username: user_data['username'],
          email: user_data['email'],
          address: user_data['address'],
          phone: user_data['phone'],
          website: user_data['website'],
          company: user_data['company'],
          photo_url: @photo_url
      )
      end
    end
  end

  def get_photo_url(user_id)
    conn = Faraday.new(url: "https://picsum.photos/id/#{user_id}/info")
    response = conn.get
    photo_data = JSON.parse(response.body)
    photo_data["download_url"]
  end
end
