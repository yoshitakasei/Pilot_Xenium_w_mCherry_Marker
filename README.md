# Pilot_Xenium_w_mCherry_Marker
An analytical tool to be used with the 10X Xenium platform to compare transcript counts in cells expressing target markers. Code written by Yoshitaka J Sei

This tool was designed with the following considerations:

    1. A 10X Xenium In Situ run was completed and converted into a Seurat (tested on v5.1.0) object (saved as an RData or RDS file). 
    2. A post-run immunostain was done on the Xenium slide to visualize cells infected with an AAV expressing an mCherry marker.
    3. A user wants to know which gene transcripts are differentially adbundant between 2 groups within defined regions of interests where the cells were infected with an AAV.

Getting Started:

    1. Make sure that your computer has the following installed: R (this was tested on version 4.4.2), RStudio (this was tested on version 2024.12.0+467), and Xenium Explorer (tested on version 3.0.0)
    2. Download the whole repository as a .ZIP file, and extract the contents of the file into a working directory of your choice.
    3. Convert the Xenium data into a Seurat Object; use LoadXenium(path, fov="fov") where path is the address to the Xenium outputs with default filenames. Leave the Xenium Seurat Object in the step1_input_RDATA directory.
    4. Overlay the post-run stain using the Image Alignment tool in Xenium Explorer. A tutorial of how to do this can be found on the 10X Genomics website at https://www.10xgenomics.com/support/software/xenium-explorer/latest/tutorials/xe-image-alignment#prereq
    5. Export the coordinates for the tissue region of interest the Xenium Explorer application into the step2_input_coordinateCSV directory.

    - Install any necessary libraries through CRAN before executing the library commands to load them.
    - Execute the commands in the order they are given
    - Final output will be in the step5_output_selectedTranscripts directory
    - Example csv files for coordinates and cellIDs are provided to give context to the expected formats of these files. 
