require 'csv'
require 'rest-client'
require 'active_support/core_ext/hash'
require 'json'

@skater_data = []
@goalie_data = []

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
    #puts player
    team = JSON.parse((RestClient.get "https://statsapi.web.nhl.com/api/v1/people/#{player[5]}"))["people"][0]["currentTeam"]["name"]
    player.push(team)
    puts player
  end
  for goalie in @goalie_data
    #puts player
    team = JSON.parse((RestClient.get "https://statsapi.web.nhl.com/api/v1/people/#{goalie[5]}"))["people"][0]["currentTeam"]["name"]
    goalie.push(team)
    puts goalie
  end
end  

def loadFullCSV()
  allPlayers = [["First Name","Last Name","Age","Team","Position", 
  "Games Played","W","SV%","GAA","SO","G","A","PPP","+/-","SOG","HITS"]]
  for player in @skater_data
    allPlayers.append([player[0],player[1],player[2],"player[12]",
    player[3],"","","","","",player[6],player[7],player[8],
    player[9],player[10],player[11]])
  end
  for player in @goalie_data
    allPlayers.append([player[0],player[1],player[3],"player[13]",
    player[4],player[6],player[7],player[9],player[11],player[12],
    "","","","","",""])
  end
  toCSV("FullProjections.csv",allPlayers)

end

def loadSkaterCSV()
  allPlayers = [["First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  for player in @skater_data
    allPlayers.append([player[0],player[1],player[2],"player[12]",
    player[3],player[6],player[7],player[8],player[9],player[10],
    player[11]])
  end
  toCSV("PProjections.csv",allPlayers)
end

def loadGoalieCSV()
  allPlayers = [["First Name","Last Name","Age","Team","Position", 
  "Games Played","W","SV%","GAA","SO"]]
  for player in @goalie_data
    allPlayers.append([player[0],player[1],player[3],"player[13]",
    player[4],player[6],player[7],player[9],player[11],player[12]])
  end
  toCSV("GProjections.csv",allPlayers)
end

def loadPositionCSV()
  dPlayers = [["First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  fPlayers = [["First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  cPlayers = [["First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  wPlayers = [["First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  lwPlayers = [["First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  rwPlayers = [["First Name","Last Name","Age","Team","Position", 
  "G","A","PPP","+/-","SOG","HITS"]]
  for player in @skater_data
    if (player[4] == 0)
      dPlayers.append([player[0],player[1],player[2],"player[12]",
      player[3],player[6],player[7],player[8],player[9],player[10],
      player[11]])
    else
      fPlayers.append([player[0],player[1],player[2],"player[12]",
      player[3],player[6],player[7],player[8],player[9],player[10],
      player[11]])
      if (player[3] == "C")
        cPlayers.append([player[0],player[1],player[2],"player[12]",
        player[3],player[6],player[7],player[8],player[9],player[10],
        player[11]])
      else
        wPlayers.append([player[0],player[1],player[2],"player[12]",
        player[3],player[6],player[7],player[8],player[9],player[10],
        player[11]])
        if (player[3] == "L")
          lwPlayers.append([player[0],player[1],player[2],"player[12]",
          player[3],player[6],player[7],player[8],player[9],player[10],
          player[11]]) 
        else
          rwPlayers.append([player[0],player[1],player[2],"player[12]",
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
#getTeams()
loadFullCSV()
loadSkaterCSV()
loadGoalieCSV()
loadPositionCSV()

puts @skater_data[0]
puts @goalie_data[0]