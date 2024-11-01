FROM bioconductor/bioconductor_docker:devel

WORKDIR /home/rstudio

COPY --chown=rstudio:rstudio . /home/rstudio/

RUN sudo apt-get update && sudo apt-get install -y samtools minimap2 aria2

RUN Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); BiocManager::install(ask=FALSE)"

RUN Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); devtools::install('.', dependencies=TRUE, build_vignettes=TRUE, repos = BiocManager::repositories())"

USER rstudio

RUN aria2c -x 16 "https://zenodo.org/records/12751214/files/filtered_sorted.bam?download=1"

RUN aria2c "https://zenodo.org/records/12751214/files/filtered_sorted.bam.bai?download=1"

RUN aria2c -x 16 "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_47/GRCh38.primary_assembly.genome.fa.gz"

# subset the genome to only include the only chr19
RUN Rscript -e "library(Biostrings); genome <- readDNAStringSet('GRCh38.primary_assembly.genome.fa.gz'); chr19 <- genome[genome$names == 'chr19']; writeXStringSet(chr19, 'subset_GRCh38.fa')"

RUN rm GRCh38.primary_assembly.genome.fa.gz

RUN aria2c -x 16 "https://zenodo.org/records/12770737/files/sce_lib10.qs?download=1"

RUN aria2c -x 16 "https://zenodo.org/records/12770737/files/sce_lib90.qs?download=1"

RUN Rscript -e "basilisk::basiliskRun(env = FLAMES:::flames_env, fun = function(){})"

USER root
