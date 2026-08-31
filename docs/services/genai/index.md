---
tags:
  - Geddes
  - Purdue GenAI Studio
authors:
  - mahlawat
search:
  boost: 1
---

# Purdue GenAI Studio

Purdue GenAI Studio is an LLM service that makes open-source LLM models accessible to Purdue researchers. It is **hosted entirely on on-prem resources at Purdue**, which not only democratizes access but also adds another layer of control compared to commercial services. Chats, documents, and models are not shared between users or used for training.

There are two ways to interact with GenAI Studio: the UI and the API. Additional functionality for both is under active development. The system uses a PostgreSQL vector database in the backend to enable retrieval-augmented generation (RAG).

!!! note "Pilot Program"
    This service is a pilot and provides only limited safety measures. Models may hallucinate or generate offensive content. GenAI Studio should not be used for any illegal, harmful, or violent purposes.

!!! warning "Privacy"
    Do not enter, by any method, any data into these systems that your research institution would consider sensitive or proprietary. Do not enter any data that is regulated by state or federal law. This includes, but is not limited to, HIPAA data, export-controlled data, personal identification numbers (e.g. SSNs), or biometric data.

## Access

!!! warning "GenAI Studio Access"
    GenAI Studio is only available to Purdue students, faculty, and staff with a valid Purdue account and access to Purdue Single Sign-On (SSO) authentication.

1. Navigate to [https://genai.rcac.purdue.edu/](https://genai.rcac.purdue.edu/) and log in using CILogon.
2. Select Purdue University as the identity provider.:

<p style="text-align: center;">
  <img src="/assets/images/userguides/anvil/anvilgpt/login-genai.png" alt="GenAI Studio ACCESS login selection" width="60%">
</p>

For more detailed GenAI Studio documentation, see the following pages:

* [Chat Interface](chat-interface.md)
* [Workspace](workspace.md)
* [API](api.md)
* [Groups and Sharing](groups.md)
* [Tool Calling](tool-calling.md)
* [MCP Integration](mcp-integration.md)
* [Hosted Models Reference](models.md)
