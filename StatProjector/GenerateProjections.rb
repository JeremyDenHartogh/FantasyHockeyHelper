require 'matrix'
require 'csv'
require 'ruby_linear_regression'

#Set all your variables in Ruby
x_data = []
y_data = []
# Load data from CSV file into two arrays - one for independent variables X (x_data) and one for the dependent variable y (y_data)
CSV.foreach("Skaters20152016.csv", :headers => true) do |row|
  # Each row contains square feet for property and living area like this: [ SQ FEET PROPERTY, SQ FEET HOUSE ]  
  x_data.push( [row[6].to_i])
  y_data.push( row[8].to_i )
end
CSV.foreach("Skaters20162017.csv", :headers => true) do |row|
  # Each row contains square feet for property and living area like this: [ SQ FEET PROPERTY, SQ FEET HOUSE ]  
  x_data.push( [row[6].to_i] )
  y_data.push( row[8].to_i )
end
CSV.foreach("Skaters20172018.csv", :headers => true) do |row|
  # Each row contains square feet for property and living area like this: [ SQ FEET PROPERTY, SQ FEET HOUSE ]  
  x_data.push( [row[6].to_i])
  y_data.push( row[8].to_i )
end
puts x_data[0]
puts y_data[0]

# Create regression model
linear_regression = RubyLinearRegression.new

# Load training data
linear_regression.load_training_data(x_data, y_data)

# Train the model using the normal equation
#puts linear_regression.train_normal_equation
puts linear_regression.train_gradient_descent(0.001, 2000, false)

# Output the cost
puts "Trained model with the following cost fit #{linear_regression.compute_cost}"

# Predict the price of a 2000 sq feet property with a 1500 sq feet house
prediction_data = [16]
predicted_price = linear_regression.predict(prediction_data)
puts "Predicted points: #{predicted_price.round}"

prediction_data = [10000]
predicted_price = linear_regression.predict(prediction_data)
puts "Predicted points: #{predicted_price.round}"
prediction_data = [33]
predicted_price = linear_regression.predict(prediction_data)
puts "Predicted points: #{predicted_price.round}"
prediction_data = [17]
predicted_price = linear_regression.predict(prediction_data)
puts "Predicted points: #{predicted_price.round}"