class ApiController < ApplicationController
  before_action :set_user, only: [:show, :edit]
  before_action :fetch_album, only: [:popup]
  
  def index
    @users = User.all
  end

  def new
    @user = {}
  end

  def create
    user_params = create_user_params
    address_params = user_params[:address] || {}

    new_user = create_user(user_params, address_params)
    if new_user
      flash[:notice] = "User successfully created!"
      FetchUsersJob.perform_now
      redirect_to root_path
    else
      flash[:alert] = "Failed to create user. Status: #{new_user.status}. Error: #{new_user.body}"
      render :new
    end
  end

  def show
    @albums = fetch_user_albums(params[:id])
  end

  def edit;end

  def update
    user_id = params[:id]
    user_params = create_user_params
    address_params = user_params[:address]
    update_user_db= update_user_on_db(user_params, user_id)
    updated_user_api = update_user_on_api(user_params, address_params, user_id)
    if update_user_db && updated_user_api
      flash[:notice] = "User updated successfully."
      FetchUsersJob.perform_now
      redirect_to api_path(user_id)
    else
      flash[:alert] = "Failed to update user."
      render :edit
    end
  end

  def search
    if params[:username].blank?
      @users = User.all
    else
      @users = User.all.select { |user| user["username"]&.downcase&.include?(params[:username]&.downcase) }
    end
    render :index
  end

  def popup
    album_id = @album['id']
    @album_link = "https://jsonplaceholder.typicode.com/albums/#{album_id}"  
    @user = fetch_album_by_id(album_id)
  end

  private

  def create_user_params
    params.require(:user).permit(:name, :username, :email, :phone, :photo_url, address: [:street, :suite, :city, :zipcode])
  end

  def create_user(user_params, address_params)
    response = Faraday.new(url: 'http://localhost:3001').post do |request|
      request.url '/users'
      request.headers['Content-Type'] = 'application/json'
      
      request_body = {
        name: user_params[:name],
        username: user_params[:username],
        email: user_params[:email],
        address: {
          street: address_params[:street],
          suite: address_params[:suite],
          city: address_params[:city],
          zipcode: address_params[:zipcode]
        },
        phone: user_params[:phone]
      }.to_json
      request.body = request_body
    end
  end

  def update_user_on_api(user_params, address_params, user_id)
    conn = Faraday.new(url: 'http://localhost:3001')
    response = conn.patch("/users/#{user_id}") do |request|
    request.headers['Content-Type'] = 'application/json'

    request_body = {
      name: user_params[:name],
      username: user_params[:username],
      email: user_params[:email],
      address: {
        street: address_params[:street],
        suite: address_params[:suite],
        city: address_params[:city],
        zipcode: address_params[:zipcode]
      },
      phone: user_params[:phone]
    }.to_json
    request.body = request_body
    end
  end

  def update_user_on_db(user_params, user_id)
    user = User.find_by(id: user_id)
    user.update(user_params)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def fetch_user_albums(user_id)
    conn = Faraday.new(url: 'https://jsonplaceholder.typicode.com')
    response = conn.get("/albums", { userId: user_id })
    JSON.parse(response.body) if response.status == 200
  end

  def fetch_album
    @album = fetch_album_by_id(params[:id])
  end

  def fetch_album_by_id(album_id)
    conn = Faraday.new(url: 'https://jsonplaceholder.typicode.com')
    response = conn.get("/albums/#{album_id}")
    JSON.parse(response.body) if response.status == 200
  end
end
