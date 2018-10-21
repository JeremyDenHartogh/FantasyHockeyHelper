import pandas
import statistics
import numpy as np
from pandas.plotting import scatter_matrix
import matplotlib.pyplot as plt
from sklearn import model_selection
from sklearn import linear_model

def train_wins():
    xP = arrayX[:,[8]]
    yP = arrayY[:,8]
    XPred = arrayP[:,[8]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Goals")
    for i in range (0,len(predictions)):
        if (predictions[i] < 0):
    	    predictions[i] = 0
        print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Goals Prediction: " + str((predictions[i]).round().astype(int)))

def train_savepercentage():
    xP = arrayX[:,[16,18,45,47]]
    yP = arrayY[:,16]
    XPred = arrayP[:,[16,18,45,47]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Saves")
    for i in range (0,len(predictions)):
        if (predictions[i] < 0):
    	    predictions[i] = 0
        print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Saves Prediction: " + str(predictions[i]))

def train_goalsagainstaverage():
    xP = arrayX[:,[21,59,67]]
    yP = arrayY[:,21]
    XPred = arrayP[:,[21,59,67]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Hits per game")
    for i in range (0,len(predictions)):
    	print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Hits Prediction: " + str((predictions[i]*82).round().astype(int)))
	
def train_shutouts():
    xP = arrayX[:,[5,22,24,26,69]]
    yP = arrayY[:,22]
    XPred = arrayP[:,[5,22,24,26,69]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Blocks")
    for i in range (0,len(predictions)):
    	print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Blocks Prediction: " + str(predictions[i].round().astype(int)))

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
url = "Goalies20172018A.csv"
ds1718A = pandas.read_csv(url)
url = "Goalies20152018P.csv"
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
train_wins()
#train_savepercentage()
#train_goalsagainstaverage()
#train_shutouts()

