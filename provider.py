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

	claimTrack = pd.read_csv('../claimTrack.csv')


	def rangeFunc(feature):
		return max(feature) - min(feature)
	p = data.groupby(['Provider']).agg({
		'Age': 'mean',
		'Gender' : 'sum', # number of men (Gender=1) (not unique to Beneificiaries)
		'BeneID':'nunique',
		'ClaimID' : 'count',
		#'State' : 'nunique',
		# 'AttendingPhysician': 'nunique',
		#'OperatingPhysician': 'nunique',
		#'OtherPhysician': 'nunique',
		#'NumProc': 'sum',
		'NumDiag' : 'mean',
		#'NumChronics': 'mean',
		'InscClaimAmtReimbursed' : 'sum',
		#'DeductibleAmtPaid' : 'mean',
		'OPAnnualReimbursementAmt':'mean',
		'IPAnnualReimbursementAmt':'mean',
		'TotalClaim': 'mean',
		'InscCovPercent': 'mean',
		'DailyCharge': 'mean',
		'DupRecord': 'sum',
		'fraudulence': 'max',
		#'ClaimDays' : 'mean',
		'WhetherDead': 'sum', # proportion of dead patients (might need to take negative log to get anything large)
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
	     'Stroke': 'mean'
		}).reset_index()

	#p['ProcRate'] = p['NumProc']/p['ClaimID']
	#p['DiagRate'] = p['NumDiag']/p['ClaimID']

	p['LargeClaims'] = p['ClaimID'] > 1300

	p_inout = data.groupby(['Provider','Status']).agg({
	    'ClaimDays': 'mean',
	    'AdmissionDays':'mean',
	    'NumProc':'mean',
	    'NumChronics':'mean',
	    'State': 'nunique'}).reset_index().pivot_table(
	    values=[
	    'ClaimDays',
	    'AdmissionDays',
	    'NumProc',
	    'NumChronics',
	    'State'], 
	    index = 'Provider', 
	    columns='Status').fillna(0)

	p_inout = p_inout.reset_index()
	p_inout.columns = p_inout.columns.map('_'.join)

	p = pd.merge(p,p_inout, left_on = ['Provider'], right_on = ['Provider_'], how='left')

	# p['logClaim'] = np.log(p['ClaimID'])
	# p['logBene'] = np.log(p['BeneID'])
	#################################################################################
	# Create ranges 
	p_range = data.groupby(['Provider']).agg({
		#'Age' : rangeFunc,
		'NumProc': rangeFunc,
		#'NumDiag' : rangeFunc,
		#'NumChronics': rangeFunc,
		#'InscClaimAmtReimbursed' : rangeFunc,
		'ClaimDays' : rangeFunc,
		'TotalClaim' : rangeFunc,
		'InscCovPercent' : rangeFunc,
		'DailyCharge' : rangeFunc,
		}).reset_index()

	p_range.columns += '_Range'
	p = pd.merge(p,p_range, left_on = ['Provider'], right_on = ['Provider_Range'], how='left')
	
	#################################################################################
	## Number of Unique Inpatients and Outpatients
	# d = data.groupby(['Provider','Status']).agg({
	# 	'ClaimID': 'count',
	# 	'BeneID' : 'nunique'}).reset_index().pivot_table(
	# 	values=['ClaimID','BeneID'], 
	# 	index = 'Provider', 
	# 	columns='Status').fillna(0)

	# d = d.reset_index()
	# d.columns = d.columns.map('_'.join)

	# p = pd.merge(p,d, left_on = ['Provider'], right_on = ['Provider_'], how='left')

	#################################################################################
	# Number of Unique Doctors Associated With Provider
	# docs = data.melt(
	# 	id_vars = 'Provider', 
	# 	value_vars = ['AttendingPhysician','OperatingPhysician','OtherPhysician'], 
	# 	var_name='Type', 
	# 	value_name='Doctor').dropna(axis=0)

	# docs = docs[['Provider','Doctor']].drop_duplicates()

	# p['Doctors'] = docs.groupby('Provider')['Doctor'].count().values
	#################################################################################
	p = pd.merge(p, target, on = ['Provider'], how = 'left')


	######
	# Rename columns. Be careful if you add a feature make sure to put the new name in the right place!
	#provData.columns = ['Provider','Set', 'Patients','Claims','States','Doctors','Fraud']

	p.drop(columns = ['Provider_Range','Provider_'], inplace=True)

	#################################################################################
	# Get Network Data and Integrate
	docNet = pd.read_csv('../prodocNet.csv')
	patNet = pd.read_csv('../propatNet.csv')

	netMerge = pd.merge(docNet, patNet, on = 'Provider', how = 'inner')



	p = pd.merge(p, netMerge, on = ['Provider'], how = 'left')
	#################################################################################
	## Check if provider is listed as receiver or sender of duplicate claims

	# receiver = claimTrack['Receiver']
	# sender = claimTrack['Sender']

	# df = claimTrack.melt(id_vars=['BeneID'], value_vars=['Sender','Receiver'],var_name='Type',value_name='Provider').groupby(['Provider','Type'])['BeneID'].count().reset_index()
	# df['Weight'] = df['Type'].apply(lambda x: 1 if x == 'Receiver' else 2)
	# df['Weight'] = df['Weight']*df['BeneID']
	# df = df.groupby('Provider')['Weight'].sum().reset_index()


	




	x_train = p[p.Set == 'Train'].drop(columns = ['Set'])
	x_train['PotentialFraud'] = (x_train['PotentialFraud'] == 'Yes') + 0 # Convert to binary
	x_test = p[p.Set == 'Test'].drop(columns = ['Set','PotentialFraud'])

	x_train.to_csv('./data/provData/x_train.csv')
	x_test.to_csv('./data/provData/x_test.csv')
	return



data = pd.read_csv('./data/combinedData.csv')
target = pd.read_csv('./data/combinedTarget.csv')

provData(data,target)