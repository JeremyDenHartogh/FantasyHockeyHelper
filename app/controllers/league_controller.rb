class LeagueController < ApplicationController
  def info
    begin 
        @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/settings", :authorization => "Bearer #{params[:token]}")
        @info = Hash.from_xml(@response.body)['fantasy_content']['league']
        @settings = @info['settings']
        @roster_positions = @settings['roster_positions']['roster_position']
        @stat_categories = @settings['stat_categories']['stats']['stat']
        if @settings['uses_playoff'] == '1'
          @playoffStartWeek = @settings['playoff_start_week'].to_i
          @playoffEndWeek = 24
          numPlayoffsTeams =  @settings['num_playoff_teams'].to_i
          if (numPlayoffsTeams <= 2)
            @playoffEndWeek = @playoffStartWeek + 0
          elsif (numPlayoffsTeams < 6)
            @playoffEndWeek = @playoffStartWeek + 1
          else
            @playoffEndWeek = @playoffStartWeek + 2
          end
        end
        @response2 = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/league/nhl.l.#{params[:leagueid]}/standings", :authorization => "Bearer #{params[:token]}")
        @info2 = Hash.from_xml(@response2.body)['fantasy_content']['league']
        @standings = @info2['standings']['teams']['team']
        @usersTeam = ""
        @draftStatus = @info['draft_status']
        #puts @response
        for team in @standings
          if team["managers"]["manager"]["is_current_login"]
            @usersTeam = team["team_key"]
          end
        end
    rescue
        redirect_to root_path
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
    rescue
        redirect_to root_path
    end
  end
  
  def roster
    begin
      @response = (RestClient.get "https://fantasysports.yahooapis.com/fantasy/v2/team/#{params[:team]}/roster/", :authorization => "Bearer #{params[:token]}")
      @info = Hash.from_xml(@response.body)['fantasy_content']['team']
      @players = []
      @count = 0
      @dropValue = [101,101,101,101]
      @dropRec = ["","","",""]
      @dropValueW = [1001,1001,1001,1001]
      @dropRecW = ["","","",""]
      
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
      @playoffStartWeek = params[:pStart].to_i
      @playoffEndWeek = params[:pEnd].to_i
      if (params[:week])
        @displayWeek = @weeks[params[:week].to_i - 1]
      else
        @displayWeek = @currWeek
      end
      
      fileName = 'StatProjector/Schedule.csv'
      csv_text = File.read(Rails.root + fileName)
      @dates = CSV.parse(csv_text, :headers => false)
      @dates = getRange(@displayWeek[3].to_i,@displayWeek[4].to_i,@dates)
      @datesHeader = @dates[0]
      @daysLeft = @displayWeek[4].to_i - currDateIndex + 1

      fileName = 'StatProjector/FullProjections.csv'
      csv_text = File.read(Rails.root + fileName)
      @projections = CSV.parse(csv_text, :headers => true)

      @roster = @info['roster']['players']['player']
      for player in @roster do
        stats = @projections.find {|row| row['Last Name'] == player["name"]["last"] && row['First Name'] == player["name"]["first"] && row['Team'] ==  player["editorial_team_full_name"]}
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
        if stats
          isLowestPlayer(player,stats,0,gLeft)
          if player['display_position'].include? "D"
            isLowestPlayer(player,stats,2,gLeft)
          elsif player['display_position'].include? "G"
            isLowestPlayer(player,stats,3,gLeft)
          else
            isLowestPlayer(player,stats,1,gLeft)
          end

          @players.push([player,schedule,gp,gLeft,stats])
        else
          @players.push([player,schedule,gp,gLeft])
        end
      end
    rescue
      redirect_to root_path
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

def isLowestPlayer(player,stats,index,gl)
  if stats["Value"].to_f < @dropValue[index] && player['selected_position']['position'] != "IR" && player['selected_position']['position'] != "IR+" && player['selected_position']['position'] != "NA"
    @dropValue[index] = stats["Value"].to_f
    @dropRec[index] = "#{player["name"]["first"]} #{player["name"]["last"]}"
  end
  if stats["Value"].to_f*gl < @dropValueW[index] && player['selected_position']['position'] != "IR" && player['selected_position']['position'] != "IR+" && player['selected_position']['position'] != "NA"
    @dropValueW[index] = stats["Value"].to_f*gl
    @dropRecW[index] = "#{player["name"]["first"]} #{player["name"]["last"]}"
  end
end