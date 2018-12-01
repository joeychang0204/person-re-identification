#!/bin/bash
##ENVIRONMENT SETTINGS; CHANGE WITH CAUTION
#SBATCH --export=NONE                #Do not propagate environment
#SBATCH --get-user-env=L             #Replicate login environment

##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=test_e400       #Set the job name to "JobExample5"
#SBATCH --time=1:00:00              #Set the wall clock limit to 1hr and 30min
#SBATCH --ntasks=28                   #Request 1 task
#SBATCH --mem=32G                  #Request 2560MB (2.5GB) per node
#SBATCH --output=TLog_Test_Market1501.%j      #Send stdout/err to "Example5Out.[jobID]"
#SBATCH --gres=gpu:2                 #Request 2 GPU per node can be 1 or 2
#SBATCH --partition=gpu              #Request the GPU partition/queue

##OPTIONAL JOB SPECIFICATIONS
#SBATCH --mail-type=ALL              #Send email on all job events

module load Python/3.5.2-intel-2017A
# source /scratch/user/s4300713/csce625/py3.5/bin/activate
source /scratch/user/joeychang0204/AI/venv/bin/activate

# CONFIGURE_PATH="/scratch/user/s4300713/csce625/part_bilinear_reid/configs/market1501.sh"
CONFIGURE_PATH="/scratch/user/joeychang0204/AI/625_Project/configs/market1501.sh"

# source /scratch/user/s4300713/csce625/625_project/paths
source /scratch/user/joeychang0204/AI/625_Project/paths
export MARKET1501_DATA_ROOT=$MARKET1501_DATA_ROOT
export MARKET1501_TRAIN_LIST=$MARKET1501_TRAIN_LIST
export DUKEMTMC_DATA_ROOT=$DUKEMTMC_DATA_ROOT
export INCEPTION_V1_PRETRAINED=$INCEPTION_V1_PRETRAINED
export CPM_PRETRAINED=$CPM_PRETRAINED

source $CONFIGURE_PATH

# Parameters
#STR_PARAM="-d market1501 -e tmp --epoch 400 --batchsize 50 --gpus 1"
STR_PARAM="-d testSet -e tmp --epoch 400 --batchsize 50 --gpus 1"
# Run!
CUDA_VISIBLE_DEVICES=$GPU_ID $PYTHON test.py $STR_PARAM
