require 'csv'
require 'rest-client'
require 'active_support/core_ext/hash'
require 'json'
require 'date'

@today = DateTime.now
@startDate = Date.new(2018, 10, 3)
@endDate = Date.new(2019, 4, 6)

def createCSV()
    teams = JSON.parse((RestClient.get "https://statsapi.web.nhl.com/api/v1/teams"))["teams"]
    teams.sort_by!{ |t| t['name'] }
    csvArray = []
    blankArray = Array.new((@endDate-@startDate).to_i + 2, 0)
    blankArray[0] = "Team"
    csvArray.append(blankArray) 
    for team in teams
        blankArray = Array.new((@endDate-@startDate).to_i + 2, 0)
        if (team["name"].include? "Canadiens")
            blankArray[0] = "Montreal Canadiens"
        else
            blankArray[0] = team["name"]
        end
        csvArray.append(blankArray) 
    end
    blankArray = Array.new((@endDate-@startDate).to_i + 2, 0)
    blankArray[0] = "N/A"
    csvArray.append(blankArray) 
    return csvArray
end

def getScheduleInfo()
    csv = createCSV()
    for i in 0..((@endDate-@startDate).to_i)
        currDay = indexToDate(i)
        csv[0][i+1] = currDay.to_s
        puts currDay.to_s
        begin
            scheduleInfo = JSON.parse((RestClient.get "https://statsapi.web.nhl.com/api/v1/schedule?date=#{currDay.to_s}"))["dates"][0]["games"]
            for game in scheduleInfo
                if game["gameType"] == "R"
                    away = game["teams"]["away"]["team"]["name"]
                    home = game["teams"]["home"]["team"]["name"]
                    if home.include? "Canadiens"
                        home = "Montreal Canadiens"
                    end
                    if away.include? "Canadiens"
                        away = "Montreal Canadiens"
                    end                    
                    for j in 0..(csv.length - 1)
                        if (csv[j][0] == away)
                            csv[j][i+1] = "at #{home}"
                        end
                        if (csv[j][0] == home)
                            csv[j][i+1] = "vs #{away}"
                        end
                    end
                end
            end
        rescue
        end
    end
    CSV.open("Schedule.csv", "w") do |csvFile|
        for row in csv
          csvFile << row
        end
    end
end


def indexToDate(index)
    return @startDate + index
end

def getWeekData()
    weeks = [["Week Number", "Start Date", "End Date","startIndex","endIndex"]]
    weeks.append(["1","2018-10-03","2018-10-14","1","12"])
    weeks.append(["2","2018-10-15","2018-10-21","13","19"])
    weeks.append(["3","2018-10-22","2018-10-28","20","26"])
    weeks.append(["4","2018-10-29","2018-11-04","27","33"])
    weeks.append(["5","2018-11-05","2018-11-11","34","40"])
    weeks.append(["6","2018-11-12","2018-11-18","41","47"])
    weeks.append(["7","2018-11-19","2018-11-25","48","54"])
    weeks.append(["8","2018-11-26","2018-12-02","55","61"])
    weeks.append(["9","2018-12-03","2018-12-09","62","68"])
    weeks.append(["10","2018-12-10","2018-12-16","69","75"])
    weeks.append(["11","2018-12-17","2018-12-23","76","82"])
    weeks.append(["12","2018-12-24","2018-12-30","83","89"])
    weeks.append(["13","2018-12-31","2019-01-06","90","96"])
    weeks.append(["14","2019-01-07","2019-01-13","97","103"])
    weeks.append(["15","2019-01-14","2019-01-20","104","110"])
    weeks.append(["16","2019-01-21","2019-02-03","111","124"])
    weeks.append(["17","2019-02-04","2019-02-10","125","131"])
    weeks.append(["18","2019-02-11","2019-02-17","132","138"])
    weeks.append(["19","2019-02-18","2019-02-24","139","145"])
    weeks.append(["20","2019-02-25","2019-03-03","146","152"])
    weeks.append(["21","2019-03-04","2019-03-10","153","159"])
    weeks.append(["22","2019-03-11","2019-03-17","160","166"])
    weeks.append(["23","2019-03-18","2019-03-24","167","173"])
    weeks.append(["24","2019-03-25","2019-04-06","174","186"])
    CSV.open("WeeksData.csv", "w") do |csvFile|
        for row in weeks
          csvFile << row
        end
    end
end



getScheduleInfo()
getWeekData()