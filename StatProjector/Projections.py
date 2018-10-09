import pandas
import statistics
import numpy as np
from pandas.plotting import scatter_matrix
import matplotlib.pyplot as plt
from sklearn import model_selection
from sklearn import datasets, linear_model
from sklearn.metrics import mean_squared_error, r2_score, explained_variance_score

def getErrorValues(pred,yVal):
	count = 0
	diffArray = []
	for i in range (0,len(pred)):
		value = pred[i].round().astype(int)
		diff = abs(value-yVal[i])
		diffArray.append(diff)
		count += diff
	meanError = count/len(pred)
	medianError = statistics.median(diffArray)	
	return meanError, medianError

def train_model(X,Y,numTrials,printThreshold):
	p = len(X[0])
	meanErrors = []
	medianErrors = []
	averageMSE = 0
	averageR2 = 0
	averageEVS = 0
	for i in range (0,numTrials):
		X_train, X_validation, Y_train, Y_validation = model_selection.train_test_split(X, Y, test_size=0.2, random_state=i*1319)
		LR.fit(X_train, Y_train)
		predictions = LR.predict(X_validation)
		meanErrors.append(0)
		medianErrors.append(0)
		meanErrors[i], medianErrors[i] = getErrorValues(predictions,Y_validation)
		averageMSE += mean_squared_error(Y_validation, predictions)
		averageR2 += r2_score(Y_validation, predictions)
		averageEVS += explained_variance_score(Y_validation, predictions)
	trials = float(len(meanErrors))
	R2 = averageR2/trials
	adjR2 = 1 - (((1 - R2)*(183-1))/(183-p-1))
	if (adjR2 > printThreshold):
		print ("Average MSE: " + str(averageMSE/trials))
		print ("Average Variance (R^2): " + str(R2))
		print ("Average Adjusted R^2: " + str(adjR2))
		print ("Average Explained Variance Score: " + str(averageEVS/trials))
		print ("Average Mean-Error: " + str(sum(meanErrors)/trials))
		print ("Average Median-Error: " + str(sum(medianErrors)/trials))
		print ("Median Mean-Error: " + str(statistics.median(meanErrors)))
		print ("Median Median-Error: " + str(statistics.median(medianErrors)))

	
	
def train_goals():
	print ("Goals:")
	X = arrayX[:,[3,8,17,21,53,56,84]]
	Y = arrayY[:,7]
	train_model(X,Y,2000,0.5)
	print (" ")
		
def train_gpg():
	print ("Goals per Game:")
	X = arrayX[:,[3,8,17,21,53,65,84]]
	Y = arrayY[:,8]
	train_model(X,Y,2000,0.5)
	print (" ")

def train_assists():
	#indexs = [3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,48,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89]
	#indexs = [6,7,8,9,10,12,13,14,15,16,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,48,51,52,53,54,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89]
	indexs = [84,85,86]
	for j in range (0,3):
		print (indexs[j])
		X = arrayX[:,[3,11,17,55]]
		Y = arrayY[:,9]
		train_model(X,Y,2000,0.61)
	
def train_powerplaypoints():
	X = arrayX[:,[0,1,6,7,9,11,13,16,18,20,21,22,39,40,54,61,62,81,83]]
	Y = arrayY[:,14]
	X_train, X_validation, Y_train, Y_validation = model_selection.train_test_split(X, Y, test_size=0.10, random_state=200)
	names = X_validation[:,:2]
	X_train = X_train[:,2:]
	X_validation = X_validation[:,2:]
	LR.fit(X_train, Y_train)
	predictions = LR.predict(X_validation)
	print ("PowerplayPoints")
	getErrorValues(predictions,Y_validation)
	
def train_plusminus():
	X = arrayX[:,[0,1,6,7,9,11,13,16,18,20,21,22,39,40,54,61,62,81,83]]
	Y = arrayY[:,13]
	X_train, X_validation, Y_train, Y_validation = model_selection.train_test_split(X, Y, test_size=0.10, random_state=200)
	names = X_validation[:,:2]
	X_train = X_train[:,2:]
	X_validation = X_validation[:,2:]
	LR.fit(X_train, Y_train)
	predictions = LR.predict(X_validation)
	print ("PlusMinus")
	getErrorValues(predictions,Y_validation)
	
def train_shots():
	X = arrayX[:,[0,1,6,7,9,11,13,16,18,20,21,22,39,40,54,61,62,81,83]]
	Y = arrayY[:,16]
	X_train, X_validation, Y_train, Y_validation = model_selection.train_test_split(X, Y, test_size=0.10, random_state=200)
	names = X_validation[:,:2]
	X_train = X_train[:,2:]
	X_validation = X_validation[:,2:]
	LR.fit(X_train, Y_train)
	predictions = LR.predict(X_validation)
	print ("Shots")
	getErrorValues(predictions,Y_validation)
	
def train_hits():
	X = arrayX[:,[0,1,6,7,9,11,13,16,18,20,21,22,39,40,54,61,62,81,83]]
	Y = arrayY[:,18]
	X_train, X_validation, Y_train, Y_validation = model_selection.train_test_split(X, Y, test_size=0.10, random_state=200)
	names = X_validation[:,:2]
	X_train = X_train[:,2:]
	X_validation = X_validation[:,2:]
	LR.fit(X_train, Y_train)
	predictions = LR.predict(X_validation)
	print ("Hits")
	getErrorValues(predictions,Y_validation)

url = "Skaters20132016C.csv"
ds1316 = pandas.read_csv(url)
url = "Skaters20142017C.csv"
ds1417 = pandas.read_csv(url)
url = "Skaters20152018C.csv"
ds1518 = pandas.read_csv(url)
url = "Skaters20152016C.csv"
ds1516 = pandas.read_csv(url)
url = "Skaters20162017C.csv"
ds1617 = pandas.read_csv(url)
url = "Skaters20172018C.csv"
ds1718 = pandas.read_csv(url)
#print (dataset)
#print(dataset.shape)
#print(dataset.groupby('Team').size())

# Split-out validation dataset
array1516 = ds1516.values
array1617 = ds1617.values
array1718 = ds1718.values
array1316 = ds1316.values
array1417 = ds1417.values

arrayX1 =  np.concatenate((array1516, array1316), axis=1)
arrayX2 =  np.concatenate((array1617, array1417), axis=1)
arrayX =  np.concatenate((arrayX1, arrayX2), axis=0)

arrayY = np.concatenate((array1617, array1718), axis=0)
LR = linear_model.LinearRegression()
#train_goals()
#train_gpg()
train_assists()
#train_apg()
#train_powerplaypoints()
#train_plusminus()
#train_shots()
#train_hits()