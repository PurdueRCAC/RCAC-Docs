---
tags:
  - Anvil
  - AnvilGPT
authors:
  - jin456
  - mahlawat
search:
  boost: 1
---

# AnvilGPT on Anvil

AnvilGPT gives ACCESS researchers with an active Anvil account and project access to open-weight
language models through a web interface and an API. You can chat with and compare models, work
with documents, create reusable custom models, and connect models to approved tools.

The service and its models run on Purdue-managed infrastructure. Chats, documents, and custom
models are private to your account unless you explicitly share them, and RCAC does not use your
content to train the hosted models.

!!! note "Pilot Program"
    This service is a pilot and provides only limited safety measures. Models may hallucinate or
    generate offensive content. AnvilGPT should not be used for any illegal, harmful, or violent
    purposes.

!!! warning "Privacy"
    Do not enter, by any method, any data into these systems that your research institution would
    consider sensitive or proprietary. Do not enter any data that is regulated by state or federal
    law. This includes, but is not limited to, HIPAA data, export-controlled data, personal
    identification numbers (e.g. SSNs), or biometric data.

    An external Workspace Tool or MCP server may receive tool arguments or conversation context
    outside AnvilGPT. Review an integration's owner, access, and data handling before enabling it.

## Get Started

!!! warning "AnvilGPT Access"
    AnvilGPT is available only to Anvil users with an active account and project. Access is revoked
    when the associated Anvil project expires.

1. Open [AnvilGPT](https://anvilgpt.rcac.purdue.edu/).
2. Sign in through CILogon and select **ACCESS CI (XSEDE)** as the identity provider.
3. Select **Log On** and complete ACCESS authentication. Your first sign-in creates a pending
   AnvilGPT account.

    <p style="text-align: center;">
      <img src="/assets/images/services/genai/login-anvilgpt.png" alt="CILogon identity provider selection with ACCESS CI (XSEDE) selected" width="60%">
    </p>

4. Submit an [ACCESS Help Desk ticket](https://support.access-ci.org/help-ticket) containing:

    * **Subject:** `AnvilGPT Access Request`
    * **Description:** Briefly describe your intended use, provide your Anvil allocation number,
      and state whether you need access to the web interface, the API, or both.
    * **Routing:** Select **Some Other Question** as the user-support issue and **Anvil** as the
      resource.

5. Allow 24 to 48 hours for an administrator to review the request.

If you are eligible but cannot sign in, submit an
[ACCESS Help Desk ticket](https://support.access-ci.org/help-ticket). Include the time of the
attempt and the error message, but do not include passwords or API keys.

## Choose a Task

<div class="grid cards" markdown>

-   :material-chat-outline:{ .lg .middle } __Start a Chat__

    ---

    Select and compare models, attach a document, use voice features, and manage chat history.

    [:octicons-arrow-right-24: Use the chat interface](anvilgpt/chat-interface.md)

-   :material-bookshelf:{ .lg .middle } __Work with Documents__

    ---

    Create a reusable Knowledge Base or a custom model with persistent instructions.

    [:octicons-arrow-right-24: Use the Workspace](anvilgpt/workspace.md)

-   :material-tune-variant:{ .lg .middle } __Choose a Model__

    ---

    Compare model inputs, strengths, context limits, and tool-calling support.

    [:octicons-arrow-right-24: View hosted models](anvilgpt/models.md)

-   :material-api:{ .lg .middle } __Build with the API__

    ---

    Create an API key and send chat, image, audio, or structured-output requests.

    [:octicons-arrow-right-24: Use the API](anvilgpt/api.md)

-   :material-account-group-outline:{ .lg .middle } __Share Resources__

    ---

    Request a group and share Knowledge Bases, custom models, or tools with collaborators.

    [:octicons-arrow-right-24: Manage groups and sharing](anvilgpt/groups.md)

-   :material-tools:{ .lg .middle } __Extend a Model__

    ---

    Let a model call a Workspace Tool or an RCAC-approved MCP server.

    [:octicons-arrow-right-24: Use tools](anvilgpt/tool-calling.md)
    [:octicons-arrow-right-24: Use MCP integrations](anvilgpt/mcp-integration.md)

</div>
