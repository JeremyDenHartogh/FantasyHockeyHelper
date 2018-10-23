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
        begin
          @standings.sort! {|a, b| a["team_standings"]["rank"].to_i <=> b["team_standings"]["rank"].to_i}
        rescue
          @standings.sort_by!{ |t| t['name'] }
        end
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
      
      fileName = 'StatProjector/FullProjections.csv'
      csv_text = File.read(Rails.root + fileName)
      @projections = CSV.parse(csv_text, :headers => true)
      @players = []
      @count = 0
      @dropValue = [101,101,101,101]
      @dropRec = ["","","",""]
      for player in @roster do
        stats = @projections.find {|row| row['Last Name'] == player["name"]["last"] && row['First Name'] == player["name"]["first"] && row['Team'] ==  player["editorial_team_full_name"]}
        schedule = @dates.find {|row| row[0] == player["editorial_team_full_name"]}
        gp = 0
        for i in 1..schedule.length-1
          if schedule[i] != "-"
           gp += 1
          end
        end
        if stats
          isLowestPlayer(player,stats,0)
          if player['display_position'].include? "D"
            isLowestPlayer(player,stats,2)
          elsif player['display_position'].include? "G"
            isLowestPlayer(player,stats,3)
          else
            isLowestPlayer(player,stats,1)
          end

          @players.push([player,schedule,gp,stats])
        else
          @players.push([player,schedule,gp])
          puts player
        end
      end
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
  puts fInd
  puts lInd
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

def isLowestPlayer(player,stats,index)
  if stats["Value"].to_f < @dropValue[index]
    @dropValue[index] = stats["Value"].to_f
    @dropRec[index] = "#{player["name"]["first"]} #{player["name"]["last"]}"
  end
end