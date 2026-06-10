import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

model_path = "ibm-granite/granite-4.1-8b"
print("Loading tokenizer and model...")
tokenizer = AutoTokenizer.from_pretrained(model_path)

device = "cuda" if torch.cuda.is_available() else "mps" if torch.backends.mps.is_available() else "cpu"
dtype = torch.bfloat16 if device in ["cuda", "mps"] else torch.float32

model = AutoModelForCausalLM.from_pretrained(
    model_path, torch_dtype=dtype, device_map="auto" if device == "cuda" else None
)
if device != "cuda":
    model = model.to(device)

chat = [{"role": "user", "content": "How do I list virtual machine migrations?"}]
prompt = tokenizer.apply_chat_template(chat, tokenize=False, add_generation_prompt=True)

print(f"Prompt sent to network (containing template control tokens):\n{repr(prompt)}\n")
print(f"Running generation loop on {device.upper()}...")

inputs = tokenizer(prompt, return_tensors="pt").to(device)
outputs = model.generate(**inputs, max_new_tokens=40)

new_tokens = outputs[0][inputs["input_ids"].shape[-1]:]
response = tokenizer.decode(new_tokens, skip_special_tokens=True).strip()

print("\n--- INSTRUCT MODEL ALIGNED OUTPUT ---")
print(response)
print("--------------------------------------")
