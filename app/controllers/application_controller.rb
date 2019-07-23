class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: "Hi, this is Bomiao Chen's image sharer!"
  end
end
