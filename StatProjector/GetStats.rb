require 'rest-client'
require 'active_support/core_ext/hash'
require 'json'

def getTeamIds()
  response = (RestClient.get "https://statsapi.web.nhl.com/api/v1/teams?season=20172018")
  info = JSON.parse(response)['teams']
  ids = []
  for i in 0..info.length-1
    ids.push(info[i]['id'])
  end
  return ids
end

def getPlayers()
  ids = getTeamIds()
  @players = []
  for i in 0..0 do
    id = ids[i]
    @response = (RestClient.get "https://statsapi.web.nhl.com/api/v1/teams/#{id}?expand=team.roster&season=20172018")
    @info = JSON.parse(@response)['teams'][0]
    @roster = @info['roster']['roster']
    puts @info["name"]
    for j in 0..3
      begin 
        playerData = JSON.parse((RestClient.get "https://statsapi.web.nhl.com/api/v1/people/#{@roster[j]["person"]["id"]}/stats?stats=skatersummaryshooting&season=20172018"))['stats'][0]['splits']
        puts playerData
      rescue
        playerData = "ERROR"
        puts "ERROR"
        puts @roster[j]["person"]["fullName"]
        puts @roster[j]["person"]["id"]
      end
      @players.push({"name" => @roster[j]["person"]["fullName"], "id" => @roster[j]["person"]["id"], "positon" => @roster[j]["position"], "team" => {"name" => @info["name"], "abbreviation" => @info["abbreviation"]}, "stats" => playerData})
    end
  end
end

def getPlayerStats(numYears,yearCombo,year1,year2)
  @year1 = year1
  @year2 = year2
  for i in 0..(numYears-1)
    @playerIds.push([])
    @players.push([])
    aggregate = "true"
    if (yearCombo == 0)
      aggregate = "false"
    end
    #info = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/skaters?isAggregate=false&reportType=season&isGame=false&reportName=skatersummary&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=20")['data']
    basic = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/skaters?isAggregate=#{aggregate}&reportType=season&isGame=false&reportName=skatersummary&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId<=#{@year1+i+yearCombo}#{@year2+i+yearCombo}%20and%20seasonId>=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=20")['data']
    advance = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/skaters?isAggregate=#{aggregate}&reportType=shooting&isGame=false&reportName=skatersummaryshooting&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId<=#{@year1+i+yearCombo}#{@year2+i+yearCombo}%20and%20seasonId>=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=20")['data']
    advance2 = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/skaters?isAggregate=#{aggregate}&reportType=shooting&isGame=false&reportName=skaterpercentages&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId<=#{@year1+i+yearCombo}#{@year2+i+yearCombo}%20and%20seasonId>=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=20")['data']
    realTime = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/skaters?isAggregate=#{aggregate}&reportType=season&isGame=false&reportName=realtime&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId<=#{@year1+i+yearCombo}#{@year2+i+yearCombo}%20and%20seasonId>=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=20")['data']
    averages = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/skaters?isAggregate=#{aggregate}&reportType=season&isGame=false&reportName=skaterpoints&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId<=#{@year1+i+yearCombo}#{@year2+i+yearCombo}%20and%20seasonId>=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=20")['data']
    puts (realTime[0])
    for j in 0..basic.length-1
      player = basic[j]
      if (player["playerIsActive"] == 0)
        next
      end
      
      @playerIds[@playerIds.length-1].push(player["playerId"])
      playerRT = realTime[j]
      playerAV = averages[j]
      posVal = 0
      if (player["playerPositionCode"].include? "D")
        posVal = 0
      else
        posVal = 1
      end
      playerInfo = {"First Name" => player["playerFirstName"], "Last Name" => player["playerLastName"], "Team" => player["playerTeamsPlayedFor"], "Age" => (@year2+i+yearCombo-(player["playerBirthDate"][0..4]).to_i), 
                    "Position" => player["playerPositionCode"], "PosVal" => posVal, "ID" => player["playerId"]}
      pppgp = (player["ppPoints"].to_f/player["gamesPlayed"].to_f).round(4).to_s
      baseStats = {"GP" => player["gamesPlayed"], "G" => player["goals"], "G/GP" => playerRT["goalsPerGame"], "A" => player["assists"], "A/GP" => playerAV["assistsPerGame"], "P" => player["points"], 
                   "P/GP" => playerAV["pointsPerGame"], "+/-" => player["plusMinus"], "PPP" => player["ppPoints"], "PPP/GP" => pppgp, "SHP" => player["shPoints"], "SOG" => player["shots"],
                   "SOG/GP" => playerRT["shotsPerGame"], "H" => playerRT["hits"], "H/GP" => playerRT["hitsPerGame"], "BLK" => playerRT["blockedShots"], "BLK/GP" => playerRT["blockedShotsPerGame"], 
                   "SHF/GP" => player["shiftsPerGame"], "SH%" => player["shootingPctg"]}   
      player = advance[j]
      advancedStats = {"SAF" => player["shotAttemptsFor"], "SAA" => player["shotAttemptsAgainst"], "SAD" => player["shotAttempts"], "SADB" => player["shotAttemptsBehind"], 
                       "SADA" => player["shotAttemptsAhead"], "SADC" => player["shotAttemptsClose"], "SADT" => player["shotAttemptsTied"], "RSA%" => player["shotAttemptsRelPctg"], 
                       "USAF" => player["unblockedShotAttemptsFor"], "USAA" => player["unblockedShotAttemptsAgainst"], "USAD" => player["unblockedShotAttempts"], 
                       "USADB" => player["unblockedShotAttemptsBehind"], "USADA" => player["unblockedShotAttemptsAhead"], "USADC" => player["unblockedShotAttemptsClose"], 
                       "USADT" => player["unblockedShotAttemptsTied"], "RUSA%" => player["unblockedShotAttemptsRelPctg"]}
      player = advance2[j]
      advancedPercentages = {"SA%" => player["shotAttemptsPctg"],"ZS%" => player["zoneStartPctg"], "SH+SV%" => player["shootingPlusSavePctg"], "ESSH%" => player["fiveOnFiveShootingPctg"]}
      @players[@players.length-1].push({"Info" => playerInfo, "Base Stats" => baseStats, "Advanced Stats" => advancedStats, "Advanced Percentages" => advancedPercentages})
    end
    #File.open("Skaters#{@year1+i}#{@year2+i}.txt", 'w') do |fo|
    #  fo.puts(@players[i])
    #end
  end
end

def playersCut(index)
  idHashArray = []
  for i in 0..@playerIds.length-1
    idHashArray.push(@playerIds[i].map {|x| [x,true]}.to_h)
  end
  for i in 0..@playerIds.length-1
    for j in 0..@players[i].length-1
      if (!(idHashArray[index].has_key?(@players[i][j]['Info']['ID'])))
        @players[i][j] = "Removed"
      end
    end
    @players[i].delete("Removed")
  end
end

def getGoalieStats()
  for i in 0..2
    @goalies.push([])
    basic = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/goalies?isAggregate=false&reportType=season&isGame=false&reportName=goaliesummary&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=20")['data']
    byStrength = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/goalies?isAggregate=false&reportType=season&isGame=false&reportName=goaliebystrength&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=20")['data']
    for j in 0..basic.length-1
      player = basic[j]
      if (player["playerIsActive"] == 0)
        next
      end
      playerInfo = {"First Name" => player["playerFirstName"], "Last Name" => player["playerLastName"], "Team" => player["playerTeamsPlayedFor"], "Birth Date" => player["playerBirthDate"], 
                    "position" => player["playerPositionCode"],"ID" => player["playerId"]}
      baseStats = {"GP" => player["gamesPlayed"], "GS" => player["gamesStarted"], "W" => player["wins"], "L" => player["losses"], "OTL" => player["otLosses"], "SO" => player["shutouts"], 
                   "GAA" => player["goalsAgainstAverage"], "GA" => player["goalsAgainst"], "SA" => player["shotsAgainst"], "SV" => player["saves"], "SV%" => player["savePctg"]}
      player = byStrength[j]  
      byStrengthStats = {"ESGA" => player["evGoalsAgainst"], "ESSV%" => player["evSavePctg"], "ESSV" => player["evSaves"], "EVSA" => player["evShotsAgainst"], 
                         "PPGA" => player["ppGoalsAgainst"], "PPSV%" => player["ppSavePctg"], "PPSV" => player["ppSaves"], "PPSA" => player["ppShotsAgainst"], 
                         "SHGA" => player["shGoalsAgainst"], "SHSV%" => player["shSavePctg"], "SHSV" => player["shSaves"], "SHSA" => player["shShotsAgainst"]}
      @goalies[i].push({"Info" => playerInfo, "Base Stats" => baseStats, "Saves By Strength Stats" => byStrengthStats})
    end
    #File.open("Goalies#{@year1+i}#{@year2+i}.txt", 'w') do |fo|
    #  fo.puts(@goalies[i])
    #end
  end
end
  
def skatersToCSV(group,yearComboIndex)
  cats = []
  @players[0][0].each do |category,catValues|
    puts category
    catValues.each do |stat,value|
      cats.push(stat)
    end
  end
  skaterCats = cats.join(",")
  for i in 0..@players.length-1
    yn1 = i
    yn2 = i
    if i >= yearComboIndex
      yn1 = i-2*yearComboIndex+1
      yn2 = i-yearComboIndex
    end
    File.open("Skaters#{@year1+yn1}#{@year2+yn2}#{group}.csv", 'w') do |fo|
      fo.puts(skaterCats)
      for j in 0..@players[i].length-1
        stats = []
        @players[i][j].each do |category,catValues|
          catValues.each do |stat,value|
            if value.is_a?(String)
              value.gsub!(',','/')
            end
            stats.push(value)
          end
        end
        fo.puts(stats.join(","))
      end
    end
  end
end  
  
def goaliesToCSV()
  cats = []
  @goalies[0][0].each do |category,catValues|
    catValues.each do |stat,value|
      cats.push(stat)
    end
  end
  goalieCats = cats.join(",")
  for i in 0..@goalies.length-1
    File.open("Goalies#{@year1+i}#{@year2+i}.csv", 'w') do |fo|
      fo.puts(goalieCats)
      for j in 0..@goalies[i].length-1
        stats = []
        @goalies[i][j].each do |category,catValues|
          catValues.each do |stat,value|
            if value.is_a?(String)
              value.gsub!(',','/')
            end
            stats.push(value)          
          end
        end
        fo.puts(stats.join(","))
      end
    end
  end
end
  
def deleteExtra(saveIndex,yearComboIndex)
  for i in 0..@players.length-1
    yn1 = i
    yn2 = i
    if i >= yearComboIndex
      yn1 = i-2*yearComboIndex+1
      yn2 = i-yearComboIndex
    end
    if saveIndex != i
      File.delete("Skaters#{@year1+yn1}#{@year2+yn2}P.csv") if File.exist?("Skaters#{@year1+yn1}#{@year2+yn2}P.csv")
    end
  end
end
  
@playerIds = []
@players = []
@goalies = []
@year1 = 2015
@year2 = 2016
getPlayerStats(3,0,2015,2016)
getPlayerStats(3,2,2013,2016)
@year1 = 2015
@year2 = 2016
getGoalieStats()
goaliesToCSV()

@year1 = 2015
@year2 = 2016
skatersToCSV("A",3)
playersCut(2)
skatersToCSV("P",3)
deleteExtra(5,3)
playersCut(0)
playersCut(1)
skatersToCSV("C",3)


#      elsif (!(idHash.has_key?(player['playerId'])))
 #       puts player["playerName"]
  #      next