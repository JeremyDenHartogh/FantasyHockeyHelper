import pandas
import statistics
import numpy as np
from pandas.plotting import scatter_matrix
import matplotlib.pyplot as plt
from sklearn import model_selection
from sklearn import linear_model

def train_goals():
    xP = arrayX[:,[3,8,17,21,53,56,84]]
    yP = arrayY[:,7]
    XPred = arrayP[:,[3,8,17,21,53,56,84]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Goals")
    for i in range (0,len(predictions)):
        if (predictions[i] < 0):
    	    print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Goal Prediction: " + str((predictions[i]).round().astype(int)))
    	    predictions[i] = 0
    	
def train_gpg():
    xP = arrayX[:,[3,8,17,21,53,65,84]]
    yP = arrayY[:,8]
    XPred = arrayP[:,[3,8,17,21,53,65,84]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Goals Per Game")
    for i in range (0,len(predictions)):
        if (predictions[i] < 0):
        	print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Goal Prediction: " + str((predictions[i]*82).round().astype(int)))
        	predictions[i] = 0

def train_assists():
    xP = arrayX[:,[3,11,17,55]]
    yP = arrayY[:,9]
    XPred = arrayP[:,[3,11,17,55]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Assists")
    for i in range (0,len(predictions)):
        if (predictions[i] < 0):
    	    print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Points Prediction: " + str(predictions[i].round().astype(int)))
    	    predictions[i] = 0

def train_powerplaypoints():
    xP = arrayX[:,[6,7,9,11,13,16,18,20,21,22,39,40,54,61,62,81,83]]
    yP = arrayY[:,11]
    XPred = arrayP[:,[6,7,9,11,13,16,18,20,21,22,39,40,54,61,62,81,83]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("PowerplayPoints")
    for i in range (0,len(predictions)):
    	print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Points Prediction: " + str(predictions[i].round().astype(int)))
	
def train_plusminus():
    xP = arrayX[:,[6,7,9,11,13,16,18,20,21,22,39,40,54,61,62,81,83]]
    yP = arrayY[:,11]
    XPred = arrayP[:,[6,7,9,11,13,16,18,20,21,22,39,40,54,61,62,81,83]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("PlusMinus")
    for i in range (0,len(predictions)):
    	print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Points Prediction: " + str(predictions[i].round().astype(int)))
	
def train_shots():
    xP = arrayX[:,[6,7,9,11,13,16,18,20,21,22,39,40,54,61,62,81,83]]
    yP = arrayY[:,11]
    XPred = arrayP[:,[6,7,9,11,13,16,18,20,21,22,39,40,54,61,62,81,83]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Shots")
    for i in range (0,len(predictions)):
    	print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Points Prediction: " + str(predictions[i].round().astype(int)))
	
def train_hits():
    xP = arrayX[:,[6,7,9,11,13,16,18,20,21,22,39,40,54,61,62,81,83]]
    yP = arrayY[:,11]
    XPred = arrayP[:,[6,7,9,11,13,16,18,20,21,22,39,40,54,61,62,81,83]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Hits")
    for i in range (0,len(predictions)):
    	print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Points Prediction: " + str(predictions[i].round().astype(int)))


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
url = "Skaters20172018A.csv"
ds1718A = pandas.read_csv(url)
url = "Skaters20152018P.csv"
ds1518P = pandas.read_csv(url)

# Split-out validation dataset
array1516 = ds1516.values
array1617 = ds1617.values
array1718 = ds1718.values
array1316 = ds1316.values
array1417 = ds1417.values
array1518 = ds1518.values
array1718A = ds1718A.values
array1518P = ds1518P.values

arrayX1 =  np.concatenate((array1516, array1316), axis=1)
arrayX2 =  np.concatenate((array1617, array1417), axis=1)
arrayX =  np.concatenate((arrayX1, arrayX2), axis=0)
arrayY = np.concatenate((array1617, array1718), axis=0)
arrayP =  np.concatenate((array1718A, array1518P), axis=1)

LR = linear_model.LinearRegression()
#train_goals()
#train_gpg()
train_assists()
#train_powerplaypoints()
#train_plusminus()
#train_shots()
#train_hits()