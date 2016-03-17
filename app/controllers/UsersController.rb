# this file is a controller for the users.db
class UsersController < ApplicationController
    def index
        @users = User.all
    end

end
    