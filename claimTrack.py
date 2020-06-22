import pandas as pd 
import numpy as np 
from datetime import datetime

def claimTrack(data, 
	duplicated_features = ['BeneID','ClmDiagnosisCode_1', 'ClmDiagnosisCode_2','ClmDiagnosisCode_3']):

	idx = data.duplicated(subset=duplicated_features,keep=False)

	dupRecords = data.loc[idx,['BeneID','ClaimID','TotalClaim','ClaimStartDt','ClaimEndDt','ClaimDays','Provider','PotentialFraud']]

	firstProvider = dupRecords.sort_values('ClaimStartDt').groupby(['BeneID']).agg({'Provider': 'first',
                                                                'ClaimStartDt': 'first'})

	df = dupRecords.merge(firstProvider, on=['BeneID','ClaimStartDt'], how = 'left')


	df.fillna(0,inplace=True)

	recipient = df.query('Provider_y==0')[['BeneID','ClaimStartDt','ClaimDays','TotalClaim','Provider_x','PotentialFraud']]
	sender = df.query('Provider_x==Provider_y')[['BeneID','ClaimEndDt','ClaimDays','TotalClaim','Provider_x','PotentialFraud']]

	claimTracker = pd.merge(sender,recipient,on='BeneID')


	claimTrack.columns = ['BeneID', 'ClaimEndDt', 'ClaimDays_S', 
	'TotalClaim_S', 'Sender', 'PotentialFraud_S',
	'ClaimStartDt', 'ClaimDays_R','TotalClaim_R', 'Receiver','PotentialFraud_R']

	claimTrack[['ClaimEndDt','ClaimStartDt']] = claimTrack[['ClaimEndDt','ClaimStartDt']].apply(pd.to_datetime)

	claimTrack['DiffLOS'] = (claimTrack['ClaimDays_S'] != claimTrack['ClaimDays_R']) + 0

	claimTracker['ClaimMultiplier'] = claimTracker['TotalClaim_R']/claimTracker['TotalClaim_S']
	## Look at difference from send to receive
	claimTrack['DayDelta'] = (claimTrack['ClaimStartDt']-claimTrack['ClaimEndDt']).dt.days

	claimTrack['SimolClaim'] = (claimTrack['ClaimStartDt'] <= claimTrack['ClaimEndDt'])+0

	return claimTracker




data = pd.read_csv('./data/combinedData.csv')
target = pd.read_csv('./data/combinedTarget.csv')

data = data.merge(target, how='left',on=['Provider','Set'])
data.drop(columns = ['Unnamed: 0_x','Unnamed: 0_y'], inplace=True)

df = claimTrack(data)

df.to_csv('./data/claimTrack.csv')