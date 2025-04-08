#!/bin/bash
set -euo pipefail

ORIGINAL_MODEL="meta-llama/Llama-3.2-1B-Instruct"
GGUF_MODEL="/home/jeromeku/.cache/huggingface/hub/models--bartowski--Llama-3.2-1B-Instruct-GGUF/snapshots/067b946cf014b7c697f3654f621d577a3e3afd1c/Llama-3.2-1B-Instruct-IQ4_XS.gguf"
MODEL_CONFIG_PATH="/home/jeromeku/.cache/huggingface/hub/models--meta-llama--Llama-3.2-1B-Instruct/snapshots/9213176726f574b556790deb65791e0c5aa438b6/config.json"
MODEL=$GGUF_MODEL
TASK="mmlu_high_school_geography"
PREDICT_ONLY=true

# lm_eval [-h] [--model MODEL] [--tasks task1,task2] [--model_args MODEL_ARGS] [--num_fewshot N] [--batch_size auto|auto:N|N] [--max_batch_size N] [--device DEVICE] [--output_path DIR|DIR/file.json] [--limit N|0<N<1] [--use_cache DIR] [--cache_requests {true,refresh,delete}] [--check_integrity] [--write_out] [--log_samples] [--system_instruction SYSTEM_INSTRUCTION]
#                [--apply_chat_template [APPLY_CHAT_TEMPLATE]] [--fewshot_as_multiturn] [--show_config] [--include_path DIR] [--gen_kwargs GEN_KWARGS] [--verbosity CRITICAL|ERROR|WARNING|INFO|DEBUG] [--wandb_args WANDB_ARGS] [--wandb_config_args WANDB_CONFIG_ARGS] [--hf_hub_log_args HF_HUB_LOG_ARGS] [--predict_only] [--seed SEED] [--trust_remote_code] [--confirm_run_unsafe_code]
#                [--metadata METADATA]
            # hub_results_org (str): The Hugging Face organization to push the results to. If not provided, the results will be pushed to the owner of the Hugging Face token.
            # hub_repo_name (str): The name of the Hugging Face repository to push the results to. If not provided, the results will be pushed to `lm-eval-results`.
            # details_repo_name (str): The name of the Hugging Face repository to push the details to. If not provided, the results will be pushed to `lm-eval-results`.
            # result_repo_name (str): The name of the Hugging Face repository to push the results to. If not provided, the results will not be pushed and will be found in the details_hub_repo.
            # push_results_to_hub (bool): Whether to push the results to the Hugging Face hub.

HF_HUB_LOG_ARGS="hub_results_org=jeromeku,details_repo_name=lm_evals_details,push_samples_to_hub=true,push_results_to_hub=true"
OUTPUT_PATH="./test_output"
CMD="lm_eval --model vllm --model_args pretrained=$MODEL,dtype=auto,original_model_id=$ORIGINAL_MODEL,model_config_path=$MODEL_CONFIG_PATH \
--tasks $TASK \
--log_samples \
--write_out \
--limit 5 \
--output_path $OUTPUT_PATH \
--verbosity DEBUG \
--show_config"

if [ "$PREDICT_ONLY" = true ]; then
    CMD="$CMD --predict_only"
fi
echo $CMD
eval $CMD 2>&1 | tee debug.log
