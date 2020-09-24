#echo "Starting Creation of Scratch org."
# create scratch org
sfdx force:org:create -f config/project-scratch-def.json -s -d 7 -w 60 -a scratchEATest

#Assign Analytics view only permset to user
sfdx force:user:permset:assign -n AnalyticsViewOnlyUser

#Setup some extra users
#Doing this prior to installing package so that this user can also have access to that package
sfdx force:apex:execute -f config/setupUsers.apex

#Sample: https://github.com/skipsauls/eadx
#Install package
sfdx force:package:install  -s AllUsers -p 04tB0000000cylH -w 20

#Assign AnlyTx_Permissons to user
sfdx force:user:permset:assign -n AnlyTxHack__Anlytx_Permissons

#Create dashboard from template
sfdx force:apex:execute -f config/setup.apex

# push the contents of this repo into the scratch org
#sfdx force:source:push
sfdx force:data:bulk:upsert -s Account -f ./data/Accounts2.csv -i Id -u scratchEATest
sfdx force:data:bulk:upsert -s opportunity -f ./data/Opportunity2.csv -i Id -u scratchEATest
sfdx force:data:bulk:upsert -s AnlyTxHack__Covid19WHOStats__c  -f ./data/Covid19WHOData.csv -i Id -u scratchEATest
sfdx force:data:bulk:upsert -s Case  -f ./data/Case.csv -i Id -u scratchEATest
sfdx force:apex:execute -f config/dataload.apex
#open the org
sfdx force:org:open
 echo "Press any key to exit the script"
  while [ true ] ; do
  read -t 3 -n 1
  if [ $? = 0 ] ; then
  exit ;
  else
  echo "waiting for the keypress"
  fi
  done


#Retrieve Wave template from packaging org
#sfdx force:source:retrieve -u EATemplatePkgOrg -m WaveTemplateBundle

#Deploy to packaging org
#sfdx force:source:deploy -u EATemplatePkgOrg -m WaveTemplateBundle

# create an app using the auto installer
#Create dashboard from namespaced app template
#sfdx force:data:record:create -s WaveAutoInstallRequest -v "RequestStatus='Enqueued' RequestType='WaveAppCreate' TemplateApiName='eadxtest__TemplateAppTest'"
#sfdx force:data:record:create -s WaveAutoInstallRequest -v 'RequestStatus="Enqueued" RequestType="WaveAppCreate" TemplateApiName="eadxtest__TemplateAppTest" Configuration="{"appConfiguration":{deleteAppOnConstructionFailure:true,autoShareWithLicensedUsers:true,autoShareWithOriginator:true}}"'

#How to delete this app
#https://github.com/skipsauls/eadx/blob/02b794bdaa5e76dbaeb402d14be6f4346fbfbda7/force-app/main/default/classes/eadlManagerController.cls

#Check Template to dashboard status
#sfdx force:data:record:get -s WaveAutoInstallRequest -i RECORDID_FROM_CREATE


# view the finished app
#sfdx analytics:app:list