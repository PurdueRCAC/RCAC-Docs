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

AnvilGPT is an LLM service that makes open-source LLM models accessible to ACCESS researchers. It is **hosted entirely on on-prem resources at Purdue**, which not only democratizes access but also adds another layer of control compared to commercial services. Chats, documents, and models are not shared between users or used for training.

There are two ways to interact with AnvilGPT: the UI and the API. Additional functionality for both is under active development. The system uses a PostgreSQL vector database in the backend to enable retrieval-augmented generation (RAG).

!!! note "Pilot Program"
    This service is a pilot and provides only limited safety measures. Models may hallucinate or generate offensive content. AnvilGPT should not be used for any illegal, harmful, or violent purposes.

!!! warning "Privacy"
    Do not enter, by any method, any data into these systems that your research institution would consider sensitive or proprietary. Do not enter any data that is regulated by state or federal law. This includes, but is not limited to, HIPAA data, export-controlled data, personal identification numbers (e.g. SSNs), or biometric data.

## Access

!!! warning "AnvilGPT Access"
    AnvilGPT is only available for **Anvil users with an active account and project**. Once your project expires, your access to AnvilGPT gets revoked.

1. Navigate to [https://anvilgpt.rcac.purdue.edu/](https://anvilgpt.rcac.purdue.edu/) and log in using CILogon.
2. Select ACCESS as the identity provider. **This will create a pending account**:
  <p style="text-align: center;">
    <img src="/assets/images/userguides/anvil/anvilgpt/login.png" alt="AnvilGPT ACCESS login selection" width="60%">
  </p>
3. Reach out to the [help desk](https://support.access-ci.org/open-a-ticket) with:
    1. Subject/summary line: “AnvilGPT Access Request”
    2. Description: Provide a brief description of how you intend to use the service, your allocation number, and whether you would like access to the UI, the API, or both.
    3. Select "Some Other Question" as the user support issue and "Anvil" as the resource.
4. An admin will review your request and approve or deny it within 24 to 48 hours.

For more detailed AnvilGPT documentation, see the following pages:

* [Chat Interface](anvilgpt/chat-interface.md)
* [Workspace](anvilgpt/workspace.md)
* [API](anvilgpt/api.md)
* [Groups and Sharing](anvilgpt/groups.md)
<!-- * [MCP Integration](anvilgpt/mcp-integration.md)
* [Hosted Models Reference](anvilgpt/models.md)
* [Tool Calling](anvilgpt/tool-calling.md) -->
