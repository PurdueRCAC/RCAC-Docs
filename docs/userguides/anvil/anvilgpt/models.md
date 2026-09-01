# Hosted Models

AnvilGPT provides open-weight models for general chat, reasoning, coding, tool use, and image
understanding. The inventory below was verified against the AnvilGPT models API on September 1,
2026. Model availability may change as deployments are added, upgraded, or retired.

Use the model ID exactly as shown when sending an [API request](api.md). To retrieve the models
available to your account at any time, query the authenticated
`https://anvilgpt.rcac.purdue.edu/api/models` endpoint or open the **All** section of the model
selector in the web interface.

This page lists the base models hosted by RCAC. Custom models that you create or that another user
shares with you may also appear in the selector and API response; their availability and behavior
depend on their Workspace configuration.

!!! tip "Start with a recommended model"
    The four primary vLLM-backed models are tagged **Recommended** in AnvilGPT. Use
    `gpt-oss:120b` for general reasoning, `qwen3.6:27b` for coding and agentic workflows,
    or `gemma4:26b-a4b` and `llama4:latest` when your prompt includes images.

## Recommended Models

These models run on vLLM with automatic tool selection enabled. The context limit is the deployed
limit, not the larger native limit that some upstream model cards advertise.

| Model ID | Inputs | Good for | Deployed context |
|---|---|---|---:|
| [`gpt-oss:120b`](https://huggingface.co/openai/gpt-oss-120b) | Text | General-purpose and high-effort reasoning, coding, and agentic tasks | 65,536 tokens |
| [`llama4:latest`](https://huggingface.co/RedHatAI/Llama-4-Scout-17B-16E-Instruct-quantized.w4a16) | Text, image | Multimodal reasoning, image understanding, coding, and general chat | 16,384 tokens |
| [`gemma4:26b-a4b`](https://huggingface.co/RedHatAI/gemma-4-26B-A4B-it-FP8-dynamic) | Text, image | Multimodal reasoning, coding, structured output, and tool-based workflows | 262,144 tokens |
| [`qwen3.6:27b`](https://huggingface.co/Qwen/Qwen3.6-27B-FP8) | Text, image | Reasoning, software development, tool use, and agentic workflows | 262,144 tokens |

All four deployments support automatic tool calling. `gpt-oss:120b`, `gemma4:26b-a4b`, and
`qwen3.6:27b` also use model-specific reasoning parsers; `llama4:latest` does not use a separate
reasoning parser.
`gpt-oss:120b`, `llama4:latest`, and `gemma4:26b-a4b` use prefix caching.
`qwen3.6:27b` does not use prefix caching because stable support is not available in the
deployed vLLM version.

## Other vLLM Models

AnvilGPT also serves three smaller or specialized models through vLLM. They are available for
compatibility and lighter workloads, but the recommended models above provide the preferred
starting point for new work.

| Model ID | Inputs | Good for | Deployed context | Automatic tool calling |
|---|---|---|---:|---|
| [`qwen3-coder:30b`](https://huggingface.co/Qwen/Qwen3-Coder-30B-A3B-Instruct) | Text | Agentic coding, repository analysis, and software development | 4,096 tokens | Yes |
| [`qwen2.5:7b`](https://huggingface.co/Qwen/Qwen2.5-7B-Instruct) | Text | Lightweight multilingual chat, reasoning, and coding | 4,096 tokens | No |
| [`qwen3:4b`](https://huggingface.co/Qwen/Qwen3-4B) | Text | Lightweight chat, reasoning, multilingual work, and coding | 4,096 tokens | No |

The automatic tool-calling setting in this table describes the server deployment. A model without
automatic tool calling can still be useful for ordinary chat and completion requests.

For structured output through the API, all vLLM models use `response_format`; Ollama models use
`format`. See [Structured Output](api.md#structured-output) for examples.

## Ollama Models

The following models run on Ollama with a maximum configured context length of 65,536 tokens.
A model with a smaller native context window may have a lower effective limit; setting a larger
server limit does not extend what the model was trained to use reliably.

The model IDs follow the tags published in the [Ollama model library](https://ollama.com/library).
Use the complete ID shown below; IDs that include a quantization suffix select that specific
variant.

| Model family | Available model IDs | Inputs | Good for |
|---|---|---|---|
| [CodeGemma](https://ollama.com/library/codegemma) | `codegemma:latest` | Text | Code generation, completion, explanation, and instruction following |
| [DeepSeek-R1](https://ollama.com/library/deepseek-r1) | `deepseek-r1:70b` | Text | Reasoning, mathematics, and step-by-step problem solving |
| [Devstral Small 2](https://ollama.com/library/devstral-small-2) | `devstral-small-2:latest` | Text | Repository-level coding and software-engineering agents |
| [Gemma](https://ollama.com/library/gemma3) | `gemma:latest` | Text, image | Lightweight general chat, reasoning, multilingual tasks, and image understanding |
| [Llama 3.2](https://ollama.com/library/llama3.2) | `llama3.2:latest` | Text | Lightweight multilingual chat, summarization, and instruction following |
| [Llama 3.3](https://ollama.com/library/llama3.3) | `llama3.3:70b` | Text | High-quality multilingual chat and instruction following |
| [Mistral](https://ollama.com/library/mistral) | `mistral:latest` | Text | Fast general chat, summarization, and instruction following |
| [Qwen 3](https://ollama.com/library/qwen3) | `qwen3:32b` | Text | General chat, reasoning, multilingual work, and coding |
| [Qwen 3 VL](https://ollama.com/library/qwen3-vl) | `qwen3-vl:32b` | Text, image | Document and image understanding, visual reasoning, and multimodal workflows |

Ollama supports tool calling only when the selected model and template support it. Do not infer
tool-call compatibility from a model being visible in AnvilGPT. Test the intended workflow before
depending on it, or choose one of the recommended vLLM models with an explicitly configured tool
parser. See [Tool Calling](tool-calling.md) for the supported UI and API flows.

## Document Embedding Model

AnvilGPT uses [EmbeddingGemma 300M](https://huggingface.co/google/embeddinggemma-300m) internally
to create text embeddings for Knowledge Base search and retrieval. Embeddings allow the service to
find document passages that are semantically related to a prompt before sending the relevant
passages to the selected chat model.

EmbeddingGemma is not a generative chat model and does not appear in the model selector. RCAC does
not expose it as a callable model or through a standalone embeddings API. AnvilGPT applies it
automatically when processing documents uploaded through the Knowledge Base interface.

## Practical Limitations

The context window includes the system prompt, conversation history, uploaded or retrieved
document excerpts, tool definitions and results, image tokens, and the model's response. Leave room
for the response instead of filling the entire deployed limit with input.

Model IDs ending in `:latest` are aliases rather than fixed versions. RCAC may update the model
behind an alias without changing its ID. For reproducible work, record the model ID, request
settings, date, prompt, and output; do not rely on a `:latest` alias remaining unchanged.

AnvilGPT is a shared service. Response time varies with model size, prompt length, output length,
and current demand. A larger model is not always better for a particular task. Evaluate models
with representative prompts before selecting one for a research or production workflow, and see
[API Rate Limits](api.md#rate-limits) before running concurrent workloads.

[Back to AnvilGPT on Anvil](index.md)
