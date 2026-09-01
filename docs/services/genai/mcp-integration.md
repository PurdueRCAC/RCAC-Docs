# MCP Integration

The [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) is a standard for making external tools and data sources available to language models. An MCP server advertises the tools it provides; GenAI Studio passes those tool definitions to a compatible model and invokes the selected tool when needed.

Examples include tools that search a curated database, interact with a laboratory service, retrieve project metadata, or perform an operation in another application.

!!! important "Who can add an MCP endpoint?"
    Native MCP server registration in the version of OpenWebUI used by GenAI Studio is restricted to administrators. Users can enable MCP servers that RCAC has registered and shared with them, but cannot register a personal MCP endpoint. This is expected even if your account can add an OpenAPI tool server under personal settings.

    To request an integration, send the server details described below to [RCAC support](../../contact.md). Do not send credentials by email.

!!! warning "Only connect trusted servers"
    An MCP server receives tool arguments generated from your conversation and may return untrusted content or perform external actions. Use only servers maintained by an organization you trust. Do not send regulated, sensitive, or proprietary data through an MCP tool.

## MCP Server Requirements

GenAI Studio connects to remote MCP servers using the **Streamable HTTP** transport. The server must:

* Provide a complete, remotely reachable `https://` endpoint, commonly ending in `/mcp`.
* Support MCP over Streamable HTTP. A local `stdio` command or desktop `mcpServers` JSON configuration cannot be entered directly.
* Present a certificate trusted by the GenAI Studio server.
* Use one of the supported authentication methods: none, a bearer token, OAuth 2.1, or OAuth 2.1 with a pre-registered client.
* Return concise tool names, descriptions, and input schemas that a model can interpret reliably.

`localhost` and private addresses on your computer are not reachable from the hosted GenAI Studio application. For a `stdio`-only or legacy SSE server, contact RCAC to discuss hosting or an approved MCP-to-OpenAPI proxy.

When requesting an MCP integration, provide:

* A short server name and description.
* The full Streamable HTTP endpoint URL.
* The required authentication method, without including the credential itself.
* The users or [GenAI Studio groups](groups.md) that need access.
* A list of exposed tools and whether any tool reads, creates, changes, or deletes data.

## Enable an MCP Tool in a Chat

After RCAC registers the server and grants you access:

1. Start a chat with a model that supports native tool calling.
2. Select the **Integrations** icon in the message input area.
3. Open **Tools** and enable the MCP server or its tools.
4. If the server uses OAuth, complete the provider's authorization page in the same browser session.
5. Ask the model to use the tool and provide the information it needs.
6. Review the displayed tool name and arguments before relying on the result.

<p style="text-align: center;">
  <img src="/assets/images/services/genai/mcp-enable-in-chat-1.png" alt="GenAI Studio Tools menu with the RCAC Docs MCP server enabled" width="45%">
</p>

The enabled server appears in the **Available Tools** list for the conversation.

<p style="text-align: center;">
  <img src="/assets/images/services/genai/mcp-enable-in-chat-2.png" alt="GenAI Studio Available Tools list showing the RCAC Docs MCP server" width="80%">
</p>

For example:

```text
Use the <server name> tool to find records for project <project ID>.
Summarize what you find, but do not create or update anything.
```

Being explicit about the server, desired operation, and limits helps the model select the correct tool. For a tool that modifies external data, first ask the model to show the proposed change without executing it.

### Add an MCP Tool to a Custom Model

A model owner may attach an accessible MCP tool under **Workspace > Models > Tools**, using the same process as a [Workspace Tool](tool-calling.md#attach-a-tool-to-a-custom-model). The custom model and MCP connection must both be shared with the intended users.

Do not make an OAuth-protected MCP server a default tool. Users should enable it from the chat Integrations menu so OpenWebUI can start the interactive authorization flow before the first tool call.

## Use MCP Tools Through the API

The GenAI Studio chat-completions endpoint can execute an MCP server that is already registered in the UI. The API key acts with the same identity and access as its owner; it cannot use a server that the owner cannot access in the browser.

MCP servers use a tool ID in this form:

```text
server:mcp:<server-id>
```

Ask RCAC for the server ID. For a simple, non-streaming request, pass that ID in `tool_ids`:

```python
import os

import requests


response = requests.post(
    "https://genai.rcac.purdue.edu/api/chat/completions",
    headers={
        "Authorization": f"Bearer {os.environ['GENAI_API_KEY']}",
        "Content-Type": "application/json",
    },
    json={
        "model": "<tool-capable-model-id>",
        "messages": [
            {
                "role": "user",
                "content": "Use the approved MCP tool to look up project <project ID>.",
            }
        ],
        "tool_ids": ["server:mcp:<server-id>"],
        "params": {"function_calling": "default"},
        "stream": False,
    },
    timeout=180,
)
response.raise_for_status()
print(response.json()["choices"][0]["message"]["content"])
```

This request uses OpenWebUI's single-request tool handler: it selects and runs tools once before producing the answer. Workflows in which the model must call several tools sequentially require the chat-managed, streaming API flow used by the web interface.

For an OAuth server, the API-key owner must authorize the connection once in the GenAI Studio web interface before calling it through the API. API requests cannot open an interactive OAuth page. See [API Authentication](api.md#authentication) for API-key setup.

If you send an OpenAI-style `tools` array instead of `tool_ids`, GenAI Studio treats those as client-provided function definitions. Your application must execute the returned calls as described in [Tool Calling Through the API](tool-calling.md#tool-calling-through-the-api).

MCP is an evolving standard, and server capabilities differ.

[Back to Purdue GenAI Studio](index.md)