FROM us-docker.pkg.dev/deeplearning-platform-release/gcr.io/workbench-container:latest

# Ustawienie zmiennych środowiskowych
# ENV MAMBA_ROOT_PREFIX=/opt/micromamba
# ENV PATH="/opt/micromamba/envs/test/bin:$PATH"
# ENV PYTHONPATH="/opt/micromamba/envs/test/lib/python3.11/site-packages:$PYTHONPATH"
# ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
# ENV CUDA_HOME="/usr/local/cuda"
# ENV PYTHONUNBUFFERED=1
# ENV DEBIAN_FRONTEND=noninteractive

# Utworzenie nowego środowiska "test" z Pythonem 3.11
RUN micromamba create -n test -c conda-forge python=3.11 -y

# Ustawienie powłoki na micromamba z aktywowanym środowiskiem test
SHELL ["micromamba", "run", "-n", "test", "/bin/bash", "-c"]

# Instalacja wymaganych paczek
RUN micromamba install -n test -c pytorch -c nvidia -c conda-forge \
    cudatoolkit \
    jupyter \
    matplotlib=3.10.1 \
    sentence-transformers=3.4.1 \
    sentencepiece=0.2.0 \
    numpy=2.2.3 \
    pytorch-cuda=12.4 \
    pytorch=2.5.1 \
    torchvision=0.20.1 \
    torchmetrics=1.3.1 \
    transformers=4.49.0 \
    accelerate=1.4.0 \
    scikit-learn=1.6.1 \
    seaborn=0.13.2 \
    datasets=3.3.2 \
    munch=4.0.0 \
    cloudpickle=3.1.1 \
    dill=0.3.8 \
    huggingface_hub \
    google-auth=2.38.0 \
    google-cloud-sdk \
    nltk=3.9.1 \
    oauthlib=3.2.2 \
    pandas=2.2.3 \
    peft=0.14.0 \
    pyarrow=19.0.1 \
    scipy=1.15.2 \
    tokenizers=0.21.0 \
    tqdm=4.67.1 \
    -y

# Instalacja ipykernel, aby środowisko było dostępne w Jupyterze
RUN pip install ipykernel
RUN python -m ipykernel install --prefix /opt/micromamba/envs/test --name test --display-name "Test Kernel (Python 3.11)"

# Usunięcie domyślnego kernela python3 z nowego środowiska, aby uniknąć konfliktów
RUN rm -rf "/opt/micromamba/envs/test/share/jupyter/kernels/python3"
