module AmazonSearcher
  class << self
    def cds keyword, artist, title
      search(keyword, artist, title).map do |item|
        jacket_image_url = item.get_hash('MediumImage')['URL'] if item.get_hash('MediumImage')
        release_date = Date.parse(item.get('ItemAttributes/ReleaseDate')) if item.get('ItemAttributes/ReleaseDate')
        cd = Cd.find_or_initialize_by(ean: item.get('ItemAttributes/EAN'))
        cd.attributes = {
          title: item.get('ItemAttributes/Title'),
          ean: item.get('ItemAttributes/EAN'),
          jacket_image_url: jacket_image_url,
          release_date: release_date,
          artist: Artist.find_or_initialize_by(name: item.get('ItemAttributes/Artist'))
        }
        cd
      end
    end

    private
    def search keyword, artist, title, page = 1
      res = nil
      Retryable.retryable(tries: 5, sleep: 2) do
        res = Amazon::Ecs.item_search(
          keyword,
          artist: artist,
          title: title,
          sort: '-orig-rel-date',
          response_group: 'Medium',
          search_index: 'Music',
          item_page: page
        )
      end
      items = res.items
      if res.total_pages > 1 && page < [res.total_pages, 10].min
        sleep(1)
        items.concat(search keyword, artist, title, page + 1)
      end
      items
    end
  end
end
