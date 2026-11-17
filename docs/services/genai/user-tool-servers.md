---
tags:
  - Geddes
  - Purdue GenAI Studio
authors:
  - shar1025
search:
  boost: 1
---

# Personal Tool Servers (mcpo)

Only RCAC administrators can register an [MCP Integration](mcp-integration.md), but you can
connect your own MCP server to GenAI Studio as an external tool server. GenAI Studio can call any
tool server that publishes an [OpenAPI](https://www.openapis.org/) description.
[mcpo](https://github.com/open-webui/mcpo), from the Open WebUI project, is a proxy that exposes
an MCP server as an OpenAPI tool server. You run mcpo on your own computer and add it under
**Settings > Integrations > External Tool Servers**. No administrator access is required.

## Choose a Personal Tool Server or an MCP Integration

| Consideration | Personal tool server | [MCP Integration](mcp-integration.md) |
|---|---|---|
| Who sets it up | You, from your own **Settings** | An RCAC administrator |
| Where the server runs | Usually your own computer | A remotely reachable `https://` endpoint |
| Who can use it | Only you, in your own browser | Users and groups RCAC grants access to |
| Supported MCP transports | `stdio`, Streamable HTTP, and SSE, through mcpo | Streamable HTTP |
| Available through the API | No | Yes, with `tool_ids` |
| Available when your computer is off | No | Yes |

Use a personal tool server to try out an MCP server, to use a tool that only you need, or to
reach something that exists only on your computer. If a tool is meant for a group, needs to be
available all the time, or must work through the [API](api.md), request an
[RCAC MCP integration](mcp-integration.md#request-an-mcp-integration) instead.

!!! warning "Only connect trusted servers"
    A tool server receives tool arguments generated from your conversation and may return
    untrusted content or perform external actions. Run only MCP servers whose code and publisher
    you trust. GenAI Studio's [data authorization](index.md) does not extend to your tool server
    or to any remote service the server calls. Do not send restricted data through a personal
    tool server. Do not send sensitive data (L2) unless the destination service is authorized to
    receive it.

## How the Connection Works

Your web browser, not the GenAI Studio server, connects to a personal tool server. When the
model calls a tool, your browser sends the request to the URL you entered and returns the result
to the conversation. As a result:

* A URL such as `http://localhost:8000` works, but only in a browser on the same computer that
  is running mcpo.
* The tool works only while mcpo is running and GenAI Studio is open in that browser.
* API requests to GenAI Studio cannot use a personal tool server.

## Prerequisites

* A Purdue account that can sign in to [GenAI Studio](index.md#get-started).
* A computer where you can install software and run commands in a terminal. The examples below
  were tested on macOS.
* [uv](https://docs.astral.sh/uv/getting-started/installation/), which provides the `uvx`
  command used to run mcpo and many MCP servers without a separate install step.
* The command or URL for the MCP server you want to connect. This page uses the
  [`mcp-server-time`](https://github.com/modelcontextprotocol/servers/tree/main/src/time)
  reference server as an example.

After you install uv, confirm that `uvx` is on your `PATH`:

```bash
uvx --version
```

If the shell reports `command not found`, add the uv install directory to your `PATH`. On macOS
with the default `zsh` shell:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Run mcpo

The following examples start mcpo on port `8000`. Each option before the `--` belongs to
mcpo; everything after `--` is the MCP server command or URL.

!!! note "Pin dependencies for mcpo 0.0.20 (as of November 2026)"
    With mcpo 0.0.20, a plain `uvx mcpo` command fails at startup because of
    incompatible newer releases of two of its dependencies: an `ImportError` for
    `streamablehttp_client` from the `mcp` package, or a `TypeError` about `ssl_certfile` from
    FastAPI. The examples below add `--with "mcp<2" --with "fastapi<0.120"` to pin compatible
    versions. These pins can be removed when a fixed mcpo release is available.

### Connect a Local (stdio) MCP Server

Most MCP servers run as a local command that communicates over standard input and output.
Put that command after `--`:

```bash
uvx --with "mcp<2" --with "fastapi<0.120" mcpo \
  --port 8000 --api-key "<your-api-key>" \
  -- uvx mcp-server-time --local-timezone=America/Indiana/Indianapolis
```

Replace `<your-api-key>` with a long random value that you create, for example with
`openssl rand -hex 32`. This key is a password for your tool server. It is not a GenAI Studio
API key. Keep the terminal open; stopping the command stops the tool server.

### Connect a Remote MCP Server

To use an MCP server that is already running at a URL, set `--server-type` and put the URL
after `--`. Use `streamable-http` for a Streamable HTTP endpoint, usually ending in `/mcp`:

```bash
uvx --with "mcp<2" --with "fastapi<0.120" mcpo \
  --port 8000 --api-key "<your-api-key>" \
  --server-type "streamable-http" -- https://example.org/mcp
```

For a legacy SSE endpoint, usually ending in `/sse`, use `--server-type "sse"` instead.

### Connect Several MCP Servers with a Config File

mcpo can read the `mcpServers` JSON format used by many desktop MCP clients. Create a file such
as `config.json`:

```json
{
  "mcpServers": {
    "time": {
      "command": "uvx",
      "args": ["mcp-server-time", "--local-timezone=America/Indiana/Indianapolis"]
    },
    "remote-example": {
      "type": "streamable-http",
      "url": "https://example.org/mcp"
    }
  }
}
```

Then start mcpo with `--config`:

```bash
uvx --with "mcp<2" --with "fastapi<0.120" mcpo \
  --port 8000 --api-key "<your-api-key>" --config config.json
```

With a config file, each server is served under its own path, such as
`http://localhost:8000/time` and `http://localhost:8000/remote-example`. Add each path to
GenAI Studio as a separate tool server.

### Test the Tool Server

Before you connect GenAI Studio, confirm that mcpo is working:

1. Open `http://localhost:8000/docs` in your browser. With a config file, use
   `http://localhost:8000/<name>/docs`. The page lists each tool as an API endpoint.
2. Select **Authorize**, enter your API key, and use **Try it out** to call a tool.

You can also call a tool from a terminal. For the time server:

```bash
curl -X POST http://localhost:8000/get_current_time \
  -H "Authorization: Bearer <your-api-key>" \
  -H "Content-Type: application/json" \
  -d '{"timezone": "America/Indiana/Indianapolis"}'
```

A request without the key returns
`401 {"detail":"Missing or invalid Authorization header"}`.

## Add the Tool Server to GenAI Studio

1. In GenAI Studio, open your profile menu and select **Settings**.
2. Select **Integrations**.
3. Next to **External Tool Servers**, select the add (`+`) button.
4. Enter the tool server URL, such as `http://localhost:8000`. If you used a config file,
   include the server's path, such as `http://localhost:8000/time`.
5. Set authentication to **Bearer** and enter the API key you chose when starting mcpo.
6. Select the verify button. Verification should succeed, and the mcpo terminal shows a request
   for `/openapi.json`.
7. Save the connection.

The tool server is now available to your account, but it is not active in any chat yet.

## Enable the Tool Server in a Chat

Adding a tool server in **Settings** does not enable it. Enable it in each chat where you want
to use it:

1. Start a new chat with a model that supports tool calling. See [Hosted Models](models.md) and
   the [function-calling mode guidance](tool-calling.md#attach-a-tool-to-a-custom-model).
2. Select the **Integrations** icon in the message input area.
3. Open **Tools** and enable your tool server. Its name comes from the MCP server, for example
   **mcp-time**.
4. Ask for an operation that clearly requires the tool, such as `What time is it in Tokyo?`
5. Expand the tool-call details in the response to review the tool name, arguments, and result.
   For the time server, the response shows a result from `get_current_time`, and the mcpo
   terminal logs a `POST /get_current_time` request.

To make the tool available by default, attach it to a custom model as described in
[Attach a Tool to a Custom Model](tool-calling.md#attach-a-tool-to-a-custom-model). The custom
model works only in your own browser while mcpo is running.

## Troubleshooting

| Symptom | What to check |
|---|---|
| `uvx: command not found` | Add the uv install directory to your `PATH` as described in [Prerequisites](#prerequisites). |
| mcpo exits with an `ImportError` for `streamablehttp_client` | Add `--with "mcp<2"` to the `uvx` command. Newer `mcp` releases are incompatible with mcpo 0.0.20. |
| mcpo exits with a `TypeError` for `ssl_certfile` | Add `--with "fastapi<0.120"` to the `uvx` command. Newer FastAPI releases are incompatible with mcpo 0.0.20. |
| Verification fails in **Settings** | Confirm that mcpo is running and that `http://localhost:8000/docs` opens in the same browser you use for GenAI Studio. With a config file, include `/<name>` in the URL. |
| `401 Missing or invalid Authorization header` | Confirm that authentication is set to **Bearer** and that the key matches the `--api-key` value. |
| Tool server cannot be reached from another computer | Run mcpo on the same computer as your browser. `localhost` always refers to the computer running the browser. |
| Model answers without calling the tool | Enable the tool server from the chat's **Integrations** menu; adding it in **Settings** is not enough. Confirm that the model supports tool calling and uses the correct function-calling mode, and name the tool in your prompt. |
| mcpo log shows `GET /api/config 404` | No action is needed. GenAI Studio checks for an optional endpoint that mcpo does not provide. |
| Tool stops working later | Restart mcpo with the same port and key. mcpo stops when you close its terminal or restart your computer. |

## Secure Your Tool Server

mcpo runs with your permissions on your computer. Before you leave it running, review these
settings:

* Always set `--api-key`. mcpo does not require a key, but without one any web page or program
  that can reach the port can call your tools. The key protects tool calls; the `/docs` page and
  tool descriptions remain readable without it.
* Add `--cors-allow-origins "https://genai.rcac.purdue.edu"` so that only GenAI Studio pages can
  call the server from a browser. By default, mcpo accepts requests from any web origin.
* Add `--host 127.0.0.1` so that other computers on your network cannot connect. By default, mcpo
  listens on all network interfaces.
* Review what each tool does. For a tool that writes files, sends messages, or changes data, first
  ask the model to show the proposed change without executing it.
* Do not put tokens or passwords for an MCP server in a prompt. Use environment variables or the
  `env` and `headers` fields of the config file, and do not share that file.
* Stop mcpo when you finish by pressing **Ctrl+C** in its terminal.

[Back to Purdue GenAI Studio](index.md)
