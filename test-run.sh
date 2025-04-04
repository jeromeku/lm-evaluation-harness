MODEL="meta-llama/Llama-3.2-1B-Instruct"
TASK="mmlu_high_school_geography"

lm_eval --model hf --model_args pretrained=$MODEL,dtype="bfloat16" \
--tasks $TASK \
--log_samples \
--write_out \
--limit 5 \
--output_path ./test_output \
--verbosity DEBUG 2>&1 | tee debug.log