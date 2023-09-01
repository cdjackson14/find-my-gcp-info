# How to Use 

This is to be run in the Google Cloud "Cloud Shell".

This will collect information about projects, service accounts, VMs, storage, and GKE clusters.

All data is written to local files for downloading and using as you see fit(csv or json).

## Make it Executable
Don't forget to make this file executable once it's in the Google Cloud Shell

```bash
chmod 755 find-my-gcp-info.sh
```

## Files Created
The files created will be named:
* gcp_projects.csv (or .json)
* gcp_service-accounts.csv (or .json)
* gcp_compute.csv (or .json)
* gcp_storage.csv (or .json)
* gcp_gke.csv (or .json)

## Making Changes
Edit the script to change the PREFIX and ouput type:
```bash
prefix="gcp_"    # Prepend to all the files to help organize output
mytype="csv"     # csv or json
```
