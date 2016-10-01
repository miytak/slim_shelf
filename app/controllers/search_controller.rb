class SearchController < ApplicationController
  def index
    @items = Amazon::Ecs.item_search(
      'みんなのうた',
      response_group: 'Medium',
      search_index: 'Music',
      country: 'jp'
    ).items
  end
end
