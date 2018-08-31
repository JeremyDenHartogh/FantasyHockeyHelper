class SessionsController < ApplicationController
  def custom
    @user = request.env['omniauth.auth']
  end
end
