# API

Use the GenAI Studio API when you need a repeatable script or application workflow. The API uses
an OpenAI-compatible chat-completions request format, but GenAI Studio has its own base URL,
hosted model IDs, limits, and feature behavior.

## Before You Begin

You need:

* An active GenAI Studio account.
* An API key from your account settings.
* The ID of a model available to your account. See [Hosted Models](models.md) or list models
  through the API.
* An HTTP client. The Python examples below use the `requests` package.

## Authentication

Select your user avatar in the top-right corner, open **Settings > Account**, and expand **API
Keys** to create and copy a key.

<p style="text-align: center;">
  <img src="/assets/images/services/genai/api-settings.png" alt="GenAI Studio API key settings page" width="80%">
</p>

Store the key in an environment variable instead of placing it in source code:

```bash
export GENAI_API_KEY="paste-your-key-here"
```

!!! warning "Protect API keys"
    An API key acts with your GenAI Studio identity and access. Do not share it, email it, commit it
    to version control, or include it in a notebook that other people can read. Revoke a key from
    **Settings > Account** if it may have been exposed.

## Endpoints

### Chat Completions

The primary endpoint for completions is:

`https://genai.rcac.purdue.edu/api/chat/completions`

This endpoint accepts an OpenAI-compatible chat-completions request. Some GenAI Studio features,
including server-managed Workspace and MCP tools, use additional fields documented in this guide.

### List Available Models

To retrieve the full list of available models programmatically, make a GET request to:

`https://genai.rcac.purdue.edu/api/models`

This returns the models accessible to the API-key owner, including those shown under **All** in
that user's model selector.

## Making a Request

Install `requests` if it is not already available:

```bash
python -m pip install requests
```

The following example sends a basic non-streaming chat request and prints the model's reply:

```python
import os

import requests

url = "https://genai.rcac.purdue.edu/api/chat/completions"
headers = {
    "Authorization": f"Bearer {os.environ['GENAI_API_KEY']}",
    "Content-Type": "application/json",
}
body = {
    "model": "gpt-oss:120b",
    "messages": [
        {
            "role": "user",
            "content": "Explain what a context window is in two sentences.",
        }
    ],
    "stream": False,
}

response = requests.post(url, headers=headers, json=body, timeout=120)
response.raise_for_status()
print(response.json()["choices"][0]["message"]["content"])
```

## Streaming vs Non-Streaming

The API supports both streaming and non-streaming responses. Set `"stream": true` in the request body to receive incremental chunks as the model generates, or `"stream": false` to wait for the full response.

**Streaming response format** (one chunk per line, Server-Sent Events style):

```text
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

Several models hosted on GenAI Studio support image inputs. To send an image, encode it as base64 and include it in the message content as an `image_url` block alongside your text prompt.

```python
import base64
import os

import requests

url = "https://genai.rcac.purdue.edu/api/chat/completions"
headers = {
    "Authorization": f"Bearer {os.environ['GENAI_API_KEY']}",
    "Content-Type": "application/json",
}

with open("image.jpg", "rb") as image_file:
    image = base64.b64encode(image_file.read()).decode("utf-8")

body = {
    "model": "gemma4:26b-a4b",
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
    ],
}

response = requests.post(url, headers=headers, json=body, timeout=120)
response.raise_for_status()
print(response.json()["choices"][0]["message"]["content"])
```

## Speech-to-Text and Text-to-Speech

GenAI Studio supports speech input and output through Faster-Whisper for speech-to-text (STT) and Microsoft SpeechT5 for text-to-speech (TTS). These services are primarily intended for voice interaction in the GenAI Studio chat interface, but you can also access them through the API.

!!! note
    The audio endpoints process complete requests rather than streaming audio. They are not a low-latency voice-agent stack and do not provide the native audio-to-audio capabilities available in models such as GPT Realtime, Gemini Live, or Qwen Omni.

### Transcribe Audio

Send an audio file as multipart form data to:

`https://genai.rcac.purdue.edu/api/v1/audio/transcriptions`

The following example transcribes a WAV file. The optional `language` field uses a language code such as `en` to specify the expected language; omit it to use automatic language detection.

```python
import os

import requests

url = "https://genai.rcac.purdue.edu/api/v1/audio/transcriptions"
headers = {
    "Authorization": f"Bearer {os.environ['GENAI_API_KEY']}",
}

with open("recording.wav", "rb") as audio_file:
    response = requests.post(
        url,
        headers=headers,
        files={"file": ("recording.wav", audio_file, "audio/wav")},
        data={"language": "en"},
    )

response.raise_for_status()
print(response.json()["text"])
```

Specify the correct media type for the file you upload. A successful request returns a JSON response containing the transcription in the `text` field.

### Generate Speech

Send text as JSON to:

`https://genai.rcac.purdue.edu/api/v1/audio/speech`

The response contains the generated audio as binary data. The following example saves it to a file:

```python
import os

import requests

url = "https://genai.rcac.purdue.edu/api/v1/audio/speech"
headers = {
    "Authorization": f"Bearer {os.environ['GENAI_API_KEY']}",
    "Content-Type": "application/json",
}
body = {
    "input": "Welcome to Purdue GenAI Studio."
}

response = requests.post(url, headers=headers, json=body)
response.raise_for_status()

with open("speech.mp3", "wb") as audio_file:
    audio_file.write(response.content)
```

## RAG via API

To use a custom model through the API, set the request's `model` field to the custom model ID
returned by `GET /api/models`. Do not assume its display name is also its API ID. Any Knowledge
Base attached when you defined the custom model is automatically included as context; you do not
need an additional request parameter to enable retrieval.

This means you do not need to implement your own retrieval logic if you are working within the GenAI Studio ecosystem. Define the knowledge attachment once in the Workspace, and it will remain consistent across both UI and API interactions.

## Rate Limits

The API enforces a rate limit of 60 requests per minute per user. Both concurrent and sequential requests count toward this limit, so if you are parallelizing calls, you should account for this when setting concurrency levels.

If the rate limit is exceeded, the API may return a JSON `null` value instead of an HTTP error.
Check the decoded response before accessing `choices`, wait, and retry with backoff. Do not retry
immediately in a tight loop.

For workloads that require parallel requests, up to approximately 10 concurrent calls to the same model are well supported. It is preferable to direct parallel requests to a single model rather than spreading them across multiple models simultaneously, as this helps maintain stability on the shared system.

## Structured Output

GenAI Studio hosts models on two different serving backends: vLLM and Ollama. The format used to request structured output differs depending on which backend serves the model you are using. See the [Hosted Models](models.md) for the current backend used by each model.

**For vLLM-backed models**, add a `response_format` object to the request body:

```json
{
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
}
```

**For Ollama-backed models**, add a `format` object to the request body:

```json
{
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
}
```

If you use Pydantic, generate the schema and attach it to the same request body:

```python
from pydantic import BaseModel

class CountryDescription(BaseModel):
    country: str
    capital: str
    languages: list[str]

schema = CountryDescription.model_json_schema()
body = {
    "model": "gpt-oss:120b",
    "messages": [
        {"role": "user", "content": "Describe France using the required schema."}
    ],
    "response_format": {
        "type": "json_schema",
        "json_schema": {
            "name": "country-description",
            "schema": schema,
        },
    },
    "stream": False,
}
```

## Troubleshooting

| Symptom | What to check |
|---|---|
| `401 Not authenticated` | Confirm that the `Authorization` header uses `Bearer` followed by a current GenAI Studio API key. |
| Model not found or unavailable | Call `GET /api/models` with the same API key and copy an ID from the response. Access can differ by user. |
| JSON `null` response | Reduce request frequency or concurrency, wait, and retry with backoff. |
| Request times out | Shorten the prompt or requested output, try a smaller model, and allow a longer client timeout. Shared-service demand can affect response time. |
| Structured output is ignored | Confirm the model's serving backend on [Hosted Models](models.md) and use `response_format` for vLLM or `format` for Ollama. |

[Back to Purdue GenAI Studio](index.md)
