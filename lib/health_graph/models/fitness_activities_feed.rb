module HealthGraph
  class FitnessActivitiesFeed
    include Model

    hash_attr_accessor :items, :next, :previous, :size

    class Item
      include Model

      hash_attr_accessor :type, :start_time, :total_distance, :duration, :uri, :activity
      coerce_key :start_time, HealthGraph::DateTime

      def initialize(access_token, hash)
        self.access_token = access_token
        populate_from_hash! hash
      end

      def item
        params = Hash.new
        params["uri"] = uri
        HealthGraph::FitnessActivity.new self.access_token, params
      end

      def summary
        params = Hash.new
        params["uri"] = uri
        HealthGraph::FitnessActivitySummary.new self.access_token, params
      end
    end

    def initialize(access_token, path, params = {})
      self.access_token = access_token
      self.path = path
      self.params = params
      response = get path, HealthGraph.accept_headers[:fitness_activity_feed], params
      self.body = response.body
      populate_from_hash! self.body
    end

    def next_page
      page(self.next) if self.next
    end

    def previous_page
      page(self.previous) if self.previous
    end

    protected

    def page path
      self.class.new self.access_token, path
    end

    def unpack_items value
      value.map do |hash|
        Item.new self.access_token, hash
      end
    end
  end
end
