import pandas
import statistics
import numpy as np
from pandas.plotting import scatter_matrix
import matplotlib.pyplot as plt
from sklearn import model_selection
from sklearn import datasets, linear_model
from sklearn import svm

# Functions train_X functions train that specific statistic with the given model to generate projections
def train_goals():
    xP = arrayX[:,[4,6,10,19,57,61,73,88]]
    yP = arrayY[:,9]
    XPred = arrayP[:,[4,6,10,19,57,61,73,88]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Goals")
    for i in range (0,len(predictions)):
        if (predictions[i] < 0):
    	    predictions[i] = 0
        print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Goals Prediction: " + str((predictions[i]).round().astype(int)))
    	
def train_gpg():
    xP = arrayX[:,[4,6,10,26,57,69,82,88]]
    yP = arrayY[:,10]
    XPred = arrayP[:,[4,6,10,26,57,69,82,88]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Goals Per Game")
    count = 1
    for i in range (0,len(predictions)):
        if (predictions[i] < 0):
        	predictions[i] = 0
        if (arrayP[i][0] == 1):
            players[count].append((predictions[i]*82).round().astype(int))
            count +=1

def train_assists():
    xP = arrayX[:,[4,13,19,59,80]]
    yP = arrayY[:,11]
    XPred = arrayP[:,[4,13,19,59,80]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Assists")
    for i in range (0,len(predictions)):
        if (predictions[i] < 0):
    	    predictions[i] = 0
        print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Assists Prediction: " + str(predictions[i].round().astype(int)))

def train_apg():
    xP = arrayX[:,[4,6,13,43,59,93]]
    yP = arrayY[:,12]
    XPred = arrayP[:,[4,6,13,43,59,93]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Assists per Game")
    count = 1
    for i in range (0,len(predictions)):
        if (predictions[i] < 0):
    	    predictions[i] = 0
        if (arrayP[i][0] == 1):
            players[count].append((predictions[i]*82).round().astype(int))
            count +=1

def train_powerplaypoints():
    xP = arrayX[:,[4,14,56,64,66]]
    yP = arrayY[:,16]
    XPred = arrayP[:,[4,14,56,64,66]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("PowerplayPoints")
    for i in range (0,len(predictions)):
    	print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Powerplay Points Prediction: " + str(predictions[i].round().astype(int)))

def train_pppg():
    xP = arrayX[:,[4,14,17,29,61,63,73]]
    yP = arrayY[:,17]
    XPred = arrayP[:,[4,14,17,29,61,63,73]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("PowerplayPoints per game")
    count = 1
    for i in range (0,len(predictions)):
        if (predictions[i] < 0):
        	predictions[i] = 0
        if (arrayP[i][0] == 1):
            players[count].append((predictions[i]*82).round().astype(int))
            count +=1
	
def train_plusminus():
    xP = arrayX[:,[33,37,62,67]]
    yP = arrayY[:,15]
    XPred = arrayP[:,[33,37,62,67]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("PlusMinus")
    count = 1
    for i in range (0,len(predictions)):
        if (arrayP[i][0] == 1):
            players[count].append((predictions[i]).round().astype(int))
            count +=1
	
def train_shots():
    xP = arrayX[:,[4,13,20,66]]
    yP = arrayY[:,19]
    XPred = arrayP[:,[4,13,20,66]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Shots")
    for i in range (0,len(predictions)):
    	print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Shots Prediction: " + str(predictions[i].round().astype(int)))
    	
def train_spg():
    xP = arrayX[:,[4,6,14,20,26,67]]
    yP = arrayY[:,20]
    XPred = arrayP[:,[4,6,14,20,26,67]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Shots per game")
    count = 1
    for i in range (0,len(predictions)):
        if (predictions[i] < 0):
        	predictions[i] = 0
        if (arrayP[i][0] == 1):
            players[count].append((predictions[i]*82).round().astype(int))
            count +=1
	
def train_hits():
    xP = arrayX[:,[22,61,69]]
    yP = arrayY[:,21]
    XPred = arrayP[:,[22,61,69]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Hits")
    for i in range (0,len(predictions)):
    	print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Hits Prediction: " + str(predictions[i].round().astype(int)))
    	
def train_hpg():
    xP = arrayX[:,[22,61,69]]
    yP = arrayY[:,22]
    XPred = arrayP[:,[22,61,69]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Hits per game")
    count = 1
    for i in range (0,len(predictions)):
        if (predictions[i] < 0):
        	predictions[i] = 0
        if (arrayP[i][0] == 1):
            players[count].append((predictions[i]*82).round().astype(int))
            count +=1
	
def train_blocks():
    xP = arrayX[:,[6,23,25,27,71]]
    yP = arrayY[:,23]
    XPred = arrayP[:,[6,23,25,27,71]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Blocks")
    for i in range (0,len(predictions)):
    	print ("Name: " + str(arrayP[i][0]) + " " + str(arrayP[i][1]) + "   Blocks Prediction: " + str(predictions[i].round().astype(int)))

def train_bpg():
    xP = arrayX[:,[6,24,71,85,91]]
    yP = arrayY[:,24]
    XPred = arrayP[:,[6,24,71,85,91]]
    LR.fit(xP, yP)
    predictions = LR.predict(XPred)
    print ("Blocks per game")
    count = 1
    for i in range (0,len(predictions)):
        if (predictions[i] < 0):
        	predictions[i] = 0
        if (arrayP[i][0] == 1):
            players[count].append((predictions[i]*82).round().astype(int))
            count +=1


# import csv files with data
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

array1516 = ds1516.values
array1617 = ds1617.values
array1718 = ds1718.values
array1316 = ds1316.values
array1417 = ds1417.values
array1518 = ds1518.values
array1718A = ds1718A.values
array1518P = ds1518P.values

# concatenate 1 year and 3 year average arrays
arrayX1 =  np.concatenate((array1516, array1316), axis=1)
arrayX2 =  np.concatenate((array1617, array1417), axis=1)
arrayX =  np.concatenate((arrayX1, arrayX2), axis=0)
arrayY = np.concatenate((array1617, array1718), axis=0)
arrayP =  np.concatenate((array1718A, array1518P), axis=1)

#LR = linear_model.LinearRegression()
LR = linear_model.Ridge(alpha = .5)

players = []
count = 1

# appends headers to players list
players.append(["First Name", "Last Name", "Age", "Position", "PosVal", "ID", "G", "A", "PPP", "+/-", "SOG", "HITS"])
for i in range (0,len(arrayP)):
    if arrayP[i][0] == 1:
        players.append([arrayP[i][1],arrayP[i][2],arrayP[i][4],arrayP[i][5],arrayP[i][6],arrayP[i][7]])
        count+=1
        
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
#train_bpg()

#for i in range (0,len(players)):
#    print (players[i])

# writes players list to csv    
import csv
with open("SkaterProjections.csv","w+") as my_csv:
    csvWriter = csv.writer(my_csv,delimiter=',')
    csvWriter.writerows(players)