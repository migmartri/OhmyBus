class MainController < ApplicationController
  
  def index
    @histories = History.find(:all, :order => 'created_at desc', :limit => 5)
  end
end
