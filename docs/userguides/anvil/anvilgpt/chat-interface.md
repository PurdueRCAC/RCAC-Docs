# Chat Interface

Model Selection
---------------

The chat interface provides a dropdown from which you can select the model you want to use. This list includes both base models available to all users and any custom models you have created. Custom models appear alongside the base models once they have been configured in the Workspace.

If you would like to compare outputs across models, you can select multiple models at once. Your prompt is sent to each selected model simultaneously and the responses are displayed side by side. This is useful for evaluating differences in tone, accuracy, or capability across models before committing to one for a longer workflow.

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/model_selection.png" alt="AnvilGPT model selection menu" width="60%">
</p>

If there is an open-source model you need that does not appear in the list, submit a ticket request. Most open-source models can be added on request.

Sending Messages
----------------

To send a prompt, type into the message bar and submit. In addition to plain text, the interface supports two audio modes: a microphone button for speech-to-text transcription, and an audio wave button that enables a two-way voice conversation where the model responds in speech as well.

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/genai-chat-field.png" alt="AnvilGPT chat input field" width="80%">
</p>

You can attach a document directly to a chat message to give the model specific context for that exchange. This is appropriate when you need to reference a file on a one-off basis. If you want that context to persist across sessions or be reusable across chats, upload the document as a Knowledge Base or attach it to a custom model instead.

Working with Knowledge in Chat
------------------------------

To reference a Knowledge Base that you have already uploaded in the Workspace, type # followed by the name of the Knowledge Base before entering your prompt. This pulls the relevant documents into the context of that specific chat session without requiring you to re-upload anything.

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/image-20241113102233-1.png" alt="AnvilGPT knowledge reference in chat" width="60%">
</p>

Response Controls
-----------------

When you get a model response, you can take various action including editing, copying, or reading the response out loud, and view statistics about the generation with the options available at the bottom of the response.

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/output_actions.png" alt="AnvilGPT response action controls" width="30%">
</p>

Chat Parameters and System Prompt
---------------------------------

From the top-right controls of the chat screen, you can adjust model parameters such as temperature and set a custom system prompt for the current session. Changes made here apply to the active chat only and are not saved after the session ends. To make these settings persistent, define them in a custom model through the Workspace.

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/chat_controls.png" alt="AnvilGPT chat settings controls" width="40%">
</p>

Chat History and Sharing
------------------------

Your previous chats are accessible from the left sidebar. By default, chat links are tied to your account and are not visible to other users. If you need to share a chat, for example to include it in a report or share it with a collaborator, generate a shareable link from the chat options menu by clicking the three-dot icon next to the conversation.

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/genai-chat-share-dialog.png" alt="AnvilGPT chat sharing dialog" width="60%">
</p>

The resulting link is publicly accessible and will look something like:

<https://anvilgpt.rcac.purdue.edu/s/bd991c4f-29be-4975-a79a-9ae683f12c7c>

Note that the default link shown in your browser address bar is not shareable. You must use the dedicated shareable link generated from the menu.

[Back to AnvilGPT on Anvil](../anvilgpt.md)
