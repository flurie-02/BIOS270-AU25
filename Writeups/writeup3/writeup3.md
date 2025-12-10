# Write-up 3: Data

**Name:** Franklin Lurie
**Student ID:** flurie
**Date:** 12/09/2025  

---

## Setup

I set up Google Cloud as described:
![Google Cloud Setup](<images/Google Cloud Setup.png>)

And Google Drive:
![Google Drive Setup](<images/Google drive steup.png>)

And BigQuery:
![BigQuery Setup](<images/BigQuery Setup.png>)

## 1. Create Local SQL Database
I tried to submit the SLURM job in the shell where I had established a localhost connection to the rclone server, but this failed for reasons (apparently it couldn't load the numpy package?). I tried to answer the following questions anyways:

- Looking at the SLURM job code, it seems like 3 tables will be created -- one for .gff files, one for protein clusters, and one for metadata.

- I think the `insert_gff_table.py` script is trying to label each of the bacterial long-read assemblies with the annotations in the `genomic.gff` file to the SQL database we are generating. However, it is possible that some (or many!) of the genes in this dataset may lack annotations. Using the `try` and `except` logic in the `insert_gff_table.py` script therefore makes sense because it will allow the SQL dataset to be generated without failing, and re-try at another time when the databse is not "locked".

## 2. Query the Created Database
I wasn't able to query the databse because I could not generate it in Part #1. However, I still attempted to fill out the TO-DOs in the script, as shown below:

```python
def get_all_record_ids(self):
    #TODO: write the query to get all unique record_id from the gff table
    query = SELECT DISTINCT record_id FROM self.db_path
    df = self.query(query)
    return df["record_id"].dropna().tolist()

def get_protein_ids_from_record_id(self, record_id):
    #TODO: write function to return list of protein_ids for a given record_id
    query = SELECT DISTINCT protein_ids FROM self.db_path WHERE gff(record_id) #I am not sure if this is the correct way to use the passed record_id in this query...
    df = self.query(query)
    return df["protein_id"].dropna().tolist()
```
Because I could not build the database, I was not able to do check the runtime, or compare with the `db.index_record_ids()` version of the code. However, it seems that the version with the uncommented `db.index_record_ids()` code uses the SQL indexes acceleration we talked about in class to greatly improve query and run times, so I expect this version will run much faster!

## 3. Upload to Google BigQuery
The CHUNK_SIZE variable breaks down the SQL file into smaller chunks of rows that are uploaded sequentially (in this case, only 500,000 rows at a time) to make sure that you don't overlad the server's RAM and crash the upload process.

I couldn't actually run this because I couldn't build the dataset, but I would create a query on BigQuery by opening my BIOS-270 project folder and clicking on "SQL Query" to create 2x new queries!

## 4. HDF5 Data
The `chunk_size = 1000` line breaks the file down into columns of length 1000 rows, with 164 total columns (specified by `n_features`). The chunk size is therefore: 1000x164. This makes sense for biological use cases like single-cell RNA sequencing, where we would want to look at the expression of specific genes (e.g., 164) across a number of samples in parallel (e.g., 1000). HDF5 files chunked as columns in this way are also greatly accelerated, as we'd discussed in class! Also, chunking will prevent overloading the RAM of our server / local machine, while allowing us to investigate a large number of features in parallel.

## 5. Practice – Combining SQL and HDF5
I skipped this part because I was not able to make the SQL database earlier!

---

## Acknowledgement
Collaborator: Ginny Paparcen