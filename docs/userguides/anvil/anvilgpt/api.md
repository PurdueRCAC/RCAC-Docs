# API

## Authentication

Your API key is accessible from the Settings page. Click on your user avatar in the top right, navigate to Settings, then Account. The API Keys section can be expanded to create and copy keys. Treat your API key as a credential and do not share it or commit it to version control.

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/image-20241115131909-1.png" alt="AnvilGPT API key settings page" width="80%">
</p>

## Endpoints

##### Primary Endpoint

The primary endpoint for completions is:

`https://anvilgpt.rcac.purdue.edu/api/chat/completions`

This endpoint is compatible with the OpenAI API format, which means most libraries and tools designed for OpenAI can be pointed at this URL with minimal changes.

##### Listing Available Models

To retrieve the full list of available models programmatically, make a GET request to:

`https://anvilgpt.rcac.purdue.edu/api/models`

This returns all models in the system, including those listed under the "All" section in the UI. You can also verify available models through the UI by checking the "All" section in the model dropdown.

## Making a Request

The following example sends a basic chat completion request using Python:

```
import requests

url = "https://anvilgpt.rcac.purdue.edu/api/chat/completions"
headers = {
    "Authorization": f"Bearer {your_api_key}",
    "Content-Type": "application/json"
}
body = {
    "model": "llama3.1:latest",
    "messages": [
        {
            "role": "user",
            "content": "What is your name?"
        }
    ],
    "stream": False
}

response = requests.post(url, headers=headers, json=body)

if response.status_code == 200:
    print(response.json())
else:
    raise Exception(f"Error: {response.status_code}, {response.text}")
```

## Streaming vs Non-Streaming

The API supports both streaming and non-streaming responses. Set `"stream": true` in the request body to receive incremental chunks as the model generates, or `"stream": false` to wait for the full response.

**Streaming response format** (one chunk per line, Server-Sent Events style):

```
data: {"id": "llama3.1:latest-dd3f8a12-a36f-4fcc-9537-02a9e7c1d9c8", "created": 1749755137, "model": "llama3.1:latest", "choices": [{"index": 0, "logprobs": null, "finish_reason": null, "delta": {"content": "I"}}], "object": "chat.completion.chunk"}
```

**Non-streaming response format** (full response in a single JSON object):

```json
{
  "id": "llama3.1:latest-703c01b4-c58d-4f78-b7e3-f0df34a91ede",
  "created": 1749755251,
  "model": "llama3.1:latest",
  "choices": [
    {
      "index": 0,
      "logprobs": null,
      "finish_reason": "stop",
      "message": {
        "content": "I don't have a personal name. I'm an AI designed to assist and communicate with users, so I'm often referred to as a \"chatbot\" or simply \"Assistant.\" If you'd like, I can generate a unique identifier for our conversation, but it won't be a traditional name. How can I help you today?",
        "role": "assistant"
      }
    }
  ],
  "object": "chat.completion",
  "usage": {
    "prompt_tokens": 15,
    "completion_tokens": 69,
    "total_tokens": 84
  }
}
```

## Image and Multimodal Inputs

Several models hosted on AnvilGPT support image inputs. To send an image, encode it as base64 and include it in the message content as an image_url block alongside your text prompt.

```
import base64
import requests

image = base64.b64encode(open("image.jpg", "rb").read()).decode("utf-8")

body = {
    "model": "llava:latest",
    "messages": [
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "What is in this image?"
                },
                {
                    "type": "image_url",
                    "image_url": {
                        "url": f"data:image/jpeg;base64,{image}"
                    }
                }
            ]
        }
    ]
}
```

For vision tasks requiring a more capable model, `llama4:latest` and `qwen3-vl:32b` are recommended over llava:latest.

## RAG via API

To use a custom model through the API, specify the name of your custom model in the `model` field of the request body, exactly as it appears in the UI. Any Knowledge Base attached to that custom model at definition time will be automatically included as context in API responses. No additional parameters are needed to activate the knowledge retrieval.

This means you do not need to implement your own retrieval logic if you are working within AnvilGPT's ecosystem. Define the knowledge attachment once in the Workspace, and it will be consistent across both UI and API interactions.

## Rate Limits

The API enforces a rate limit of 60 requests per minute per user. Both concurrent and sequential requests count toward this limit, so if you are parallelizing calls you should account for this when setting concurrency levels.

If the rate limit is exceeded, the API will not return an HTTP error. Instead, it returns a null value in the response. You should handle this in your code by checking for null responses before processing output.

For workloads that require parallel requests, up to approximately 10 concurrent calls to the same model are well-supported. It is preferable to direct parallel requests to a single model rather than spreading them across multiple models simultaneously, as this helps maintain stability on the shared system.

## Structured Output

AnvilGPT hosts models on two different serving backends: vLLM and Ollama. The format used to request structured output differs depending on which backend serves the model you are using. As of the time of writing, `gpt-oss:120b` and `llama4` run on vLLM, while the remaining models run on Ollama.

**For vLLM-backed models**, use the `response_format` key:

```json
"response_format": {
  "type": "json_schema",
  "json_schema": {
    "name": "country-description",
    "schema": {
      "type": "object",
      "properties": {
        "country": { "type": "string" },
        "capital": { "type": "string" },
        "languages": {
          "type": "array",
          "items": { "type": "string" }
        }
      },
      "required": ["country", "capital", "languages"]
    }
  }
}
```

**For Ollama-backed models**, use the `format` key directly in the request body:

```json
"format": {
  "type": "object",
  "properties": {
    "country": { "type": "string" },
    "capital": { "type": "string" },
    "languages": {
      "type": "array",
      "items": { "type": "string" }
    }
  },
  "required": ["country", "capital", "languages"]
}
```

If you are using Pydantic models to define your schema, you can generate the schema programmatically:

```
from pydantic import BaseModel
from typing import List

class CountryDescription(BaseModel):
    country: str
    capital: str
    languages: List[str]

# For vLLM:
schema = CountryDescription.model_json_schema()
```

[Back to AnvilGPT on Anvil](../anvilgpt.md)
