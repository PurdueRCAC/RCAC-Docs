# Workspace

The Workspace is accessible from the left sidebar and includes several sections, most notably Knowledge and Models. This is where you can set up reusable resources that can be referenced across chats or exposed through the API.

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/genai-workspace-item.png" alt="AnvilGPT workspace sidebar item" width="40%">
</p>

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/genai-workspace.png" alt="AnvilGPT workspace overview" width="40%">
</p>

## Knowledge Bases

Navigate to the Knowledge tab in the Workspace and click the `+` button to create a new Knowledge Base. Once it is created, use the upload functionality to add documents to it. Different Knowledge Bases can serve different purposes, such as maintaining separate collections for different research topics or courses.

Set the visibility to private if you do not want other AnvilGPT users to see your documents. Do not upload documents that contain sensitive information or are subject to regulatory restrictions.

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/genai-knowledge-create.png" alt="AnvilGPT knowledge base creation screen" width="60%">
</p>

## Custom Models

Navigate to the Models tab in the Workspace and click the `+` button. From the model creation screen, you can specify:

* The base model to build on
* A system prompt that will be applied to every conversation with this model
* One or more Knowledge Bases to attach, enabling retrieval-augmented generation (RAG)
* Other parameters such as temperature

Documents and Knowledge Bases must be uploaded in the Knowledge tab before they appear as options here. Once saved, the custom model will appear in the model selection dropdown in the chat interface.

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/genai-model-create.png" alt="AnvilGPT custom model creation screen" width="60%">
</p>

A custom model behaves like any other model in the chat interface. The system prompt and attached knowledge are applied automatically. Any knowledge attached at the model-definition level is available in both the UI and through the API, without any additional configuration needed at request time.

[Back to AnvilGPT on Anvil](../anvilgpt.md)
