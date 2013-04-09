module Guachiman
  module Permissible
    extend ActiveSupport::Concern

    included do
      before_filter :authorize
    end

    def current_permission
      @current_permission ||= Permission.new current_user
    end

    def current_resource
      nil
    end

    def current_user
      raise 'This method must be implemented'
    end

    def authorize
      if current_permission.allow? params[:controller], params[:action], current_resource
        current_permission.permit_params!(params) if current_permission.respond_to? :permit_params!
      else
        not_authorized
      end
    end

    def not_authorized
      if current_user
        redirect_to :root, alert: t(:not_authorized)
      else
        redirect_to :login, alert: t(:please_login)
      end
    end
  end
end
