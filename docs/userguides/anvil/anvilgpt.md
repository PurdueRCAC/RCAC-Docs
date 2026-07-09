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

AnvilGPT is an LLM service that makes open source LLM models accessible to ACCESS researchers.  It is **hosted entirely with on-prem resources at Purdue**, not only providing democratized access but adding another layer of control compared to commercial services.  Chats, documents, and models are not shared between users nor used for training.

There are two modalities for interacting with AnvilGPT: UI, and API, with additional functionality for both modalities is under active development. This system is integrated with a PostgreSQL vector database in the backend to enable retrieval-augmented generation (RAG) functionality.

!!! note "Pilot Program"
    This service is a pilot and provides only limited safety measures. Models may hallucinate or generate offensive content. AnvilGPT should not be used for any illegal, harmful, or violent purposes.

!!! warning "Privacy"
    Do not input, by any method, any data into these systems that your research institution would consider sensitive or proprietary. Do not input, by any method, any data into these systems that is regulated by State or Federal Law. This includes, but is not limited to, HIPAA data, Export Controlled data, personal identification numbers (e.g. SSNs) or biometric data.

## Access

!!! warning "AnvilGPT Access"
    AnvilGPT is only available for **Anvil users with an active account and project**. Once your project expires, your access to AnvilGPT gets revoked.

Access is currently being given on a per request basis.  Navigate to [https://anvilgpt.rcac.purdue.edu/](https://anvilgpt.rcac.purdue.edu/) and log in using CILogon. Select ACCESS as the identity provider. This will create a pending account.

1. Navigate to [https://anvilgpt.rcac.purdue.edu/](https://anvilgpt.rcac.purdue.edu/) and log in using CILogon.
2. Select ACCESS as the identity provider. **This will create a pending account**:

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/login.png" alt="AnvilGPT ACCESS login selection" width="60%">
</p>

3. Reach out to the [help desk](https://support.access-ci.org/open-a-ticket) with:
    1. Subject/summary line: “AnvilGPT Access Request”
    2. Description: provide a brief description of how you intend to use the service, your allocation number, and if you would like access to the UI, API, or both.
    3. Select "Some Other Question" as the user support issue and "Anvil" as the resource.
4. An admin will assess your request and approve or deny your request within 24-48 hours.

For more detailed AnvilGPT documentation, see the following pages:

* [Chat Interface](anvilgpt/chat-interface.md)
* [Workspace](anvilgpt/workspace.md)
* [API](anvilgpt/api.md)
* [Groups and Sharing](anvilgpt/groups.md)
<!-- * [MCP Integration](anvilgpt/mcp-integration.md)
* [Hosted Models Reference](anvilgpt/models.md)
* [Tool Calling](anvilgpt/tool-calling.md) -->
