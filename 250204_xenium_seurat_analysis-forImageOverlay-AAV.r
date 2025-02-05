#Seurat Xenium Practice
library(Seurat)
library(tidyverse)
library(writexl)
library(data.table)
library(dplyr)

#v1.1 - changed order of pipeline to be smoother for analyzing pilot Xenium experiment that requires imaged-based cell selection

# ##### Step 1: Convert Xenium Data File into Seurat Object - comment out if completed already #####
# #define path to xenium output files
# path <- "/address/to/Xenium/outputs"
# 
# #load xenium data
# xenium.obj <- LoadXenium(path, fov = "fov")
# 
# #save xenium data as RData file
# saveRDS(xenium.obj, "XeniumPilotExample.RData")

##### Alt Step 1: If the Seurat file was already saved as an RDATA file #####
xenium.obj <- readRDS("step1_input_RDATA/XeniumPilotExample.RData")



##### Step 2: Upload all CSV with tissue section coordinates #####
coord_tissue <- read.csv("step2_input_coordinateCSV/coordinates_for_tissuesection.csv", skip = 2, stringsAsFactors = FALSE)









##### Step 3: Save cell IDs in each tissue section that meet marker threshold conditions #####
#subset xenium slide by csv coordinates
tissue <- subset(xenium.obj, cells = coord_tissue$Cell.ID)
#remove cells that have no counts
tissue <- subset(tissue, subset = nCount_Xenium > 0)

#identify cells based on marker expression
target_cell_type <- WhichCells(object = tissue, expression = Th >= 1 | Slc18a2 >= 1 | Slc6a3 >= 1, slot = "counts")

#Export cells with desired marker expression
target_cell_type <- as.data.frame(target_cell_type)
colnames(target_cell_type) <- "cell_id"
target_cell_type$group <- "InsertTissueIDHere"
write.csv(target_cell_type, "step3_output_selectedCells/target_cell_type.csv")

##### Step 4: In Xenium explorer, import the cell id csvs from Step 3, then select & export the mCherry positive cells as a csv#####
##### Step 5: Import the final cells of interest from Step 4 & extract their transcript data #####
final_cells <- read.csv("step4_input_finalCell_IDs/cells_with_targetmarker.csv", skip = 2, stringsAsFactors = FALSE)
final_cells_id <- gsub("Cell ", "", final_cells$Selection)
final_cells_id <- final_cells_id[!duplicated(final_cells_id)]
final_cells_id <- as.data.frame(final_cells_id)


xenium.obj.final_cells <- subset(xenium.obj, cells = final_cells_id$final_cells_id)
xenium.obj.final_cells_counts <- as.data.frame(xenium.obj.final_cells@assays$Xenium$counts)

xenium.obj.final_cells_counts <- xenium.obj.final_cells_counts %>%
  mutate(sum = rowSums(xenium.obj.final_cells_counts, na.rm = TRUE)) %>%
  mutate(avg = rowMeans(xenium.obj.final_cells_counts, na.rm = TRUE))


xenium.obj.final_cells_counts <- setDT(xenium.obj.final_cells_counts, keep.rownames = TRUE)
write_xlsx(xenium.obj.final_cells_counts, "step5_output_selectedTranscripts/target_cell_counts.xlsx")
