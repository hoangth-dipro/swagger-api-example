# frozen_string_literal: true

module API
  class V1
    class User < Grape::API
      helpers do
        include UserHelper
        params :signup_account do
          requires :email, type: String, desc: 'Phone Number'
          requires :password, type: String, desc: 'Password'
          requires :password_comfirm, type: String, same_as: :password, desc: 'Password Comfirm'
        end

        params :auths do
          requires :email, type: String, desc: 'Email'
          requires :password, type: String, desc: 'Password'
        end
      end

      resource :signup do
        desc 'API Sign Up'
        params do
          use :signup_account
        end
        post rabl: 'v1/users/auth' do
          user = ::User.create!(email: params[:email], password: params[:password])
          @access_token = generate_access_token(user)
        end
      end

      resource :auths do
        desc 'API Authentication'
        params do
          use :auths
        end
        post rabl: 'v1/users/auth' do
          user = ::User.find_by(email: params[:email])
          error 'email_password', 'login_failure', 400, true, 'error' unless user&.authenticate(params[:password])
          @access_token = generate_access_token(user)
          user.update!(access_token: @access_token)
        end
      end
    end
  end
end
