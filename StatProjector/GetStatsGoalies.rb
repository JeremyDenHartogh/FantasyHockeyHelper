require 'rest-client'
require 'active_support/core_ext/hash'
require 'json'

def getGoalieStats(numYears,yearCombo,year1,year2)
  @year1 = year1
  @year2 = year2
  for i in 0..(numYears-1)
    @goaliesIds.push([])
    @goalies.push([])
    aggregate = "true"
    if (yearCombo == 0)
      aggregate = "false"
    end
    basic = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/goalies?isAggregate=#{aggregate}&reportType=season&isGame=false&reportName=goaliesummary&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId<=#{@year1+i+yearCombo}#{@year2+i+yearCombo}%20and%20seasonId>=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=3")['data']
    byStrength = JSON.parse(RestClient.get "http://www.nhl.com/stats/rest/goalies?isAggregate=#{aggregate}&reportType=season&isGame=false&reportName=goaliebystrength&sort=playerId&cayenneExp=gameTypeId=2%20and%20seasonId<=#{@year1+i+yearCombo}#{@year2+i+yearCombo}%20and%20seasonId>=#{@year1+i}#{@year2+i}%20and%20gamesPlayed>=3")['data']
    puts (year1 + i)
    for j in 0..basic.length-1
      player = basic[j]
      @goaliesIds[@goaliesIds.length-1].push(player["playerId"])
      playerInfo = {"First Name" => player["playerFirstName"], "Last Name" => player["playerLastName"], "Team" => player["playerTeamsPlayedFor"], "Age" => (@year2+i+yearCombo-(player["playerBirthDate"][0..4]).to_i), 
                    "position" => player["playerPositionCode"],"ID" => player["playerId"]}
      baseStats = {"GP" => player["gamesPlayed"], "GS" => player["gamesStarted"], "W" => player["wins"], "L" => player["losses"], "OTL" => player["otLosses"], "SO" => player["shutouts"], 
                   "GAA" => player["goalsAgainstAverage"], "GA" => player["goalsAgainst"], "SA" => player["shotsAgainst"], "SV" => player["saves"], "SV%" => player["savePctg"]}
      player = byStrength[j]  
      byStrengthStats = {"ESGA" => player["evGoalsAgainst"], "ESSV%" => player["evSavePctg"], "ESSV" => player["evSaves"], "EVSA" => player["evShotsAgainst"], 
                         "PPGA" => player["ppGoalsAgainst"], "PPSV%" => player["ppSavePctg"], "PPSV" => player["ppSaves"], "PPSA" => player["ppShotsAgainst"], 
                         "SHGA" => player["shGoalsAgainst"], "SHSV%" => player["shSavePctg"], "SHSV" => player["shSaves"], "SHSA" => player["shShotsAgainst"]}
      @goalies[@goalies.length-1].push({"Info" => playerInfo, "Base Stats" => baseStats, "Saves By Strength Stats" => byStrengthStats})
    end
  end
end

def goaliesCut(index)
  idHashArray = []
  for i in 0..@goaliesIds.length-1
    idHashArray.push(@goaliesIds[i].map {|x| [x,true]}.to_h)
  end
  for i in 0..@goaliesIds.length-1
    for j in 0..@goalies[i].length-1
      if (!(idHashArray[index].has_key?(@goalies[i][j]['Info']['ID'])))
        @goalies[i][j] = "Removed"
      end
    end
    @goalies[i].delete("Removed")
  end
end
  
def goaliesToCSV(group,yearComboIndex)
  cats = []
  @goalies[0][0].each do |category,catValues|
    catValues.each do |stat,value|
      cats.push(stat)
    end
  end
  goalieCats = cats.join(",")
  for i in 0..@goalies.length-1
    yn1 = i
    yn2 = i
    if i >= yearComboIndex
      yn1 = i-2*yearComboIndex+1
      yn2 = i-yearComboIndex
    end
    File.open("Goalies#{@year1+yn1}#{@year2+yn2}#{group}.csv", 'w') do |fo|
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
  for i in 0..@goalies.length-1
    yn1 = i
    yn2 = i
    if i >= yearComboIndex
      yn1 = i-2*yearComboIndex+1
      yn2 = i-yearComboIndex
    end
    if saveIndex != i
      File.delete("Goalies#{@year1+yn1}#{@year2+yn2}P.csv") if File.exist?("Goalies#{@year1+yn1}#{@year2+yn2}P.csv")
    end
  end
end
  
@goaliesIds = []
@goalies = []
@year1 = 2015
@year2 = 2016
getGoalieStats(3,0,2015,2016)
getGoalieStats(3,2,2013,2014)
@year1 = 2015
@year2 = 2016
goaliesToCSV("A",3)
goaliesCut(2)
goaliesToCSV("P",3)
deleteExtra(5,3)
goaliesCut(0)
goaliesCut(1)
goaliesToCSV("C",3)