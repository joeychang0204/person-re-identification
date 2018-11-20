#!/bin/bash
##ENVIRONMENT SETTINGS; CHANGE WITH CAUTION
#SBATCH --export=NONE                #Do not propagate environment
#SBATCH --get-user-env=L             #Replicate login environment

##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=Train_Market1501       #Set the job name to "JobExample5"
#SBATCH --time=12:00:00              #Set the wall clock limit to 1hr and 30min
#SBATCH --ntasks=28                   #Request 1 task
#SBATCH --mem=32G                  #Request 2560MB (2.5GB) per node
#SBATCH --output=Log_Train_Market1501.%j      #Send stdout/err to "Example5Out.[jobID]"
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

# Download pretrained network weights
if ! [ -d pretrained ]; then
    mkdir -p pretrained
fi
if ! [ -f "pretrained/bvlc_googlenet.caffemodel.pth" ]; then
    echo "Downloading pretrained inception_v1..."
    wget "https://www.dropbox.com/s/2ljm35ztj6hllcu/bvlc_googlenet.caffemodel.pth?dl=0" -O pretrained/bvlc_googlenet.caffemodel.pth
    echo "Done!"
fi
if ! [ -f "pretrained/pose_iter_440000.caffemodel.pth" ]; then
    echo "Downloading pretrained cpm..."
    wget "https://www.dropbox.com/s/pzb3ow1793yf8dc/pose_iter_440000.caffemodel.pth?dl=0" -O pretrained/pose_iter_440000.caffemodel.pth
    echo "Done!"
fi


# Make log directory
#if [ -d $LOG_DIR ]; then
#    echo "Same experiment already exists. Change the exp name and retry!"
#    exit
#else
    mkdir -p $LOG_DIR
    cp $CONFIGURE_PATH "$LOG_DIR/args"
#fi

# Parameters
STR_PARAM="-d $DATASET -b $BATCH_SIZE -j 4 -a $ARCH --logs-dir $LOG_DIR --margin 0.2 --features $FEATURES --width $WIDTH --height $HEIGHT --crop-height $CROP_HEIGHT --crop-width $CROP_WIDTH --lr $LR --epochs $EPOCHS --dilation $DILATION --weight-decay $WEIGHT_DECAY --erasing_p 0.5"

if [ "$USE_CAFFE_SAMPLER" = true ]; then
    STR_PARAM="$STR_PARAM --caffe-sampler"
fi

# Run!
CUDA_VISIBLE_DEVICES=$GPU_ID $PYTHON train.py $STR_PARAM
