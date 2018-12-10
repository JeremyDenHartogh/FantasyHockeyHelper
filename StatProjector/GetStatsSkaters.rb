require 'rest-client'
require 'active_support/core_ext/hash'
require 'json'

# Function: Gets players stats in request years
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
    basic = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/skaters?isAggregate=#{aggregate}&reportType=season&isGame=false&reportName=skatersummary&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId<=#{@year1+i+yearCombo}#{@year2+i+yearCombo}%20and%20seasonId>=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=20")['data']
    advance = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/skaters?isAggregate=#{aggregate}&reportType=shooting&isGame=false&reportName=skatersummaryshooting&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId<=#{@year1+i+yearCombo}#{@year2+i+yearCombo}%20and%20seasonId>=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=20")['data']
    advance2 = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/skaters?isAggregate=#{aggregate}&reportType=shooting&isGame=false&reportName=skaterpercentages&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId<=#{@year1+i+yearCombo}#{@year2+i+yearCombo}%20and%20seasonId>=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=20")['data']
    realTime = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/skaters?isAggregate=#{aggregate}&reportType=season&isGame=false&reportName=realtime&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId<=#{@year1+i+yearCombo}#{@year2+i+yearCombo}%20and%20seasonId>=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=20")['data']
    averages = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/skaters?isAggregate=#{aggregate}&reportType=season&isGame=false&reportName=skaterpoints&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId<=#{@year1+i+yearCombo}#{@year2+i+yearCombo}%20and%20seasonId>=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=20")['data']
    puts (year1 + i)
    for j in 0..basic.length-1
      player = basic[j]
      #if (player["playerIsActive"] == 0)
      #  next
      #end
      @playerIds[@playerIds.length-1].push(player["playerId"])
      playerRT = realTime[j]
      playerAV = averages[j]
      posVal = 0
      if (player["playerPositionCode"].include? "D")
        posVal = 0
      else
        posVal = 1
      end
      playerInfo = {"Is Active" => player["playerIsActive"], "First Name" => player["playerFirstName"], "Last Name" => player["playerLastName"], "Team" => player["playerTeamsPlayedFor"], "Age" => (@year2+i+yearCombo-(player["playerBirthDate"][0..4]).to_i), 
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
  end
end

# Function: Cuts players from lists that are not in every list
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

# Function: converts skaters to new csv file
def skatersToCSV(group,yearComboIndex)
  cats = []
  @players[0][0].each do |category,catValues|
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

# Function: Delete unecessary csv files that were created
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
@year1 = 2015
@year2 = 2016
getPlayerStats(3,0,2015,2016)
getPlayerStats(3,2,2013,2014)
@year1 = 2015
@year2 = 2016
skatersToCSV("A",3)
playersCut(2)
skatersToCSV("P",3)
deleteExtra(5,3)
playersCut(0)
playersCut(1)
skatersToCSV("C",3)