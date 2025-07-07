require 'rubygems'
require 'role_model'
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

    def user_params
      params.permit(:email, :password, :password_confirmation, :remember_me, :roles_mask, :roles, :provider, :uid, :fb_uid, :fb_first_name, :fb_last_name, :fb_name, :fb_image, :go_uid, :go_email, :go_first_name, :go_last_name, :go_name, :go_image)
    end


  def email_required?
    super && provider.blank?
  end
  
  def self.is_uid_taken?(user, column, uid)
    u = User.where(column => uid).first
    return true if u and u.id != user.id
    return false
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  # Role model
  include RoleModel
  
  # The attribute to store roles in.
  roles_attribute :roles_mask
  
  # A number of default roles are defined. Their suggested use is stated below.
  # This is just a suggestion and needs to be adapted to the specific application.
  #
  # Superuser: A user with full permissions in a multi-tenant system.
  # Admin: Typical admin role. Highest permission in a single tenant.
  # Manager: Ability to add and remove user within a group of users.
  # Editor: Normal editing permissions.
  # Contributor: Allowed to make changes but with some limitied permissions.
  # Viewer: Read only access.
  # Limited: Any kind of users with limited access, e.g. freemium users.
  #
  # NOTE: only add new roles to the end of the list.
  roles :superuser, :admin, :manager, :editor, :contributor, :viewer, :limited

  def has_facebook?
    return fb_uid.present?
  end
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil, session=nil)
    user = signed_in_resource
    user = User.where(:fb_uid => auth.uid).first unless user
    p auth unless user

    # Prevent account creation via social login
    unless Rails.application.config.allow_social_account_creation || signed_in_resource || user
      # This means that the user is not logged in and there was no matching User object
      session["flash_error"] = "A local account is required in order to log on using Facebook."
      return nil
    end

    unless user
      user = User.create(provider:auth.provider,
        uid:auth.uid,
        email:auth.info.email,
        password:Devise.friendly_token[0,20]
        )
      session["user_return_to"] = "/users/edit"
    end
  
    if User.is_uid_taken?(user, :fb_uid, auth.uid)
      user.errors[:base] << :taken
      return user
    end
  
    user.update(
        fb_uid:auth.uid,
        fb_email:auth.info.email,
        fb_first_name:auth.info.first_name,
        fb_last_name:auth.info.last_name,
        fb_name:auth.info.name,
        fb_image:auth.info.image
        )
    user
  end
  def has_google?
    return go_uid.present?
  end
  
  def self.find_for_google_oauth2(auth, signed_in_resource=nil, session=nil)
    user = signed_in_resource
    user = User.where(:go_uid => auth.uid).first unless user
  
    p auth unless user

    # Prevent account creation via social login
    unless Rails.application.config.allow_social_account_creation || signed_in_resource || user
      # This means that the user is not logged in and there was no matching User object
      session["flash_error"] = "A local account is required in order to log on using Google."
      return nil
    end

    unless user
      user = User.create(provider:auth.provider,
        uid:auth.uid,
        email:auth.info.email,
        password:Devise.friendly_token[0,20]
        )
      session["user_return_to"] = "/users/edit"
    end
  
    if User.is_uid_taken?(user, :go_uid, auth.uid)
      user.errors[:base] << :taken
      return user
    end
  
    user.update(
        go_uid:auth.uid,
        go_email:auth.info.email,
        go_first_name:auth.info.first_name,
        go_last_name:auth.info.last_name,
        go_name:auth.info.name,
        go_image:auth.info.image
        )
    user
  end

    def username
      name || fb_name || go_name || "<no name>"
    end

    def avatar
      if Rails.env.production?
        fb_image || go_image || "http://www.gravatar.com/avatar/\#{Digest::MD5.hexdigest(email)}"
      else
        # Facebook profile picture doesn't work in development (Q4 2023)
        go_image || "http://www.gravatar.com/avatar/\#{Digest::MD5.hexdigest(email)}"
      end
    end

end
