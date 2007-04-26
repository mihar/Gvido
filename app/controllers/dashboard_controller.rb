class DashboardController < ApplicationController
  def index
    @contacts = Contact.unprocessed
  end
end
