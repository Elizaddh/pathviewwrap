# pathviewwrap
The script will install all the required packages and tools and run the analysis from raw fastq files to the generation of publication quality rich pathway images. Users have to provide the phenotypic information in a phenofile with class information in the class column and first column as sample name.

Operation
This tool can detect the number of cores available for the analysis and run on multiple cores when possible. The most memory intensive part is when the tool builds the reference genome index for alignment and does the counting of the genes after alignment. We recommend using the genome index folder provided in the github page to decrease the memory requirement and run time for faster analysis for Arabidopsis thaliana and Homo Sapiens data analysis.Alternatively, when reference directory is not provided, the tools uses the latest genome and reference annotation packages to generate references. The program to build the index can take upto 1 hour(depend on HW spec) to build the index, and requires at least 160GB memory using 16 cores/threads. 


