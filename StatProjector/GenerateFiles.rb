require 'csv'
require 'rest-client'
require 'active_support/core_ext/hash'
require 'json'
require 'descriptive_statistics'

@skater_data = []
@goalie_data = []
@games_played = {}

def getData()
  CSV.foreach("SkaterProjections.csv", :headers => true) do |row|
    @skater_data.push(row)
  end
  
  CSV.foreach("GoalieProjections.csv", :headers => true) do |row|
    @goalie_data.push(row)
  end
end

def getTeams()
  for player in @skater_data
    team = JSON.parse((RestClient.get "https://statsapi.web.nhl.com/api/v1/people/#{player[5]}"))["people"][0]["currentTeam"]["name"]
    if team.include? "Canadiens"
      team = "Montreal Canadiens"
    end
    player.push(team)
    puts player
  end
  for goalie in @goalie_data
    team = JSON.parse((RestClient.get "https://statsapi.web.nhl.com/api/v1/people/#{goalie[5]}"))["people"][0]["currentTeam"]["name"]
    if team.include? "Canadiens"
      team = "Montreal Canadiens"
    end
    goalie.push(team)
    puts goalie
  end
end  

def getGamesPlayedArray()
  standings = JSON.parse((RestClient.get "https://statsapi.web.nhl.com/api/v1/standings"))["records"]#[0]["teamRecords"][0]
  for division in standings
    divisionRecords = division["teamRecords"]
    for team in divisionRecords
      teamName = team["team"]["name"]
      if teamName.include? "Canadiens"
        teamName = "Montreal Canadiens"
      end
      @games_played[teamName] = team["gamesPlayed"]
    end
  end
end

def getMidSeasonStatistics()
  for player in @skater_data
    begin
      stats = JSON.parse((RestClient.get "https://statsapi.web.nhl.com/api/v1/people/#{player[5]}/stats?stats=statsSingleSeason"))["stats"][0]["splits"][0]["stat"]
      gamesLeft = 82 - @games_played[player[player.length-1]]
      player[6] = ((player[6].to_f/82)*gamesLeft + stats["goals"]).to_i
      player[7] = ((player[7].to_f/82)*gamesLeft + stats["assists"]).to_i
      player[8] = ((player[8].to_f/82)*gamesLeft + stats["powerPlayPoints"]).to_i
      player[9] = ((player[9].to_f/82)*gamesLeft + stats["plusMinus"]).to_i
      player[10] = ((player[10].to_f/82)*gamesLeft + stats["shots"]).to_i
      player[11] = ((player[11].to_f/82)*gamesLeft  + stats["hits"]).to_i
    rescue
      gamesLeft = 82 - @games_played[player[player.length-1]]
      player[6] = ((player[6].to_f/82)*gamesLeft).to_i
      player[7] = ((player[7].to_f/82)*gamesLeft).to_i
      player[8] = ((player[8].to_f/82)*gamesLeft).to_i
      player[9] = ((player[9].to_f/82)*gamesLeft).to_i
      player[10] = ((player[10].to_f/82)*gamesLeft).to_i
      player[11] = ((player[11].to_f/82)*gamesLeft).to_i
    end
    puts player
  end
  for goalie in @goalie_data
    begin
      stats = JSON.parse((RestClient.get "https://statsapi.web.nhl.com/api/v1/people/#{goalie[5]}/stats?stats=statsSingleSeason"))["stats"][0]["splits"][0]["stat"]
      gamesLeft = 82 - @games_played[goalie[goalie.length-1]]
      goalie[6] = ((goalie[6].to_f/82)*gamesLeft + stats["gamesStarted"]).to_i
      goalie[7] = ((goalie[7].to_f/82)*gamesLeft + stats["wins"]).to_i
      goalie[9] = (((goalie[9].to_f)*gamesLeft + stats["savePercentage"]*@games_played[goalie[13]])/82).round(4)
      goalie[11] = (((goalie[11].to_f)*gamesLeft + stats["goalAgainstAverage"]*@games_played[goalie[13]])/82).round(4)
      goalie[12] = ((goalie[12].to_f/82)*gamesLeft  + stats["shutouts"]).to_i
    rescue
      gamesLeft = 82 - @games_played[goalie[goalie.length-1]]
      goalie[6] = ((goalie[6].to_f/82)*gamesLeft).to_i
      goalie[7] = ((goalie[7].to_f/82)*gamesLeft).to_i
      goalie[9] = ((goalie[9].to_f/82)*gamesLeft).to_i
      goalie[11] = ((goalie[11].to_f/82)*gamesLeft).to_i
      goalie[12] = ((goalie[12].to_f/82)*gamesLeft).to_i
    end
    puts goalie
  end
end

def generateValue()
  for player in @skater_data
    player.push(0)
  end
  for goalie in @goalie_data
    goalie.push(0)
  end
  indexs = [6,7,8,9,10,11]
  dStats = []
  fStats = []
  for index in indexs
    dStats = getAveragesForStat(index,@skater_data,"0")
    fStats = getAveragesForStat(index,@skater_data,"1")
    addStat(@skater_data,dStats,"0",index)
    addStat(@skater_data,fStats,"1",index)
  end
  indexs = [6,7,9,11,12]
  gStats = []
  for index in indexs
    gStats = getAveragesForStat(index,@goalie_data,"G")
    addStat(@goalie_data,gStats,"G",index)
  end
  
end

def getAveragesForStat(index,array,position)
  tempArr = []
  for player in array
    if (player[4] == position)
      tempArr.push(player[index])
    elsif (player[4] == position)
      tempArr.push(player[index])
    end
  end
  return [tempArr.mean,tempArr.standard_deviation]
end

def addStat(array,stats,position,index)
  for player in array
    if player[4] == position
      if (position == "G" && index == 11)
        player[player.length-1] -= ((player[index].to_f - stats[0]) / stats[1])
      elsif (position != "G" && index != 9)
        player[player.length-1] += ((player[index].to_f - stats[0]) / stats[1])
      elsif (position == "G")
        player[player.length-1] += ((player[index].to_f - stats[0]) / stats[1])
      end
    end
  end
end

def standardizeValue()
  minMax = []
  minMax = getMinMax(@skater_data,"0")
  zero(@skater_data,"0",minMax)
  minMax = getMinMax(@skater_data,"1")
  zero(@skater_data,"1",minMax)
  minMax = getMinMax(@goalie_data,"G")
  zero(@goalie_data,"G",minMax)
end

def getMinMax(array,pos)
  minimum = 1000000
  maximum = -1000000
  for player in array
    if player[4] == pos
      minimum = [player[player.length-1],minimum].min
      maximum = [player[player.length-1],maximum].max
    end
  end
  return [minimum,maximum]
end

def zero(array,pos,minMax)
  for player in array
    if player[4] == pos
      player[player.length-1] = ((player[player.length-1] + minMax[0].abs)/(minMax[0].abs+minMax[1])*100).round(2)
    end
  end
end

def loadFullCSV()
  allPlayers = []
  for player in @skater_data
    allPlayers.append([player[13],player[0],player[1],player[2],player[12],
    player[3],"","","","","",player[6],player[7],player[8],
    player[9],player[10],player[11]])
  end
  for player in @goalie_data
    allPlayers.append([player[14],player[0],player[1],player[3],player[13],
    player[4],player[6],player[7],player[9],player[11],player[12],
    "","","","","",""])
  end
  allPlayers.sort! {|a, b| b[0] <=> a[0]}
  allPlayers.unshift(["Value","First Name","Last Name","Age","Team","Position", 
  "GS","W","SV%","GAA","SO","G","A","PPP","+/-","SOG","HITS"])
  toCSV("FullProjections.csv",allPlayers)

end

def loadSkaterCSV()
  allPlayers = [["Value","First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  for player in @skater_data
    allPlayers.append([player[13],player[0],player[1],player[2],player[12],
    player[3],player[6],player[7],player[8],player[9],player[10],
    player[11]])
  end
  toCSV("PProjections.csv",allPlayers)
end

def loadGoalieCSV()
  allPlayers = [["Value","First Name","Last Name","Age","Team","Position", 
  "GS","W","SV%","GAA","SO"]]
  for player in @goalie_data
    allPlayers.append([player[14],player[0],player[1],player[3],player[13],
    player[4],player[6],player[7],player[9],player[11],player[12]])
  end
  toCSV("GProjections.csv",allPlayers)
end

def loadPositionCSV()
  dPlayers = [["Value","First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  fPlayers = [["Value","First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  cPlayers = [["Value","First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  wPlayers = [["Value","First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  lwPlayers = [["Value","First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  rwPlayers = [["Value","First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  for player in @skater_data
    if (player[4] == "0")
      dPlayers.append([player[13],player[0],player[1],player[2],player[12],
      player[3],player[6],player[7],player[8],player[9],player[10],
      player[11]])
    else
      fPlayers.append([player[13],player[0],player[1],player[2],player[12],
      player[3],player[6],player[7],player[8],player[9],player[10],
      player[11]])
      if (player[3] == "C")
        cPlayers.append([player[13],player[0],player[1],player[2],player[12],
        player[3],player[6],player[7],player[8],player[9],player[10],
        player[11]])
      else
        wPlayers.append([player[13],player[0],player[1],player[2],player[12],
        player[3],player[6],player[7],player[8],player[9],player[10],
        player[11]])
        if (player[3] == "L")
          lwPlayers.append([player[13],player[0],player[1],player[2],player[12],
          player[3],player[6],player[7],player[8],player[9],player[10],
          player[11]]) 
        else
          rwPlayers.append([player[13],player[0],player[1],player[2],player[12],
          player[3],player[6],player[7],player[8],player[9],player[10],
          player[11]]) 
        end
      end
    end
  end
  toCSV("DProjections.csv",dPlayers)
  toCSV("FProjections.csv",fPlayers)
  toCSV("CProjections.csv",cPlayers)
  toCSV("WProjections.csv",wPlayers)
  toCSV("LWProjections.csv",lwPlayers)
  toCSV("RWProjections.csv",rwPlayers)
end

def toCSV(fileName,players)
  CSV.open(fileName, "w") do |csv|
    for player in players
      csv << player
    end
  end
end

getData()
getTeams()
getGamesPlayedArray()
getMidSeasonStatistics()
generateValue()
standardizeValue()
@skater_data.sort! {|a, b| b[b.length-1] <=> a[a.length-1]}
@goalie_data.sort! {|a, b| b[b.length-1] <=> a[a.length-1]}
loadFullCSV()
loadSkaterCSV()
loadGoalieCSV()
loadPositionCSV()

puts @skater_data[0]
puts @goalie_data[0]