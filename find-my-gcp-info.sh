#!/usr/bin/bash

#
# Hello, this is to be run in the Google Cloud "Cloud Shell"
# This will collect information about projects, service accounts, 
#     VMs, storage, and GKE clusters.
#  All data is written to a local file for downloading and using as you see fit
#      based on the file structure listed in the INIT section (csv or json)
#
# This does not change any Google Cloud settings, but it does write files
#      in the local Cloud Shell path when you run this file.
#
# Don't forget to make this file executable
#      chmod 755 find-my-gcp-info.sh
#


######################################################################
# INIT - just setting a few things... boring but needed
######################################################################
prefix="gcp_"    # Prepend to all the files to help organize output
mytype="csv"     # csv or json


######################################################################
# Find all projects
######################################################################
echo Finding all the projects in your organization
myfilename=${prefix}projects.${mytype}
gcloud projects list --format="${mytype}(project_id,name,project_number)" > ${myfilename}
echo Writing data to file: ${myfilename}


######################################################################
# Loop through all project to list all service accounts
######################################################################
echo Finding all the service accounts across all projects
myfilename=${prefix}service-accounts.${mytype}
for i in `gcloud projects list --format="get(name)"`
do
	gcloud iam service-accounts list --format="${mytype}(name,project_id)" --project $i >> ${myfilename}
done
echo Writing data to file: ${myfilename}


######################################################################
# Loop through all project to list all Compute (VMs)
######################################################################
echo Finding all Compute machines across all projects
myfilename=${prefix}compute.${mytype}
for i in `gcloud projects list --format="get(name)"`
do 
	gcloud compute instances list --format="${mytype}( \
		name, \
		zone.basename(), \
		machinemytype.machine_type().basename(), \
		networkInterfaces[].networkIP.notnull().list():label=INTERNAL_IP, \
		networkInterfaces[].accessConfigs[0].natIP.notnull().list():label=EXTERNAL_IP, \
		status)" > ${myfilename}
done
echo Writing data to file: ${myfilename}


######################################################################
# Loop through all project to list all storage Buckets
######################################################################
echo Finding all storage Buckets across all projects
myfilename=${prefix}storage.${mytype}
for i in `gcloud projects list --format="get(name)"`
do 
	echo ${i} >> ${myfilename}
	echo "-----------------" >> ${myfilename}
	gsutil ls -p ${i} >> ${myfilename}
	echo >> ${myfilename}
done
echo Writing data to file: ${myfilename}


######################################################################
# Loop through all project to list all GKE
######################################################################
echo Finding all GKE-Kubernetes across all projects
myfilename=${prefix}gke.${mytype}
for i in `gcloud projects list --format="get(name)"`
do 
	gcloud container clusters list --project=${i} --format="${mytype}(name,location,MASTER_VERSION,MASTER_IP,MACHINE_mytype,NODE_VERSION,NUM_NODES)" >> ${myfilename}
done
echo Writing data to file: ${myfilename}


