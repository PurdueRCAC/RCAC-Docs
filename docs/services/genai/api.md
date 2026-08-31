# API

## Authentication

Your API key is available from the Settings page. Click your user avatar in the top-right corner, navigate to Settings, then Account. Expand the API Keys section to create and copy keys. Treat your API key as a credential, and do not share it or commit it to version control.

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/image-20241115131909-1.png" alt="GenAI Studio API key settings page" width="80%">
</p>

## Endpoints

##### Primary Endpoint

The primary endpoint for completions is:

`https://genai.rcac.purdue.edu/api/chat/completions`

This endpoint is compatible with the OpenAI API format, which means most libraries and tools designed for OpenAI can be pointed to this URL with minimal changes.

##### Listing Available Models

To retrieve the full list of available models programmatically, make a GET request to:

`https://genai.rcac.purdue.edu/api/models`

This returns all models in the system, including those listed under the "All" section in the UI. You can also verify available models through the UI by checking the "All" section in the model dropdown.

## Making a Request

The following example sends a basic chat completion request using Python:

```
import requests

url = "https://genai.rcac.purdue.edu/api/chat/completions"
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

Several models hosted on GenAI Studio support image inputs. To send an image, encode it as base64 and include it in the message content as an `image_url` block alongside your text prompt.

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

## Speech-to-Text and Text-to-Speech

GenAI Studio supports speech input and output through Faster-Whisper for speech-to-text (STT) and Microsoft SpeechT5 for text-to-speech (TTS). These services are primarily intended for voice interaction in the GenAI Studio chat interface, but you can also access them through the API.

!!! note
    The audio endpoints process complete requests rather than streaming audio. They are not a low-latency voice-agent stack and do not provide the native audio-to-audio capabilities available in models such as GPT Realtime, Gemini Live, or Qwen Omni.

### Transcribe Audio

Send an audio file as multipart form data to:

`https://genai.rcac.purdue.edu/api/v1/audio/transcriptions`

The following example transcribes a WAV file. The optional `language` field uses a language code such as `en` to specify the expected language; omit it to use automatic language detection.

```python
import requests

url = "https://genai.rcac.purdue.edu/api/v1/audio/transcriptions"
headers = {
    "Authorization": f"Bearer {your_api_key}"
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
import requests

url = "https://genai.rcac.purdue.edu/api/v1/audio/speech"
headers = {
    "Authorization": f"Bearer {your_api_key}",
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

To use a custom model through the API, specify the name of your custom model in the `model` field of the request body exactly as it appears in the UI. Any Knowledge Base attached to that custom model when it was defined will automatically be included as context in API responses. No additional parameters are needed to activate knowledge retrieval.

This means you do not need to implement your own retrieval logic if you are working within the GenAI Studio ecosystem. Define the knowledge attachment once in the Workspace, and it will remain consistent across both UI and API interactions.

## Rate Limits

The API enforces a rate limit of 60 requests per minute per user. Both concurrent and sequential requests count toward this limit, so if you are parallelizing calls, you should account for this when setting concurrency levels.

If the rate limit is exceeded, the API will not return an HTTP error. Instead, it returns a null value in the response. You should handle this in your code by checking for null responses before processing the output.

For workloads that require parallel requests, up to approximately 10 concurrent calls to the same model are well supported. It is preferable to direct parallel requests to a single model rather than spreading them across multiple models simultaneously, as this helps maintain stability on the shared system.

## Structured Output

GenAI Studio hosts models on two different serving backends: vLLM and Ollama. The format used to request structured output differs depending on which backend serves the model you are using. As of this writing, `gpt-oss:120b` and `llama4` run on vLLM, while the remaining models run on Ollama.

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

[Back to Purdue GenAI Studio](index.md)
