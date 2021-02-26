# SRU-Alma-Check-Against-OCLC
Compares WorldCat holdings against corresponding Alma IZ holdings

This SRU script compares WorldCat holdings symbols against corresponding Alma IZ holdings symbols. Records that appear in OCLC but not in Alma are candidates for subsequent batch deletion in OCLC.

This script was originally written by Lesley Lowery at the Orbis Cascade Alliance to run in a UNIX environment. To make the process more accessible to our staff and faculty, I rewrote this SRU script in Windows PowerShell, making it easier for our Technical Services staff to run it from any of the WSU Libraries’ workstations.

The script does the following: Reads a predetermined list of OCLC numbers; Uses an ALMA SRU (Search/Retrieve via URL) search string to retrieve ALMA IZ holdings; Prints results to file. If records exist, script prints and writes to file: OCLC Number, Number of Records, MMS ID, Library Name, and CarrierText.
