import pandas
import statistics
import numpy as np
from pandas.plotting import scatter_matrix
import matplotlib.pyplot as plt
from sklearn import model_selection
from sklearn import datasets, linear_model
from sklearn import svm
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
		RR.fit(X_train, Y_train)
		predictions = RR.predict(X_validation)
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
	print (adjR2)
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
	X = arrayX[:,[4,6,10,19,57,61,73,88]]
	Y = arrayY[:,9]
	train_model(X,Y,2000,0.0)
	print (" ")
	#0.626
	
def train_gpg():
	print ("Goals per Game:")
	X = arrayX[:,[4,6,10,26,57,69,82,88]]
	#X = arrayX[:,[4,6,10,19,57,69,73,88]]
	Y = arrayY[:,10]
	train_model(X,Y,2000,0.0)
	print (" ")
	#0.657

def train_assists():
	print ("Assists:")
	X = arrayX[:,[4,13,19,59,80]]
	Y = arrayY[:,11]
	train_model(X,Y,2000,0.0)
	print (" ")
	#0.611
		
def train_apg():
	print ("Assists per Game:")
	#X = arrayX[:,[4,13,59,90,93]]
	X = arrayX[:,[4,6,13,43,59,93]]
	Y = arrayY[:,12]
	train_model(X,Y,2000,0.0)
	print (" ")
	#0.642
	
def train_powerplaypoints():
	print ("Powerplay:")
	X = arrayX[:,[4,14,56,64,66]]
	Y = arrayY[:,16]
	train_model(X,Y,2000,0.0)
	print (" ")
	#0.645	

def train_pppg():
	print ("Powerplay Points per Game:")
	#X = arrayX[:,[4,14,29,64,66]]
	X = arrayX[:,[4,14,17,29,61,63,73]]
	Y = arrayY[:,17]
	train_model(X,Y,2000,0.0)
	print (" ")
	#0.663
	
def train_plusminus():
	print ("Plus/Minus:")
	#X = arrayX[:,[62,84,92]]
	X = arrayX[:,[33,37,62,67]]
	Y = arrayY[:,15]
	train_model(X,Y,2000,0.0)
	print (" ")
	#0.057
	
def train_shots():
	print ("Shots:")
	X = arrayX[:,[4,13,20,66]]
	Y = arrayY[:,19]
	train_model(X,Y,2000,0.0)
	print (" ")
	#0.687

def train_spg():
	print ("Shots per Game:")
	X = arrayX[:,[4,6,14,20,26,67]]
	Y = arrayY[:,20]
	train_model(X,Y,2000,0.0)
	print (" ")
	#0.784
	
def train_hits():
	print ("Hits:")
	X = arrayX[:,[21,22,91]]
	Y = arrayY[:,21]
	train_model(X,Y,2000,0.0)
	print (" ")
	#0.669
		
def train_hpg():
	print ("Hits per Game:")
	X = arrayX[:,[22,61,69]]
	Y = arrayY[:,22]
	train_model(X,Y,2000,0.0)
	print (" ")
	#0.791
		
def train_blocks():
	print ("Blocks:")
	X = arrayX[:,[6,23,25,27,71]]
	Y = arrayY[:,23]
	train_model(X,Y,2000,0.0)
	print (" ")
	#0.755
	
def train_bpg():
	print ("Blocks per Game:")
	#X= arrayX[:,[6,24,71,90,91]]
	X = arrayX[:,[6,24,71,85,91]]
	Y = arrayY[:,24]
	train_model(X,Y,2000,0.0)
	print (" ")
	#0.874

def train_AModel():
	#X = arrayX[:,[4,14,29,64,66]]
	#0.663

	#indexs = [64,66]
	#indexs = [4,6,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,51,53,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93]
	indexs = [39]
	for j in range (0,len(indexs)):
		print (indexs[j])
		X = arrayX[:,[4,14,17,29,61,63,73]]
		Y = arrayY[:,17]
		train_model(X,Y,2000,0.0)
	#0.6629/0.6633

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
RR = linear_model.Ridge(alpha = .5)
clf = svm.SVR()
#train_goals()
train_gpg()
#train_assists()
train_apg()
#train_powerplaypoints()
train_pppg()
train_plusminus()
#train_shots()
train_spg()
#train_hits()
train_hpg()
#train_blocks()
train_bpg()
#train_AModel()