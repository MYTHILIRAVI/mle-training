FROM continuumio/miniconda3

LABEL maintainer="MYTHILIRAVI"
RUN conda install -c conda-forge backports.lzma
#RUN git config --global user.name "MYTHILIRAVI"
RUN git clone https://github.com/MYTHILIRAVI/mle-training.git

COPY deploy/conda/linux_cpu_py39.yml env.yml

RUN conda env create -n housing -f env.yml



RUN cd mle-training \
    && conda run -n housing python3 setup.py install\
    && cd src/housing\
    && conda run -n housing python3 ingest_data.py\
    && conda run -n housing python3 train.py\
    && conda run -n housing python3 score.py


RUN cd mle-training/test/unit_test\
    && conda run -n housing python3 ingest_data_test.py\
    && conda run -n housing python3 train_test.py \
    && conda run -n housing python3 score_test.py

RUN cd mle-training\
    && conda run -n housing pytest test/functional_test
