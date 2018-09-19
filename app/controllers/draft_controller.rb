class DraftController < ApplicationController
  def rankings
    @list = "All"
    csv_text = File.read(Rails.root + 'app/assets/spreadsheets/FullProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0
  end

  def center
    @list = "Center"
    csv_text = File.read(Rails.root + 'app/assets/spreadsheets/CProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end
  
  def defence
    @list = "Defence"
    csv_text = File.read(Rails.root + 'app/assets/spreadsheets/DProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end  
  
  def leftwing
    @list = "Left Wing"
    csv_text = File.read(Rails.root + 'app/assets/spreadsheets/LWProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end
  
  def rightwing
    @list = "Right Wing"
    csv_text = File.read(Rails.root + 'app/assets/spreadsheets/RWProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end  
    
  def goalie
    @list = "Goalie"
    csv_text = File.read(Rails.root + 'app/assets/spreadsheets/GProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end  
  
  def forward
    @list = "Forward"
    csv_text = File.read(Rails.root + 'app/assets/spreadsheets/FProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end
  
  def skater
    @list = "Skater"
    csv_text = File.read(Rails.root + 'app/assets/spreadsheets/PProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end  
end    