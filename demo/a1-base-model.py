import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

model_path = "ibm-granite/granite-4.1-8b-base"
print("Loading tokenizer and model...")
tokenizer = AutoTokenizer.from_pretrained(model_path)

device = "cuda" if torch.cuda.is_available() else "mps" if torch.backends.mps.is_available() else "cpu"
dtype = torch.bfloat16 if device in ["cuda", "mps"] else torch.float32

model = AutoModelForCausalLM.from_pretrained(
    model_path, torch_dtype=dtype, device_map="auto" if device == "cuda" else None
)
if device != "cuda":
    model = model.to(device)

prompt = "If you want to migrate a virtual machine to KubeVirt,"
print(f"Tokenizing prompt and running prediction on {device.upper()}...")
inputs = tokenizer(prompt, return_tensors="pt").to(device)
outputs = model.generate(**inputs, max_new_tokens=30)

print("\n--- BASE MODEL RAW COMPLETION OUTPUT ---")
print(tokenizer.decode(outputs[0], skip_special_tokens=True))
print("----------------------------------------")
