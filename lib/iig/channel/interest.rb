# encoding: utf-8

module InterestIrcGateway
  class Channel
    class Interest < Channel
      def monitoring
        interests.each do |nick, entries|
          entries.each do |entry|
            next if @notified_entries.include?(entry.url)
            @notified_entries << entry.url
            yield(nick, "#{entry.title} #{entry.url} (#{entry.users})")
          end
        end
      end

      private
        def interests
          interests = {}
          @hatebu.get("http://b.hatena.ne.jp/#{@username}/interest") do |page|
            page.search('div.interest-sub-unit').each do |interest|
              keyword = interest.at('h2/a').text
              interests[keyword] = []
              interest.search('ul.sub-entry-list/li').each do |entry_dom|
                interests[keyword] << OpenStruct.new(extract_entry_information(entry_dom))
              end
            end
          end
          interests
        end

        def extract_entry_information(entry_dom)
          {
            title: entry_dom.at('h3/a').attributes['title'].text,
            url:   entry_dom.at('h3/a').attributes['href'].text,
            users: entry_dom.at('span.users').text
          }
        end
    end
  end
end
