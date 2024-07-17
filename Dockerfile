FROM bioconductor/bioconductor_docker:devel

WORKDIR /home/rstudio

COPY --chown=rstudio:rstudio . /home/rstudio/

RUN Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); BiocManager::install(ask=FALSE)"

RUN Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); devtools::install('.', dependencies=TRUE, build_vignettes=TRUE, repos = BiocManager::repositories())"

RUN wget "https://zenodo.org/records/12751214/files/filtered_sorted.bam?download=1" -O filtered_sorted.bam

RUN wget "https://zenodo.org/records/12751214/files/filtered_sorted.bam.bai?download=1" -O filtered_sorted.bam.bai

RUN wget "https://zenodo.org/records/12751214/files/subset_GRCh38.fa.gz?download=1" -O subset_GRCh38.fa.gz

RUN gunzip subset_GRCh38.fa.gz

RUN sudo apt-get update && sudo apt-get install -y samtools minimap2 && wget -O- https://github.com/attractivechaos/k8/releases/download/v1.2/k8-1.2.tar.bz2 | tar -jx
