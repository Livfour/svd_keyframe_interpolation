#!bin/bash
noise_injection_steps=5
noise_injection_ratio=0.5

EVAL_DIR=${1:-examples}
OUT_DIR=${2:-results}
device=${3:-0}
MODEL_NAME=${4:-stabilityai/stable-video-diffusion-img2vid-xt}
CHECKPOINT_DIR=${5:-checkpoints/svd_reverse_motion_with_attnflip}

export CUDA_VISIBLE_DEVICES=$device
mkdir -p $OUT_DIR
for example_dir in $(ls -d $EVAL_DIR/*); do
    example_name=$(basename $example_dir)
    echo $example_name

    out_fn=$OUT_DIR/$example_name'.gif'
    python keyframe_interpolation.py \
        --frame1_path=$example_dir/frame1.png \
        --frame2_path=$example_dir/frame2.png \
        --pretrained_model_name_or_path=$MODEL_NAME \
        --checkpoint_dir=$CHECKPOINT_DIR \
        --noise_injection_steps=$noise_injection_steps \
        --noise_injection_ratio=$noise_injection_ratio \
        --out_path=$out_fn
done
