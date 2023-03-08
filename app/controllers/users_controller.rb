class UsersController < ApplicationController
  before_action 

  def create
    @user = User.new(user_params)
    hashed_password = BCrypt::Password.create("password_digest")
    @user.password_digest = hashed_password
    if @user.save
      render json: { message: "Usuario creado con éxito" }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
    
  def login
    user = User.find_by(name: params[:name])
    if user and user.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { token: token }, status: :ok
    else
      render json: { message: "Credenciales inválidas" }, status: :unauthorized
    end
  end

  def encode_token(payload)
    JWT.encode(payload, 'your_secret_key')
  end
        
    private

    def user_params
      params.permit(:name, :email, :password_digest)
    end
end
