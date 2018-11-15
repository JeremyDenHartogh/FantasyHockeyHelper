class FreeagentsController < ApplicationController
  def allFA
    @list = "All"
    begin
      @count = 1
      @freeagents = []
      for i in 0..3 do
        @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/players;status=A;start=#{i*25};count=25;sort=AR", :authorization => "Bearer #{params[:token]}")
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
  
  def full
    @list = "All"
    setFreeagents("Full")
    render 'allFA'
  end  
  
  def setFreeagents(position)
    begin
      @position = position
      @count = 1
      @freeagents = []
      @waivers = []
      @players = []
      @count2 = 0
      @dropValue = -1
      @dropRec = ""
      
      fileName = 'StatProjector/WeeksData.csv'
      csv_text = File.read(Rails.root + fileName)
      weeks = CSV.parse(csv_text, :headers => true)
    
      startDate = Date.new(2018, 10, 3)
      endDate = Date.new(2019, 4, 6)
      currDate = DateTime.now-(4/24.0) 
      currDateIndex = ((endDate-startDate).to_i - (endDate-currDate).to_i )
      currWeek = []
      for week in weeks
        currWeek = betweenDates(currDateIndex,week)
        if currWeek != []
          break
        end
      end
      
      fileName = 'StatProjector/Schedule.csv'
      csv_text = File.read(Rails.root + fileName)
      @dates = CSV.parse(csv_text, :headers => false)
      @dates = getRange(currWeek[3].to_i,currWeek[4].to_i,@dates)
      @datesHeader = @dates[0]
      if (position == "C" || position == "L" || position == "R")
        fileName = 'StatProjector/' + 'F' + 'Projections.csv'
      else
        fileName = 'StatProjector/' + position + 'Projections.csv'
      end
      
      csv_text = File.read(Rails.root + fileName)
      @projections = CSV.parse(csv_text, :headers => true)
      
      getPlayers(position,params[:state])

      @players.sort! {|a, b| b[1]['Value'].to_f <=> a[1]['Value'].to_f}
      @info = Hash.from_xml(@response.body)['fantasy_content']['league']
    rescue
      @response = "ERROR: League ID not Found"
    end
  end
end

def betweenDates(index,week)
  if (index <= week[4].to_i)
    return week
  end
  return []
end

def getRange(fInd,lInd,datesCSV)
  returnDates = []
  for row in datesCSV
    cutRow = [row[0]]
    for i in fInd..lInd
      if row[i] == "0"
        row[i] = "-"
      end
      cutRow.append(row[i])
    end
    returnDates.append(cutRow)
  end
  return returnDates
end

def isBestPlayer(player,stats)
  if stats["Value"].to_f > @dropValue
    @dropValue = stats["Value"].to_f
    @dropRec = "#{player["name"]["first"]} #{player["name"]["last"]}"
  end
end

def getFAInfo(type, array)
  for player in array do
    stats = @projections.find {|row| (row['Last Name'] == player["name"]["last"] && row['First Name'] == player["name"]["first"] && row['Team'] == player["editorial_team_full_name"])}
    if stats 
      schedule = @dates.find {|row| row[0] == player["editorial_team_full_name"]}
      gp = 0
      isBestPlayer(player,stats)
      for i in 1..schedule.length-1
        if schedule[i] != "-"
         gp += 1
        end
      end
      @players.push([player,stats,schedule,gp,type])
    else
      puts player
    end
  end
end

def getPlayers(position,type)
  puts "A"
  if type == "postdraft"
    begin
      if position == "Full"
          @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/players;status=W;start=0;count=25;sort=AR;", :authorization => "Bearer #{params[:token]}")
        else
          @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/players;status=W;start=0;count=25;sort=AR;position=#{position}", :authorization => "Bearer #{params[:token]}")
      end
      @waivers.push(*Hash.from_xml(@response.body)['fantasy_content']['league']['players']['player']) 
      for i in 0..2 do
        if position == "Full"
          @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/players;status=FA;start=#{i*25};count=25;sort=AR;", :authorization => "Bearer #{params[:token]}")
        else
          @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/players;status=FA;start=#{i*25};count=25;sort=AR;position=#{position}", :authorization => "Bearer #{params[:token]}")
        end
        @freeagents.push(*Hash.from_xml(@response.body)['fantasy_content']['league']['players']['player']) 
      end
      getFAInfo("Yes",@waivers)
      getFAInfo("No",@freeagents)
    rescue
      @freeagents = []
      for i in 0..3 do
        if position == "Full"
          @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/players;status=A;start=#{i*25};count=25;sort=AR;", :authorization => "Bearer #{params[:token]}")
        else
          @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/players;status=A;start=#{i*25};count=25;sort=AR;position=#{position}", :authorization => "Bearer #{params[:token]}")
        end
        @freeagents.push(*Hash.from_xml(@response.body)['fantasy_content']['league']['players']['player']) 
      end
      getFAInfo("No",@freeagents)
    end
  else
    @freeagents = []
    for i in 0..5 do
      if position == "Full"
        @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/players;status=A;start=#{i*25};count=25;sort=OR;", :authorization => "Bearer #{params[:token]}")
      else
        @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/players;status=A;start=#{i*25};count=25;sort=OR;position=#{position}", :authorization => "Bearer #{params[:token]}")
      end
      @freeagents.push(*Hash.from_xml(@response.body)['fantasy_content']['league']['players']['player']) 
    end
    getFAInfo("N/A",@freeagents)
  end
end