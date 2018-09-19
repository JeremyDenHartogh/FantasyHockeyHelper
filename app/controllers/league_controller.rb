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
  
  def standings
    begin
      @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/standings", :authorization => "Bearer #{params[:token]}")
      @info = Hash.from_xml(@response.body)['fantasy_content']['league']
      @standings = @info['standings']['teams']['team']
      if @info['num_teams'].to_i  > 1
        @standings.sort_by!{ |t| t['name'] }
      end
      puts (@standings)
    rescue
      @response = "ERROR: League ID not Found"
    end
  end
  
  def roster
    begin
      @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/team/#{params[:team]}/roster/", :authorization => "Bearer #{params[:token]}")
      @info = Hash.from_xml(@response.body)['fantasy_content']['team']
      @roster = @info['roster']['players']['player']
      fileName = 'app/assets/spreadsheets/FullProjections.csv'
      csv_text = File.read(Rails.root + fileName)
      @projections = CSV.parse(csv_text, :headers => true)
      @players = []
      for player in @roster do
        stats = @projections.find {|row| row['Last Name'] == player["name"]["last"] && row['First Name'] == player["name"]["first"]}
        if stats 
          @players.push([player,stats])
        else
          @players.push([player])
          puts player
        end
      end
    rescue
      @response = "ERROR: League ID not Found"
    end
  end
end
