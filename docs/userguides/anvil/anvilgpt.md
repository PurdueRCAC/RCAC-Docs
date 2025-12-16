---
tags:
  - Anvil
  - AnvilGPT
authors:
  - jin456
search:
  boost: 1
---

AnvilGPT is an LLM service that makes open source LLM models like LLaMA accessible to ACCESS researchers.  It is hosted entirely with on-prem resources at Purdue, not only providing democratized access but adding another layer of control compared to commercial services.  Chats, documents, and models are not shared between users nor used for training.

There are two modalities for interacting with AnvilGPT, UI, and API, and additional functionality for both modalities is under active development. This system is integrated with a PostgreSQL vector database in the backend to enable retrieval-augmented generation (RAG) functionality.

Note this service is a pilot and provides only limited safety measures.  Models may hallucinate or generate offensive content.  AnvilGPT should not be used for any illegal, harmful, or violent purposes.

Do not input, by any method, any data into these systems that your research institution would consider sensitive or proprietary. Do not input, by any method, any data into these systems that is regulated by State or Federal Law. This includes, but is not limited to, HIPAA data, Export Controlled data, personal identification numbers (e.g. SSNs) or biometric data.

## Access

Access is currently being given on a per request basis.  Navigate to [https://anvilgpt.rcac.purdue.edu/](https://anvilgpt.rcac.purdue.edu/) and log in using CILogon. Select ACCESS as the identity provider. This will create a pending account.

Next, reach out to the [help desk](https://support.access-ci.org/open-a-ticket) with the subject/summary line “AnvilGPT Access Request”. In the description, provide a brief description of how you intend to use the service, your allocation number, and if you would like access to the UI, API, or both. Select "Some Other Question" as the user support issue and "Anvil" as the resource. An admin will assess and approve your request and get back to you.

**![](https://www.rcac.purdue.edu/files/login.png)**

## User Interface

### Chat Interface

#### Model Selection

The chat interface allows you to select from a list of available models to interface with.  This list includes both base models available to all users as well as any custom models you have created (covered below). 

You may also select multiple models to compare the output for any prompt.  In this case, your prompt will be sent to all selected models and the results displayed side-by-side.

![](https://www.rcac.purdue.edu/files/model_selection.png)

If there are additional open-source models you would like to use that are not available in the drop-down, please send in a ticket request. We are able to provide access to most open-source models.

#### Sending a Message

Sending a prompt is as simple as adding text into the message bar.  By clicking the microphone or headset buttons you can also use a speech-to-text service or have a “call” with the model where you can speak it the model will speak back.

You can also add a document to give the model specific context to respond to the prompt with. If you would like this context to be persisted, upload it to documents or add it to a custom model as discussed below. To add an existing document that was previously uploaded into the document interface to the context of a chat, use ‘#’ and then the name of the document before entering your prompt.

![](https://www.rcac.purdue.edu/files/image-20241113102233-1.png)

When you get a model response, you can take various action including editing, copying, or reading the response out loud, and view statistics about the generation with the options available at the bottom of the response.

![](https://www.rcac.purdue.edu/files/output_actions.png)

#### Other Controls

From the top left of the screen, you can access various controls which enable you to tweak the parameters and system prompt for the chat.  To persist this information, use a custom model. From these options you are also able to download chats and change other settings related to the UI.

![](https://www.rcac.purdue.edu/files/chat_controls.png)

On the left of the screen you can create new chats, access your chat history, and access the workspace where you can upload documents and create custom models.

![](https://www.rcac.purdue.edu/files/sidebar.png)

### Workspace

From the workspace you can upload documents and create models with a RAG functionality.

 ![](https://www.rcac.purdue.edu/files/workspace.png)

#### Documents

In the documents tab, use the ‘+’ button to upload documents. Select documents using the upload functionality then add it to a collection if you wish by specifying a name.  The collection can be used to create different groupings of documents, for example to create custom RAGs focusing on different tasks. Documents will not be shared across users, but please do not upload documents with sensitive information or that are subject to regulations.

![](https://www.rcac.purdue.edu/files/documents.png)

#### Models

To create a custom model, navigate to the Models tab in the workspace and click “Create a model”.

![](https://www.rcac.purdue.edu/files/create_model.png)

From here, you can customize a model by specifying the base model, system prompt, and any context documents or collections of documents, among other customizations. Documents/collections must be uploaded in the document tab before they will be accessible here. Once the model has been created it will show up in the model list in the chat interface.

![](https://www.rcac.purdue.edu/files/customize_model.png)

## API

To use the API, you wil first need to find your API key, accessible from the UI.  Click on your user avatar and navigate to Settings, and then the Account page in settings.  Here you will be able to see the API Keys. Expand this section and copy either the JWT token or create an API key.

![](https://www.rcac.purdue.edu/files/image-20241115131909-1.png)

Use the following endpoint to connect to the API.

**For an OpenAI API-compatible response, use [https://anvilgpt.rcac.purdue.edu/api/chat/completions](https://anvilgpt.rcac.purdue.edu/api/chat/completions)**

For a streaming response, this will return results formated like:

```
data: {"id": "llama3.1:latest-dd3f8a12-a36f-4fcc-9537-02a9e7c1d9c8", "created": 1749755137, "model": "llama3.1:latest", "choices": [{"index": 0, "logprobs": null, "finish_reason": null, "delta": {"content": "I"}}], "object": "chat.completion.chunk"}
```

 For a non-streaming response, this will return results formated like:

```
{"id":"llama3.1:latest-703c01b4-c58d-4f78-b7e3-f0df34a91ede","created":1749755251,"model":"llama3.1:latest","choices":[{"index":0,"logprobs":null,"finish_reason":"stop","message":{"content":"I don't have a personal name. I'm an AI designed to assist and communicate with users, so I'm often referred to as a \"chatbot\" or simply \"Assistant.\" If you'd like, I can generate a unique identifier for our conversation, but it won't be a traditional name. How can I help you today?","role":"assistant"}}],"object":"chat.completion","usage":{"response_token/s":180.38,"prompt_token/s":13403.27,"total_duration":397326193,"load_duration":13348992,"prompt_eval_count":15,"prompt_tokens":15,"prompt_eval_duration":1119130,"eval_count":69,"completion_tokens":69,"eval_duration":382515521,"approximate_total":"0h0m0s","total_tokens":84,"completion_tokens_details":{"reasoning_tokens":0,"accepted_prediction_tokens":0,"rejected_prediction_tokens":0}}}
```

**To use the endpoint, insert your API key in the example Python code below:**

```
import requests

url = "https://anvilgpt.rcac.purdue.edu/api/chat/completions"
headers = {
    "Authorization": f"Bearer {jwt_token_or_api_key}",
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
    "stream": True
}
response = requests.post(url, headers=headers, json=body)
if response.status_code == 200:
    print(response.text)
else:
    raise Exception(f"Error: {response.status_code}, {response.text}")
```

This will return output in a JSON format along with metadata.