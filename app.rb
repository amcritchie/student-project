require "sinatra"
require "gschool_database_connection"
# require "active_record"
require "rack-flash"
require_relative "lib/users_table"
require_relative "lib/fishes_table"


class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @users_table = UsersTable.new(
        GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
    @fishes_table = FishesTable.new(
        GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
  end

  def check_fields(new_user)
    register_attempt = {}
    if new_user[:first] == ''
      flash[:registration] = "Please fill in your first name."
      return register_attempt
    end
    register_attempt.merge!(:first_name => new_user[:first])

    if new_user[:last] == ''
      flash[:registration] = "Please fill in your last name."
      return register_attempt
    end
    register_attempt.merge!(:last_name => new_user[:last])

    if new_user[:email] == ''
      flash[:registration] = "Please fill in your email."
      return register_attempt
    end
    register_attempt.merge!(:email => new_user[:email])

    if new_user[:username] == ''
      flash[:registration] = "Please fill in a username."
      return register_attempt
    elsif @users_table.find_user(new_user[:username]) != []
      flash[:registration] = "Username is already in use, please choose another."
      return register_attempt
    end
    register_attempt.merge!(:username => new_user[:username])

    if new_user[:password] == ''
      flash[:registration] = "Please create a password."
      return register_attempt
    end
    register_attempt.merge!(:password => new_user[:password])


  end

  get "/" do
    users = @users_table.users
    fishes = @fishes_table.fishes

    erb :root, :locals => {:users => users, :fishes => fishes}
  end

  get "/registration" do
    register_attempt = {}
    erb :registration, :locals => {:register_attempt => register_attempt}
  end

  post "/registration" do

    new_user = {
        :first => params[:first_name],
        :last => params[:last_name],
        :email => params[:email],
        :username => params[:username],
        :password => params[:password],
        :confirm_password => params[:confirm_password]}

    register_attempt = check_fields(new_user)

    if register_attempt.count < (new_user.count - 1)
      erb :registration, :locals => {:register_attempt => register_attempt}
    elsif params[:password] != params[:confirm_password]
      flash[:registration] = "Please enter your password identically"
      erb :registration, :locals => {:register_attempt => register_attempt}
    else
      flash[:notice] = "Thank you for registering"
      flash[:registration] = nil
      @users_table.create(params[:username], params[:password])
      redirect "/"
    end
  end

  # post "/sort" do
  #   if params[:order] == "asc"
  #     @order_user_string += " ORDER BY username ASC"
  #   elsif params[:order] == "desc"
  #     @order_user_string += " ORDER BY username DESC"
  #   end
  #   erb :root, :locals => {:send => @order_user_string}
  # end


  post "/login" do
    current_user = @users_table.find_by(params[:username], params[:password])
    session[:user_id] = current_user["id"]
    # p "the session id is #{session[:user_id]}"
    flash[:not_logged_in] = true
    flash[:login] = "Welcome, #{params[:username].capitalize}"
    redirect "/"
  end

  get "/delete/:username_to_delete" do
    @users_table.delete_user(params[:username_to_delete].downcase)
    redirect "/"
  end

  get "/fishes/:users_fishes" do
    @fishes_table.find_by(params[:users_fishes])
    #pass info into template html.
  end

  post "/logout" do
    session[:user_id] = nil
    redirect "/"
  end

  get "/create_fish" do
    erb :create_fish
  end

  post "/create_fish" do
    @fishes_table.create(params[:fishname], params[:wikilink], session[:user_id])
    redirect "/"
  end

  post "/fish_list" do
    @fish = find_other_users_fish(params[:username])
    p @fish
    redirect back
  end

  private



  def find_other_users_fish(username)
    @database_connection.sql("select * from fish inner join users on fish.user_id = users.id where users.username = '#{username}'")
  end

end #end of class
