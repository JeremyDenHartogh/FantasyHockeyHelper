class FreeagentsController < ApplicationController
  # Function: old function for viewing all FA's, has since been replaced with setFreeAgents, still rendered as view however
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

  # Function: calls setFreeAgents with postion set as center
  def center
    @list = "Center"
    setFreeagents("C")
    render 'allFA'
  end
  
  # Function: calls setFreeAgents with postion set as defence

  def defence
    @list = "Defence"
    setFreeagents("D")
    render 'allFA'
  end  
  
  # Function: calls setFreeAgents with postion set as left wing
  def leftwing
    @list = "Left Wing"
    setFreeagents("LW")
    render 'allFA'
  end
  
  # Function: calls setFreeAgents with postion set as right wing
  def rightwing
    @list = "Right Wing"
    setFreeagents("RW")
    render 'allFA'
  end  

  # Function: calls setFreeAgents with postion set as goalie
  def goalie
    @list = "Goalie"
    setFreeagents("G")
    render 'allFA'
  end  
  
  # Function: calls setFreeAgents with postion set as forward
  def forward
    @list = "Forward"
    setFreeagents("F")
    render 'allFA'
  end
  
  # Function: calls setFreeAgents with postion set as skater
  def skater
    @list = "Skater"
    setFreeagents("P")
    render 'allFA'
  end  
  
  # Function: calls setFreeAgents for all combined positions
  def full
    @list = "All"
    setFreeagents("Full")
    render 'allFA'
  end  
  
  # Function: sets the available players list
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
      @dropValueW = -1
      @dropRecW = ""
      
      # Loads week data
      fileName = 'StatProjector/WeeksData.csv'
      csv_text = File.read(Rails.root + fileName)
      @weeks = CSV.parse(csv_text, :headers => true)
      @currWeek = []
      @displayWeek = []
      startDate = Date.new(2018, 10, 3)
      endDate = Date.new(2019, 4, 6)
      currDate = DateTime.now-(4/24.0) 
      currDateIndex = ((endDate-startDate).to_i - (endDate-currDate).to_i )
      for week in @weeks
        @currWeek = betweenDates(currDateIndex,week)
        if @currWeek != []
          break
        end
      end
      if (params[:week])
        @displayWeek = @weeks[params[:week].to_i - 1]
      else
        @displayWeek = @currWeek
      end
      @playoffStartWeek = params[:pStart].to_i
      @playoffEndWeek = params[:pEnd].to_i
      fileName = 'StatProjector/Schedule.csv'
      csv_text = File.read(Rails.root + fileName)
      @dates = CSV.parse(csv_text, :headers => false)
      @dates = getRange(@displayWeek[3].to_i,@displayWeek[4].to_i,@dates)
      @datesHeader = @dates[0]
      @daysLeft = @displayWeek[4].to_i - currDateIndex + 1
      
      
      # loads player CSV file based on position
      if (position == "C" || position == "L" || position == "R")
        fileName = 'StatProjector/' + 'F' + 'Projections.csv'
      else
        fileName = 'StatProjector/' + position + 'Projections.csv'
      end
      csv_text = File.read(Rails.root + fileName)
      @projections = CSV.parse(csv_text, :headers => true)
      
      # gets players from yahoo
      getPlayers(position,params[:state])

      # sorts players array
      @players.sort! {|a, b| b[1]['Value'].to_f <=> a[1]['Value'].to_f}
      @info = Hash.from_xml(@response.body)['fantasy_content']['league']
    rescue
      @response = "ERROR: League ID not Found"
    end
  end
end

# Function: Determines which week the index belongs to
def betweenDates(index,week)
  if (index <= week[4].to_i)
    return week
  end
  return []
end

# Function: gets list of games played on specified dates range
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

# Function: determines if viewed player is best player
def isBestPlayer(player,stats,gl)
  if stats["Value"].to_f > @dropValue
    @dropValue = stats["Value"].to_f
    @dropRec = "#{player["name"]["first"]} #{player["name"]["last"]}"
  end
  if stats["Value"].to_f*gl > @dropValueW
    @dropValueW = stats["Value"].to_f*gl
    @dropRecW = "#{player["name"]["first"]} #{player["name"]["last"]}"
  end
end

# Function: gets schedule info, and best player info
def getFAInfo(type, array)
  for player in array do
    stats = @projections.find {|row| (row['Last Name'] == player["name"]["last"] && row['First Name'] == player["name"]["first"] && row['Team'] == player["editorial_team_full_name"])}
    if stats 
      schedule = @dates.find {|row| row[0] == player["editorial_team_full_name"]}
      gp = 0
      gLeft = 0
      for i in 1..schedule.length-1
        if schedule[i] != "-"
          gp += 1
          if @displayWeek != @currWeek
            gLeft = gp
          else
            if i > schedule.length-1 - @daysLeft
              gLeft +=1
            end
          end
        end
      end
      isBestPlayer(player,stats,gLeft)
      @players.push([player,stats,schedule,gp,type,gLeft])
    else
      puts player
    end
  end
end

# Function: Get available players list from yahop
def getPlayers(position,type)
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