class LandingController < ApplicationController
  def index
  end
  
  def home
    begin
      @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games;game_keys=nhl/leagues;season=2018", :authorization => "Bearer #{params[:token]}")
      @info = Hash.from_xml(@response.body)['fantasy_content']['users']['user']['games']['game']['leagues']['league']
      @leagues = []
      puts @info
      begin
        for league in @info
          @leagues.push({"leagueID" => league['league_id'], "leagueName" => league['name']})
        end
      rescue
        @leagues.push({"leagueID" => @info['league_id'], "leagueName" => @info['name']})
      end
    rescue
       redirect_to root_path
    end
  end
  
  def login
  end
end
