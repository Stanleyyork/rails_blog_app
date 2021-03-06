class SessionsController < ApplicationController

	before_filter :current_user_logged_in, except: [:destroy]

	def new
	end

	def create
		user = User.find_by_email(params['login']['email'])
		if user && user.authenticate(params['login']['password'])
			if params[:remember_me]
			  cookies.permanent[:auth_token] = user.auth_token
			else
			  cookies[:auth_token] = user.auth_token
			end
			redirect_to root_url, :notice => "Logged in!"
		else
			flash[:error] = user.errors.full_messages.join(", ")
			render "new"
		end
	end

	def destroy
		cookies.delete(:auth_token)
		redirect_to root_url, :notice => "Logged out!"
	end
end
