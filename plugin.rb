# name: twitter
# about: Post new announcement topics to Twitter
# version: 0.0.1
# authors: Victoria Fierce <tdfischer@hackerbots.net>

gem 'twitter','5.16.0'
enabled_site_setting :twitter_enabled

DiscourseEvent.on(:topic_created) do |topic|
  if SiteSetting.twitter_enabled
    if topic.category.slug == SiteSetting.twitter_category
      client = Twitter::REST::Client.new do |config|
        config.consumer_key = SiteSetting.twitter_consumer_key
        config.consumer_secret = SiteSetting.twitter_consumer_secret
        config.access_token = SiteSetting.twitter_access_token
        config.access_token_secret = SiteSetting.twitter_access_secret
      end

      topic_url = Topic.url(topic.id, topic.slug)
      title = topic.title
      tweet_text = title + ": " + topic_url
      Rails.logger.info("Tweeting new announcement: \""+tweet_text+"\"")
      Rails.logger.info(client.home_timeline)
      client.update(tweet_text)
    end
  end
end
