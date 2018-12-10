class DraftController < ApplicationController
  # Function: View combined rankings
  def rankings
    @list = "All"
    csv_text = File.read(Rails.root + 'StatProjector/FullProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0
  end
  
  # Function: View center rankings
  def center
    @list = "Center"
    csv_text = File.read(Rails.root + 'StatProjector/CProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end
  
  # Function: View defence rankings
  def defence
    @list = "Defence"
    csv_text = File.read(Rails.root + 'StatProjector/DProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end  
  
  # Function: View left wing rankings
  def leftwing
    @list = "Left Wing"
    csv_text = File.read(Rails.root + 'StatProjector/LWProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end
  
  # Function: View right wing rankings
  def rightwing
    @list = "Right Wing"
    csv_text = File.read(Rails.root + 'StatProjector/RWProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end  
  
  # Function: View goalie rankings
  def goalie
    @list = "Goalie"
    csv_text = File.read(Rails.root + 'StatProjector/GProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end  
  
  # Function: View forward rankings
  def forward
    @list = "Forward"
    csv_text = File.read(Rails.root + 'StatProjector/FProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end
  
  # Function: View skater rankings
  def skater
    @list = "Skater"
    csv_text = File.read(Rails.root + 'StatProjector/PProjections.csv')
    @projections = CSV.parse(csv_text, :headers => true)
    @count = 0    
    render 'rankings'
  end  
end    