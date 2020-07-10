import pandas as pd 
import numpy as np 
from datetime import datetime
import os

try:
    os.mkdir('./data')
except:
    pass

try:
    os.mkdir('./data/provData')
except:
    pass

def provData(data, target):
	'''
	Creates aggregate provider dataframe
	'''
	
	#################################################################################
	## Number of Unique Inpatients and Outpatients
	p = data.groupby(['Provider','Status']).agg({
	    'Age': 'mean',
	    'Gender' : 'mean', # proportion of claims involving males (Gender=1) (not unique to Beneificiaries)
	    'BeneID':'nunique',
	    'ClaimID' : 'count',
	    'State' : 'nunique',
	    'AttendingPhysician': 'nunique',
	    'OperatingPhysician': 'nunique',
	    'OtherPhysician': 'nunique',
	    'NumProc': 'mean',
	    'NumDiag' : 'mean',
	    'NumChronics': 'mean',
	    'InscClaimAmtReimbursed' : 'mean',
	    'DeductibleAmtPaid' : 'mean',
	    'ClaimDays' : 'mean',
	    'WhetherDead': 'mean', # proportion of dead patients (might need to take negative log to get anything large)
	    'Alzheimer' : 'mean',
	    'HeartFailure': 'mean', 
	    'KidneyDisease' : 'mean',
	    'Cancer': 'mean', 
	    'ObstrPulmonary': 'mean',
	    'Depression': 'mean', 
	    'Diabetes': 'mean', 
	    'IschemicHeart': 'mean', 
	    'Osteoporasis': 'mean',
	    'RheumatoidArthritis': 'mean',
	     'Stroke': 'mean'}).reset_index().pivot_table(
	    values=[
	    'Age',
	    'Gender',
	    'BeneID',
	    'ClaimID',
	    'State',
	    'AttendingPhysician',
	    'OperatingPhysician',
	    'OtherPhysician',
	    'NumProc',
	    'NumDiag', 
	    'NumChronics',
	    'InscClaimAmtReimbursed', 
	    'DeductibleAmtPaid', 
	    'ClaimDays',
	    'WhetherDead', 'Alzheimer',
	    'HeartFailure',
	    'KidneyDisease',
	    'Cancer',
	    'ObstrPulmonary',
	    'Depression', 
	    'Diabetes',
	    'IschemicHeart',
	    'Osteoporasis',
	    'RheumatoidArthritis',
	     'Stroke'], 
	    index = 'Provider', 
	    columns='Status').fillna(0)

	p = p.reset_index()
	p.columns = p.columns.map('_'.join)

	#p = pd.merge(p,d, left_on = ['Provider'], right_on = ['Provider_'], how='left')




	#p['logClaim'] = np.log(p['ClaimID'])
	#p['logBene'] = np.log(p['BeneID'])

	#################################################################################
	#####
	# Create ranges 
	def rangeFunc(feature):
		return max(feature) - min(feature)

	p_range = data.groupby(['Provider','Status']).agg({
	        'NumProc': rangeFunc,
	        'NumDiag' : rangeFunc,
	        'NumChronics': rangeFunc,
	        'InscClaimAmtReimbursed' : rangeFunc,
	        'ClaimDays' : rangeFunc
	        }).reset_index().pivot_table(
	        values=['NumProc','NumDiag','NumChronics','InscClaimAmtReimbursed','ClaimDays'], 
	        index = ['Provider'], 
	        columns=['Status']).fillna(0)

	p_range = p_range.reset_index()
	p_range.columns = p_range.columns.map('_'.join)
	p_range.columns += '_Range'
	p = pd.merge(p,p_range, left_on = ['Provider_'], right_on = ['Provider__Range'], how='left')

	#################################################################################
	# Number of Unique Doctors Associated With Provider
	# docs = data.melt(
	# 	id_vars = 'Provider', 
	# 	value_vars = ['AttendingPhysician','OperatingPhysician','OtherPhysician'], 
	# 	var_name='Type', 
	# 	value_name='Doctor').dropna(axis=0)

	# docs = docs[['Provider','Doctor']].drop_duplicates()

	# p['Doctors'] = docs.groupby('Provider')['Doctor'].count().values

	p = pd.merge(p, target, left_on = ['Provider_'], right_on = ['Provider'], how = 'left')

	#################################################################################
	# Rename columns. Be careful if you add a feature make sure to put the new name in the right place!
	#provData.columns = ['Provider','Set', 'Patients','Claims','States','Doctors','Fraud']

	p.drop(columns = ['Provider_','Provider__Range'], inplace=True)
	
	## Reorder columns - but not working on my machine 
	# cols = p.columns.tolist()
	# cols = cols[-1:] + cols[:-1]

	# p = p[cols]


	#################################################################################
	## Get Network Data and Integrate
	docNet = pd.read_csv('./data/prodocNet.csv')
	patNet = pd.read_csv('./data/propatNet.csv')

	netMerge = pd.merge(docNet, patNet, on = 'Provider', how = 'inner')

	p = pd.merge(p, netMerge, on = ['Provider'], how = 'left')

	#################################################################################


	x_train = p[p.Set == 'Train'].drop(columns = ['Set'])
	x_train['PotentialFraud'] = (x_train['PotentialFraud'] == 'Yes') + 0 # Convert to binary
	x_test = p[p.Set == 'Test'].drop(columns = ['Set','PotentialFraud'])

	x_train.to_csv('./data/provData/x_train_inout.csv')
	x_test.to_csv('./data/provData/x_test_inout.csv')
	return



data = pd.read_csv('./data/combinedData.csv')
target = pd.read_csv('./data/combinedTarget.csv')

provData(data,target)