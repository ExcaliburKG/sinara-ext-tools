# Getting started with Sinara ML

## Prerequisites

- Docker is up and running
- Git installed
- Unzip installed (On Linux and MacOS)

### On Windows also prepare docker with WSL integration on (skip this step if you running on MacOS or Linux)
1. Download and install latest docker desktop from https://www.docker.com/products/docker-desktop
1. Setup WSL using guide at https://learn.microsoft.com/en-us/windows/wsl/install-manual
1. If you are using PowerShell scripts, make sure Execution Policy is set to RemoteSigned using PowerShell console in Administrator mode:
```
 Set-ExecutionPolicy RemoteSigned
```

## Setup Sinara ML on your desktop

```
git clone --recursive https://github.com/4-DS/sinara-ext-tools.git
cd sinara-ext-tools
```

To run Sinara ML execute in sinara-ext-tools folder:<br>
Linux and MacOS:<br>
```
bash create.sh
bash run.sh
```
Windows (PowerShell):<br>
```
.\create.ps1
.\run.ps1
```
Open Jupyter Notebook Server at http://127.0.0.1:8888/lab in any browser.<br>
Inside Jupyter server terminal execute:<br>
```
git clone --recursive https://github.com/4-DS/step_template.git
cd step_template
```

Run 'Init_Data.ipynb' notebook to get sample data

Execute 'step.dev.py' in Jupyter server terminal: 

```
python step.dev.py
```

To stop Sinara ML instance execute in sinara-ext-tools folder:<br>
Linux and MacOS:<br>
```
bash stop.sh
```
Windows (PowerShell):<br>
```
.\stop.ps1
```
To continue using the Sinara ML execute in sinara-ext-tools folder:<br><br>
Linux and MacOS:<br>
```
bash run.sh
```
Windows (PowerShell):<br>
```
.\run.ps1
```
To remove the Sinara ML instance execute in sinara-ext-tools folder:<br>
Linux and MacOS:<br>
```
bash remove.sh
```
Windows (PowerShell):<br>
```
.\remove.ps1
```
## Notes on creating and removing Sinara ML
By default setup scripts creates docker volumes for data, code and temporary data. For day to day usage its recommended to use folder mapping on local disk.

# Sinara ML Pipeline Example
Following example shows how to build a model serving pipeline from a raw dataset to a ML-Model docker container with REST API.<br>ML-pipeline is based on Sinara framework and tools.<br> 
This example ML-model calculates house median price. Based on open data sample.<br>
Example pipeline includes 5 steps, which must be run sequentially:
1. Data Load
2. Data Preparation
3. Model Train
4. Model Evaluation
5. Model Test

## 1. Data Load
This step downloads a csv-dataset from the internet and converts it to partitioned parquet files that can be read by Apache spark later in efficient way<br>
To run the step do:
1. Clone git repository:
```
git clone --recursive https://github.com/4-DS/house_price-data_load.git
cd house_price-data_load
```
2. Run step:
```
python step.dev.py
```
## 2. Data Preparation
This step splits the dataset into train, test and evaluation sets using partitioned parquets made by the data load step<br>
To run the step do:
1. Clone git repository:
```
git clone --recursive https://github.com/4-DS/house_price-data_prep.git
cd house_price-data_prep
```
2. Run step:
```
python step.dev.py
```
## 3. Model Train
This step 
- Trains a GradientBoostingRegressor model on the train set made by the data prep step
- Packs model to a BentoService using BentoML library<br>

To run the step do:<br>

1. Clone git repository:
```
git clone --recursive https://github.com/4-DS/house_price-model_train.git
cd house_price-model_train
```
2. Run step:
```
python step.dev.py
```
## 4. Model Evaluation
This step checks quality of the model made by the model train step<br>
To run the step do:<br>

1. Clone git repository:
```
git clone --recursive https://github.com/4-DS/house_price-model_eval.git
cd house_price-model_eval
```
2. Run step:
```
python step.dev.py
```
## 5. Model Test
This step checks that bento service's REST-API (made by model train step) is working properly before it will be built into a docker image<br>
To run the step do:<br>

1. Clone git repository:
```
git clone --recursive https://github.com/4-DS/house_price-model_train.git
cd house_price-model_train
```
2. Run step:
```
python step.dev.py
```

## Model Image build
After running all 5 steps we are ready to build a docker image with REST API. To build do the following:
1. Clone or cd into sinara-ext-tools repository on the host system where docker is installed
```
git clone --recursive https://github.com/4-DS/sinara-ext-tools.git
cd sinara-ext-tools
```
2. Create docker image for model service - execute in sinara-ext-tools folder:
On linux / MacOS / WSL:
```
bash containerize.sh
```
On Windows (PowerShell):
```
./containerize.ps1
```
3. Enter a path to bento service's model.zip inside your running dev jupyter environment
4. Enter repository url to push image to (enter "local" to use local docker repository on machine where docker is installed)
5. When docker build command finishes running it will output a model image name which we'll run
6. Execute docker run command with the image name from previous step.<br>Ensure that 5000 port is free on the host system or you can choose your own port that REST Service will be available at:
```
docker run -p 0.0.0.0:5000:5000 %model_image_name%
```
7. Swagger UI of the model should be available at http://127.0.0.1:5000

