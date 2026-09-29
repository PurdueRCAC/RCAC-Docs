---
tags:
  - Geddes
  - Purdue GenAI Studio
authors:
  - mahlawat
search:
  boost: 1
hide:
  - footer
---

# Purdue GenAI Studio

Purdue GenAI Studio gives Purdue students, faculty, and staff access to open-weight language
models through a web interface and an API. You can chat with and compare models, work with
documents, create reusable custom models, and connect models to approved tools.

The service and its models run on Purdue-managed infrastructure. Chats, documents, and custom
models are private to your account unless you explicitly share them, and RCAC does not use your
content to train the hosted models.

!!! note "Pilot Program and Intended Use"
    This service is a pilot and provides only limited safety measures. Models may hallucinate or generate offensive content. GenAI Studio should not be used for any illegal, harmful, or violent purposes. It is a shared, general-purpose service and is not an approved environment for
    systematic adversarial or jailbreak evaluation.

!!! warning "Data classification"
    GenAI Studio is authorized for use with public and sensitive data (L2), as defined in
    Purdue's [Data Classification and Handling Procedures](https://www.purdue.edu/securepurdue/data-handling/).
    It is not authorized for restricted data, including data regulated by FERPA or HIPAA. If
    you are unsure how your data is classified, consult the appropriate Data Steward before
    entering it into GenAI Studio.

    An external service called by a Workspace Tool, or an MCP server, may receive tool arguments
    or conversation context outside GenAI Studio. GenAI Studio's authorization does not extend to
    these external integrations. Review an integration's owner, access, and data handling before
    enabling it.

## Get Started

!!! warning "GenAI Studio Access"
    GenAI Studio is only available to Purdue students, faculty, and staff with a valid Purdue account and access to Purdue Single Sign-On (SSO) authentication.

1. Open [Purdue GenAI Studio](https://genai.rcac.purdue.edu/)
2. Sign in through CILogon and select **Purdue University Main Campus** as the identity provider.
3. Select **Log On** and complete Purdue SSO.

<p style="text-align: center;">
  <img src="/assets/images/services/genai/login-genai.png" alt="CILogon identity provider selection with Purdue University Main Campus selected" width="60%">
</p>

If you are eligible but cannot sign in, contact [RCAC support](../../contact.md). Include the time
of the attempt and the error message, but do not send passwords or API keys.

## Choose a Task

<div class="grid cards" markdown>

-   :material-chat-outline:{ .lg .middle } __Start a Chat__

    ---

    Select and compare models, attach a document, use voice features, and manage chat history.

    [:octicons-arrow-right-24: Use the chat interface](chat-interface.md)

-   :material-bookshelf:{ .lg .middle } __Work with Documents__

    ---

    Create a reusable Knowledge Base or a custom model with persistent instructions.

    [:octicons-arrow-right-24: Use the Workspace](workspace.md)

-   :material-tune-variant:{ .lg .middle } __Choose a Model__

    ---

    Compare model inputs, strengths, context limits, and tool-calling support.

    [:octicons-arrow-right-24: View hosted models](models.md)

-   :material-api:{ .lg .middle } __Build with the API__

    ---

    Create an API key and send chat, image, audio, or structured-output requests.

    [:octicons-arrow-right-24: Use the API](api.md)

-   :material-account-group-outline:{ .lg .middle } __Share Resources__

    ---

    Request a group and share Knowledge Bases, custom models, or tools with collaborators.

    [:octicons-arrow-right-24: Manage groups and sharing](groups.md)

-   :material-tools:{ .lg .middle } __Extend a Model__

    ---

    Let a model call a Workspace Tool or an RCAC-approved MCP server.

    [:octicons-arrow-right-24: Use tools](tool-calling.md) 
    [:octicons-arrow-right-24: Use MCP integrations](mcp-integration.md)

</div>
