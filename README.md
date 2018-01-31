MARCIE Smart Connector for Chiminey
==================================
MARCIE allows formal model checking of a system modeled as petri net. 

"MARCIE Smart Connector for Chiminey" allows payload parameter sweep over marcie perti net models which facilitates scheduling computes over the cloud for parallel execution.

Once "MARCIE Smart Connector" is activated in Chiminey, Chiminey portal then allows to configure and submit a MARCIE job for execution.

MARCIE Smart Connector(SC) Core Function
-----------------------------------
A payload (http://chiminey.readthedocs.io/en/latest/payload.html#payload) provides the core functionality of MARCIE SC. The payload structure of MARCIE SC is as following:

```
payload_marcie/
|--- bootstrap.sh
|--- process_payload
|    |---main.sh
     |---run.sh_template
```
The MARCIE SC needs to install MARCIE binary. During activation of MARCIE SC, the user is required to download appropriate version of marcie and place in the 'package' directory of Chiminey install. Please refer to installation steps described in https://github.com/alahmedabdullah/marcieconnector/blob/master/SETUP.md file.

"bootstrap.sh" installs all dependencies required to prepeare job execution environment for MARCIE. Following is the content of "bootstrap.sh" for MARCIE SC:    

```
#!/bin/sh
# version 2.0

WORK_DIR=`pwd`

MARCIE_PACKAGE_NAME=$(sed 's/MARCIE_PACKAGE_NAME=//' $WORK_DIR/package_metadata.txt)
mv $WORK_DIR/$MARCIE_PACKAGE_NAME /opt
cd /opt

tar -zxvf $MARCIE_PACKAGE_NAME
marcie_exe=$(whereis marcie 2>&1 | awk '/marcie/ {print $2}')
mv $marcie_exe /usr/local/bin

cd $WORK_DIR
```

The "main.sh" is a simple script that executes a shell script "run.sh". It also passes on commmand line arguments i.e. INPUT_DIR and OUTPUT_DIR to "run.sh". Following is the content of "main.sh" for MARCIE SC:

```
#!/bin/sh

INPUT_DIR=$1

cp run.sh $INPUT_DIR/run.sh

RUN_DIR=`cd "$(dirname "$0")" && pwd`

echo $RUN_DIR > mainsh.output

sh $RUN_DIR/run.sh $@

# --- EOF ---

```
The "main.sh" executes "run.sh". "cli_parametrs.txt_template" that is provied in "input_marcie" along with the MARCIE SC install. The template "cli_parameters.txt_template" need to be placed in the "Input Location" which is specified in "Create Job" tab of the Chiminey-Portal. Following is the content of "run.sh" that executes a given MARCIE job :
"

```
#!/bin/sh

INPUT_DIR=$1
OUTPUT_DIR=$2

cd $INPUT_DIR

#echo "marcie $(cat cli_parameters.txt)" >> runlog2.txt

marcie $(cat cli_parameters.txt) &> runlog.txt


cp ./*.txt ../$OUTPUT_DIR

# --- EOF ---

```
All the template tags specified in  the cli_parameters.txt_template file will be internally replaced by Chiminey with corresponding values that are passed in from "Chiminey Portal" as Json dictionary. This "cli_parameters.txt_template" is  also renamed to "cli_parameters.txt" with all template tags replaced with corresponding values. Following is the content of "cli_parameters.txt_template" 
```
{{cli_parameters}}
```
For example let us assume following shell command is used to execute a MARCIE model "test.andl":

```
marcie --net-file=test.andl --ctl-file=test.ctl --const=N=20,p=MEKPP,n=0
```  
So the "Payload parameter sweep", which is a JSON dictionary to be passed in from Chiminey-Portal's "Create Job" tab:

```
{ "cli_parameters" :  [ "--netfile=test.andl --ctl-file=test.ctl --const=N=20,p=MEKPP,n=0" ] }

```
Note that the "cli_parameters" is the tag name defined in the cli_parameters.txt_template and will be replaced by appropiate value passed in through JSON dictionary .

The Input Directory
-------------------
A connector in Chiminey system specifes a "Input Location" through "Create Job" tab of the Chimney-Portal. Files located in the "Input Location" directory is loaded to each VM for cloud execution. The content of "Input Location" may vary for different runs. Chiminey allows parameteisation of the input envrionment. Any file with "_template" suffix located in the input directory is regarded as template file. Chiminey internally replaces values of the template tags based on the "payload parameter sweep" provied as Json Dictionary from "Create Job" tab in the Chiminey portal.

Configure, Create and Execute a MARCIE Job
------------------------------------------
"Create Job" tab in "Chiminey Portal" lists "sweep_marcie" form for creation and submission of marcie job. "sweep_marcie" form require definition of "Compute Resource Name" and "Storage Location". Appropiate "Compute Resource" and "Storage Resource" need to be defined  through "Settings" tab in the "Chiminey portal".

Payload Parameter Sweep
-----------------------
Payload parameter sweep for "MARCIE Smart Connector" in Chiminey System may be performed by specifying appropiate JSON dictionary in "Payload parameter sweep" field  of the "sweep_marcie" form. An example JSON dictionary to run internal sweep for the "test.andl" could be as following:

```
{"cli_parameters" :  [ "--net-file=test.andl --ctl-file=test.ctl --const=N=20,p=MEKPP,n=0", "--net-file=erk_ma_N.andl --rev-check --live-net-check --const=N=20", " --config=experiment.cnf" ] }
``` 
Above would create three individual process. To allocate maximum two cloud VMs - thus execute two MARCIE job in the same VM,  input fields in "Cloud Compute Resource" for "sweep_marcie" form has to be:

```
Number of VM instances : 2
Minimum No. VMs : 1
```
