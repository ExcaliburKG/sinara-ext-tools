# How it works

Prerequisites

- Docker is up and running
- Git installed

# Deploy an environment for a single use

```
git clone --recursive https://github.com/4-DS/sinara-ext-tools.git
cd sinara-ext-tools
```

## To make use of it, run:
```
bash create.sh
bash run.sh
```

### Go on http://127.0.0.1:8888/lab
```
git clone --recursive https://github.com/4-DS/step_template.git
cd step_template
```

### Run 'Init_Data.ipynb' to get sample data

### Run 'step.dev.py' in Terminal 

```python step.dev.py```

## To stop using it for a while, run:
```
bash stop.sh
```

## To continue using it, run:
```
bash run.sh
```

## To remove it, run:
```
bash remove.sh
```

# Pipeline quiсk conceptual intro
Our framework allows you to create and visualize ML pipelines. They consist of steps. Another word, each element of the DAG is a step. At the exit and at the entrance of each step we have entities. An entity is a dataset that is saved in the file system folder as a parquet file. Each step (component) of the pipeline is implemented as a separate Git repository. Each step is created based on a template.

ML pipeline example ml dad looks at the picture below.

![the picture](examples/example.png)

Each step is implemented as a sequence of substeps (Jupyter notebooks). Each Jupyter notebook that implements the substep contains 2 special cells at the beginning: 
1. a cell with parameters;
2. a cell with an interface. 

And the interface is a description of the inputs and outputs (entities).

# Let's create and vizualize ML pipeline

To implement the pipe in the picture above, please follow these steps:

1. Clone Sinara extenal tools repo:
```
git clone https://github.com/4-DS/sinara-ext-tools.git
```

2.Automatically create your pipeline structure in GitHub with as many steps as you want.
```
bash create_pipeline.sh
``` 

3. Go to steps folders and define interfaces.

4. Build design of your ML pipeline:
```
visualize.ipynb
```

Also, you can try a ready example:

1. Clone ready repos:

- https://github.com/4-DS/pipeline-step1.git
- https://github.com/4-DS/pipeline-step2.git
- https://github.com/4-DS/pipeline-step3.git
- https://github.com/4-DS/pipeline-step4.git

2. Copy ```visualize.ipynb``` from sinara-ext-tools repository in the folder where the steps are situaded and Run the notebook cells.

# Let's build production image with your model 

![the picture](examples/get_bentoservice_path.png)

Please, download the ready ML model example:

1. https://github.com/4-DS/pipeline-model_train.git

Run ```python step.dev.py```
Then pick up the entity path for your model packed as a bentoservice entity
Then run bash containerize.sh and set parameters 

Now you get an image with your model ready for intergration with your environment
