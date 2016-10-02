class CdsController < ApplicationController
  def index
  end

  def search
    @cds = AmazonSearcher.cds params['search']['keyword'], params['search']['artist'], params['search']['title']
    render :index
  end
end
