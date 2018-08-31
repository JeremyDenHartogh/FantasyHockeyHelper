class LeagueController < ApplicationController
  def info
    begin 
        @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/settings", :authorization => "Bearer #{params[:token]}")
        @info = Hash.from_xml(@response.body)['fantasy_content']['league']
        @settings = @info['settings']
        @roster_positions = @settings['roster_positions']['roster_position']
        @stat_categories = @settings['stat_categories']['stats']['stat']
    rescue
        @response = "ERROR: League ID not Found"
    end
  end
end
