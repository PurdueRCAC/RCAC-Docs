# Hosted Models

GenAI Studio provides open-weight models for general chat, reasoning, coding, tool use, and
image understanding. The inventory below was verified against the GenAI Studio models API on
August 31, 2026. Model availability may change as deployments are added, upgraded, or retired.

Use the model ID exactly as shown when sending an [API request](api.md). To retrieve the models
available to your account at any time, query the authenticated
`https://genai.rcac.purdue.edu/api/v1/models` endpoint or open the **All** section of the model
selector in the web interface.

This page lists the base models hosted by RCAC. Custom models that you create or that another
user shares with you may also appear in the selector and API response; their availability and
behavior depend on their Workspace configuration.

!!! tip "Start with a recommended model"
    The four vLLM-backed models are tagged **Recommended** in GenAI Studio. Use
    `gpt-oss:120b` for general reasoning, `qwen3.6:27b` for coding and agentic workflows,
    or `gemma4:26b-a4b` and `llama4:latest` when your prompt includes images.

## Recommended Models

These models run on vLLM with automatic tool selection enabled. The context limit is the
deployed limit, not the larger native limit that some upstream model cards advertise.

| Model ID | Inputs | Good for | Deployed context | Deployment |
|---|---|---|---:|---|
| `gpt-oss:120b` | Text | General-purpose and high-effort reasoning, coding, and agentic tasks | 65,536 tokens | [GPT-OSS 120B](https://huggingface.co/openai/gpt-oss-120b), MXFP4 |
| `llama4:latest` | Text, image | Multimodal reasoning, image understanding, coding, and general chat | 16,384 tokens | [Llama 4 Scout](https://huggingface.co/RedHatAI/Llama-4-Scout-17B-16E-Instruct-quantized.w4a16), W4A16 INT4 |
| `gemma4:26b-a4b` | Text, image | Multimodal reasoning, coding, structured output, and tool-based workflows | 65,536 tokens | [Gemma 4 26B-A4B](https://huggingface.co/RedHatAI/gemma-4-26B-A4B-it-FP8-dynamic), FP8 |
| `qwen3.6:27b` | Text, image | Reasoning, software development, tool use, and agentic workflows | 65,536 tokens | [Qwen 3.6 27B](https://huggingface.co/Qwen/Qwen3.6-27B-FP8), FP8 |

All four vLLM deployments support automatic tool calling and model-specific reasoning output.
For structured output through the API, vLLM models use `response_format`; Ollama models use
`format`. See [Structured Output](api.md#structured-output) for examples.

## Ollama Models

The following models run on Ollama with a maximum configured context length of 65,536 tokens.
A model with a smaller native context window may have a lower effective limit; setting a larger
server limit does not extend what the model was trained to use reliably.

The deployments use the standard tags and quantizations published in the
[Ollama model library](https://ollama.com/library). Most default tags use Q4 quantization. Two
IDs make their quantization explicit: `llama3.1:70b-instruct-q4_K_M` uses Q4_K_M and
`qwq:32b-fp16` uses FP16.

| Model family | Available model IDs | Inputs | Good for |
|---|---|---|---|
| [Code Llama](https://ollama.com/library/codellama) | `codellama:latest` | Text | Code generation, explanation, and completion |
| [DeepSeek-R1](https://ollama.com/library/deepseek-r1) | `deepseek-r1:1.5b`<br>`deepseek-r1:7b`<br>`deepseek-r1:14b`<br>`deepseek-r1:32b` | Text | Reasoning, mathematics, and step-by-step problem solving; larger variants generally provide stronger results at higher latency |
| [Devstral Small 2](https://ollama.com/library/devstral-small-2) | `devstral-small-2:latest` | Text | Repository-level coding and software-engineering agents |
| [Gemma 3](https://ollama.com/library/gemma3) | `gemma3:1b` | Text | Lightweight chat, summarization, and simple instructions |
| [Gemma 3](https://ollama.com/library/gemma3) | `gemma3:12b`<br>`gemma3:27b` | Text, image | General chat, reasoning, multilingual tasks, and image understanding |
| [GPT-OSS](https://ollama.com/library/gpt-oss) | `gpt-oss:latest` | Text | Reasoning, coding, and tool-oriented tasks in the Ollama deployment |
| [Llama 3.1](https://ollama.com/library/llama3.1) | `llama3.1:latest`<br>`llama3.1:70b-instruct-q4_K_M` | Text | General instruction following, summarization, and long-form work; use the 70B variant when response quality is more important than latency |
| [Llama 3.2](https://ollama.com/library/llama3.2) | `llama3.2:latest` | Text | Lightweight general chat and instruction following |
| [Llama 3.3](https://ollama.com/library/llama3.3) | `llama3.3:70b` | Text | High-quality multilingual chat and instruction following |
| [LLaVA](https://ollama.com/library/llava) | `llava:latest` | Text, image | Visual question answering and general image understanding |
| [MedGemma](https://ollama.com/library/medgemma) | `medgemma:27b` | Text, image | Research and experimentation involving medical text and image comprehension |
| [Mistral](https://ollama.com/library/mistral) | `mistral:latest` | Text | Fast general chat, summarization, and instruction following |
| [Phi-4](https://ollama.com/library/phi4) | `phi4:latest` | Text | Reasoning, mathematics, and compact general-purpose workflows |
| [Qwen 2.5](https://ollama.com/library/qwen2.5) | `qwen2.5:72b` | Text | General multilingual work, reasoning, and coding |
| [Qwen 3](https://ollama.com/library/qwen3) | `qwen3:1.7b`<br>`qwen3:4b`<br>`qwen3:8b`<br>`qwen3:14b`<br>`qwen3:30b`<br>`qwen3:32b` | Text | General chat, reasoning, multilingual work, and coding; smaller variants favor speed while larger variants favor quality |
| [Qwen 3 Coder](https://ollama.com/library/qwen3-coder) | `qwen3-coder:latest` | Text | Agentic coding, repository analysis, and software development |
| [Qwen 3 VL](https://ollama.com/library/qwen3-vl) | `qwen3-vl:32b` | Text, image | Document and image understanding, visual reasoning, and multimodal workflows |
| [QwQ](https://ollama.com/library/qwq) | `qwq:latest`<br>`qwq:32b-fp16` | Text | Deliberate reasoning, mathematics, and complex problem solving |

Ollama supports tool calling only when the selected model and template support it. Do not infer
tool-call compatibility from a model being visible in GenAI Studio. Test the intended workflow
before depending on it, or choose one of the recommended vLLM models with an explicitly
configured tool parser. See [Tool Calling](tool-calling.md) for the supported UI and API flows.

!!! warning "Medical model limitations"
    `medgemma:27b` is provided for research and experimentation. Model output is not medical
    advice and must not be used as a substitute for review by a qualified professional. Do not
    submit protected health information or other regulated data to GenAI Studio.

## Document Embedding Model

GenAI Studio uses [EmbeddingGemma 300M](https://huggingface.co/google/embeddinggemma-300m)
internally to create text embeddings for Knowledge Base search and retrieval. Embeddings allow
the service to find document passages that are semantically related to a prompt before sending
the relevant passages to the selected chat model.

EmbeddingGemma is not a generative chat model and does not appear in the model selector. RCAC
does not expose it as a callable model or through a standalone embeddings API. GenAI Studio
applies it automatically when processing documents uploaded through the Knowledge Base
interface.

## Practical Limitations

The context window includes the system prompt, conversation history, uploaded or retrieved
document excerpts, tool definitions and results, image tokens, and the model's response. Leave
room for the response instead of filling the entire deployed limit with input.

Quantization reduces GPU memory use and generally improves serving capacity, but it can cause a
small quality difference from the full-precision upstream model.

Model IDs ending in `:latest` are aliases rather than fixed versions. RCAC may update the model
behind an alias without changing its ID. For reproducible work, record the model ID, request
settings, date, prompt, and output; do not rely on a `:latest` alias remaining unchanged.

GenAI Studio is a shared service. Response time varies with model size, prompt length, output
length, and current demand. A larger model is not always better for a particular task. Evaluate
models with representative prompts before selecting one for a research or production workflow,
and see [API Rate Limits](api.md#rate-limits) before running concurrent workloads.

[Back to Purdue GenAI Studio](index.md)
