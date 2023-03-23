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

# Let's create and vizualize ML pipeline

We are going to create the followin ML pipeline:

![the picture](examples/example.png)

Clone this repo:
1. https://github.com/4-DS/sinara-ext-tools.git

Here you can find a simple tools for all you demands.

1. Run ```bash create_pipeline.sh```and create your pipeline structure in GitHub with as many steps as you want.
Repositories for your pipeline steps will be created.
Under the hood, each step is based on that template repository (see details at https://github.com/4-DS/step_template/blob/main/README.md).

2. Go to steps folders and define interfaces.

In each step you must define:
- inputs
- outputs
- custom_inputs
- custom_outputs
- tmp_inputs
- tmp_outputs

Inputs are some previous steps outputs.
Outputs are some results of a step.
Inputs/outputs are formed base on a special run name which is 'run-%timestamp%'
Custom inputs/outputs are some custom data with fixed path.
Tmp inputs are cache data produced from previous steps.
Tmp outputs are cache data produced from current steps.

3. Build design of your ML pipeline by running
```visualize.ipynb```

Also, you can try a ready example.

See the ready steps step1-4 of pipeline with the name 'pipeline' at:
1. https://github.com/4-DS/pipeline-step1.git
2. https://github.com/4-DS/pipeline-step2.git
3. https://github.com/4-DS/pipeline-step3.git
4. https://github.com/4-DS/pipeline-step4.git

Clone them into sinara-ext-tools folder and then simply run
```visualize.ipynb```

# Let's build production image with your model 

![the picture](examples/get_bentoservice_path.png)

Please, download the ready ML model example:

1. https://github.com/4-DS/pipeline-model_train.git

Run ```python step.dev.py```
Then pick up the entity path for your model packed as a bentoservice entity
Then run bash containerize.sh and set parameters 

Now you get an image with your model ready for intergration with your environment
