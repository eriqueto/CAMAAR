class Admin::BaseController < ApplicationController
  before_action :require_login
  before_action :require_admin

  private

  def require_admin
    redirect_to root_path, alert: "Acesso negado." unless is_admin?
  end
end