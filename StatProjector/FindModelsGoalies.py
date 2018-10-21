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
		value = pred[i]
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
	N = 0
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
		N = len(predictions)
	trials = float(len(meanErrors))
	R2 = averageR2/trials
	adjR2 = 1 - (((1 - R2)*(N-1))/(N-p-1))
	if (adjR2 > printThreshold):
		print ("Average MSE: " + str(averageMSE/trials))
		print ("Average Variance (R^2): " + str(R2))
		print ("Average Adjusted R^2: " + str(adjR2))
		print ("Average Explained Variance Score: " + str(averageEVS/trials))
		print ("Average Mean-Error: " + str(sum(meanErrors)/trials))
		print ("Average Median-Error: " + str(sum(medianErrors)/trials))
		print ("Median Mean-Error: " + str(statistics.median(meanErrors)))
		print ("Median Median-Error: " + str(statistics.median(medianErrors)))

	
	
def train_wins():
	#indexs = [3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,32,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57]
	indexs = [3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,32,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57]
	for j in range (0,48):
		print (indexs[j])
		X = arrayX[:,[8,45,indexs[j]]]
		Y = arrayY[:,8]
		train_model(X,Y,400,0.23)
	#0.260
	
def train_goalsagainstaverage():
	#indexs = [3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,32,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57]
	indexs = [3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,32,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57]
	for j in range (0,48):
		print (indexs[j])
		X = arrayX[:,[indexs[j]]]
		Y = arrayY[:,12]
		train_model(X,Y,200,0)
	#0.000

def train_shotsagainst():
	#indexs = [3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,32,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57]
	indexs = [3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,32,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57]
	for j in range (0,1):
		print (indexs[j])
		X = arrayX[:,[9,23]] #14,15,16,43,44,45?
		Y = arrayY[:,14]
		train_model(X,Y,2000,0.2)
	#0.242
	
def train_saves():
	#indexs = [3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,32,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57]
	indexs = [3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,32,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57]
	for j in range (0,48):
		print (indexs[j])
		X = arrayX[:,[23,indexs[j]]]
		Y = arrayY[:,15]
		train_model(X,Y,400,0.25)
	#0.242

def train_savepercentage():
	#indexs = [3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,32,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57]
	indexs = [3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,32,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57]
	for j in range (0,48):
		print (indexs[j])
		X = arrayX[:,[indexs[j]]]
		Y = arrayY[:,16]
		train_model(X,Y,200,0)
	#0.000
	
def train_shutouts():
	#indexs = [3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,32,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57]
	indexs = [3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,32,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57]
	for j in range (0,48):
		print (indexs[j])
		X = arrayX[:,[11,23]]
		Y = arrayY[:,11]
		train_model(X,Y,200,0.0)
	#0.000

url = "Goalies20132016C.csv"
ds1316 = pandas.read_csv(url)
url = "Goalies20142017C.csv"
ds1417 = pandas.read_csv(url)
url = "Goalies20152018C.csv"
ds1518 = pandas.read_csv(url)
url = "Goalies20152016C.csv"
ds1516 = pandas.read_csv(url)
url = "Goalies20162017C.csv"
ds1617 = pandas.read_csv(url)
url = "Goalies20172018C.csv"
ds1718 = pandas.read_csv(url)

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
#train_wins()
train_goalsagainstaverage()
#train_savepercentage()
#train_shotsagainst()
#train_saves()
#train_shutouts()