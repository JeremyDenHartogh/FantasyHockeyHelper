class FreeagentsController < ApplicationController
  def allFA
    @list = "All"
    begin
      @count = 1
      @freeagents = []
      for i in 0..3 do
        @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/players;status=A;start=#{i*25};count=25;sort=OR", :authorization => "Bearer #{params[:token]}")
        @freeagents.push(*Hash.from_xml(@response.body)['fantasy_content']['league']['players']['player']) 
      end
      @info = Hash.from_xml(@response.body)['fantasy_content']['league']

    rescue
      @response = "ERROR: League ID not Found"
    end
  end

  def center
    @list = "Center"
    setFreeagents("C")
    render 'allFA'
  end
  
  def defence
    @list = "Defence"
    setFreeagents("D")
    render 'allFA'
  end  
  
  def leftwing
    @list = "Left Wing"
    setFreeagents("LW")
    render 'allFA'
  end
  
  def rightwing
    @list = "Right Wing"
    setFreeagents("RW")
    render 'allFA'
  end  
    
  def goalie
    @list = "Goalie"
    setFreeagents("G")
    render 'allFA'
  end  
  
  def forward
    @list = "Forward"
    setFreeagents("F")
    render 'allFA'
  end
  
  def skater
    @list = "Skater"
    setFreeagents("P")
    render 'allFA'
  end  
  
  def setFreeagents(position)
    begin
      @position = position
      @count = 1
      @freeagents = []
      @players = []
      fileName = 'app/assets/spreadsheets/' + position + 'Projections.csv'
      csv_text = File.read(Rails.root + fileName)
      @projections = CSV.parse(csv_text, :headers => true)
      for i in 0..1 do
        @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/players;status=A;start=#{i*25};count=25;sort=OR;position=#{position}", :authorization => "Bearer #{params[:token]}")
        @freeagents.push(*Hash.from_xml(@response.body)['fantasy_content']['league']['players']['player']) 
      end
      for player in @freeagents do
        stats = @projections.find {|row| row['Last Name'] == player["name"]["last"]}
        if stats 
          @players.push([player,stats])
        else
          puts player
        end
      end
      @info = Hash.from_xml(@response.body)['fantasy_content']['league']
    rescue
      @response = "ERROR: League ID not Found"
    end
  end
end