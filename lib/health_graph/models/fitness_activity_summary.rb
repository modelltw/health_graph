module HealthGraph
  class FitnessActivitySummary
    include Model

    hash_attr_accessor :average_heart_rate, :climb, :equipment, :type, :calories, :total_calories, :activity, :total_distance, :duration, :start_time, :notes

    def initialize(access_token, params)
      self.access_token = access_token
      response = get params["uri"], HealthGraph.accept_headers[:fitness_activity_summary]
      self.body = response.body
      populate_from_hash! self.body
    end
  end
end
