# Tool Calling

Tools let a model perform a defined operation instead of only generating text. For example, a tool can query a research service, look up a record, run a calculation, or submit a job. The model selects a tool and supplies its arguments; the tool runs; and the result is returned to the model so it can answer the user.

GenAI Studio supports two common tool-calling workflows:

* **Workspace Tools** are Python toolkits stored and run by GenAI Studio. They can be enabled for one chat or attached to a custom model.
* **API-defined tools** are OpenAI-compatible function definitions sent with an API request. Your application is responsible for executing the requested function and returning its result to the model.

Use a Workspace Tool when GenAI Studio should host and execute a reusable Python function. Use an
API-defined tool when your own application should control execution, authorization, and error
handling. To use a remote tool server registered by RCAC, see [MCP Integration](mcp-integration.md).

!!! warning "Tools can perform actions"
    Only use tools whose code and behavior you trust. A tool may call external services, change data, or expose information included in a conversation. Do not place passwords, API keys, regulated data, or other sensitive information in tool code, prompts, or arguments.

## Create a Workspace Tool

Open **Workspace** from the left sidebar, select **Tools**, and then select the create (`+`) button.

If the Tools tab or create button is not visible, your account has not been granted permission to create Workspace Tools. Contact [RCAC support](../../contact.md) with a description of the integration you need.

<p style="text-align: center;">
  <img src="/assets/images/services/genai/tool-workspace-create.png" alt="GenAI Studio Workspace Tools page with the create menu open" width="60%">
</p>

!!! danger "Python tools run on the Studio server"
    Workspace Tools run on shared GenAI Studio infrastructure and are not isolated in a sandbox.
    Never import unreviewed code or write a tool that inspects the host, local files, environment
    variables, or network services. Tool creation is limited to approved users for this reason.

A toolkit is a Python file containing a class named `Tools`. Each public method in that class becomes a function the model can call. Type hints define the function's input schema, and the method docstring tells the model when and how to use it.

The following example has no external dependencies and converts temperatures:

```python
"""
title: Temperature Converter
author: Your Name
description: Convert temperatures between Celsius, Fahrenheit, and Kelvin.
version: 1.0.0
license: MIT
"""

from typing import Literal


class Tools:
    async def convert_temperature(
        self,
        value: float,
        from_unit: Literal["C", "F", "K"],
        to_unit: Literal["C", "F", "K"],
    ) -> str:
        """
        Convert a temperature between Celsius, Fahrenheit, and Kelvin.

        :param value: Numeric temperature to convert.
        :param from_unit: Unit of the input value: C, F, or K.
        :param to_unit: Unit to convert to: C, F, or K.
        :return: The converted temperature or an error message.
        """
        if from_unit == "C":
            celsius = value
        elif from_unit == "F":
            celsius = (value - 32) * 5 / 9
        else:
            celsius = value - 273.15

        if celsius < -273.15:
            return "Error: the input is below absolute zero."

        if to_unit == "C":
            result = celsius
        elif to_unit == "F":
            result = celsius * 9 / 5 + 32
        else:
            result = celsius + 273.15

        return f"{value:g} degrees {from_unit} is {result:.2f} degrees {to_unit}."
```

To save the tool:

1. Replace the example author with your name and paste the code into the editor.
2. Give the tool a clear name, ID, and description if those fields are not populated automatically. The ID should be short and should not contain spaces.
3. Set access to **Private** while developing and testing the tool.
4. Select **Save**. Resolve any validation or import errors shown by the editor.

Good tool definitions have a narrow purpose, descriptive parameter names, complete type hints, and useful error messages. Avoid combining unrelated operations into one function. If a tool changes data or triggers an external action, make that behavior unambiguous in its name and description.

## Add a Tool to a Model

You can enable a tool temporarily in a chat or make it part of a reusable custom model.

### Enable a Tool for One Chat

1. Start a chat with a model that supports tool calling.
2. Select the **Integrations** icon in the message input area.
3. Open **Tools** and enable the tool for the conversation.
4. Ask for an operation that clearly requires the tool, such as `Convert 451 degrees Fahrenheit to Celsius using the temperature tool.`
5. Expand the tool-call details in the response to review the function name, arguments, and returned result.

<p style="text-align: center;">
  <img src="/assets/images/services/genai/tool-enable-in-chat.png" alt="GenAI Studio chat Integrations menu with a Workspace Tool enabled" width="40%">
</p>

### Attach a Tool to a Custom Model

The function-calling mode must match the base model's serving backend:

| Base model | Function-calling mode | Guidance |
|---|---|---|
| vLLM-backed model | **Native** | Recommended for the most reliable tool selection and argument generation. |
| Ollama-backed model | **Default** | Leave this setting at **Default**. Native mode may not work reliably with the current Ollama deployments. |

See the [Hosted Models](models.md) to identify which backend serves a model.

1. Open **Workspace > Models**.
2. Create a model or edit one you own.
3. Select the base model.
4. Under **Advanced Parameters**, set function calling to **Native** for a vLLM-backed model or
   leave it at **Default** for an Ollama-backed model.
5. In the model's **Tools** section, select the tools that should be available by default.
6. Review **Capabilities** and disable any built-in tools that the model does not need.
7. Save the model and select it in a new chat.

<p style="text-align: center;">
  <img src="/assets/images/services/genai/model-attach-tool.png" alt="GenAI Studio custom model Tools selector with Calculator selected" width="60%">
</p>

Attaching a tool does not override its access controls. If you share a custom model, every intended user must also have read access to each attached tool. Use the tool's access controls to grant access to the appropriate [GenAI Studio group](groups.md).

!!! tip "Give the model a clear policy"
    Use the custom model's system prompt to explain when a tool should be used and any required confirmation. For a tool that changes data, instruct the model to summarize the proposed action and ask the user to confirm before making the call.

### Reduce Tool-Definition Token Use

Native function calling can make several GenAI Studio built-in tools available to the model.
The definition of every available tool is included in the model's context, even when the model
does not call that tool. A large tool list therefore increases input-token usage, leaves less
context for your conversation and documents, and may increase response time.

You cannot change the built-in tool set on a hosted base model. To use a smaller tool set, create a
custom model from the desired base model and clear each unneeded option under **Capabilities**.
Keep only the capabilities and attached Workspace or MCP tools required for the model's purpose.

This is especially useful when:

* You want to preserve more of the context window for prompts, documents, or responses.
* The model selects a built-in tool instead of your custom tool.
* Several tools have overlapping names or descriptions and the model chooses inconsistently.

After reducing the tool list, test prompts that should call each remaining tool and prompts that
should not call a tool. Use distinct tool names and descriptions, and state the selection policy
in the custom model's system prompt.

## Tool Calling Through the API

GenAI Studio's [`/api/chat/completions`](api.md#endpoints) endpoint accepts the OpenAI-compatible `tools` field. In this workflow, GenAI Studio returns a requested tool call, but **your application executes the function**. This is different from a Workspace Tool, which executes on the Studio server.

The example below sends a tool definition, executes the requested conversion locally, appends the tool result to the conversation, and asks the model for its final answer.

```python
import json
import os

import requests


API_URL = "https://genai.rcac.purdue.edu/api/chat/completions"
API_KEY = os.environ["GENAI_API_KEY"]
MODEL = "<tool-capable-model-id>"

headers = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json",
}

tools = [
    {
        "type": "function",
        "function": {
            "name": "convert_temperature",
            "description": "Convert a temperature between Celsius and Fahrenheit.",
            "parameters": {
                "type": "object",
                "properties": {
                    "value": {"type": "number"},
                    "from_unit": {"type": "string", "enum": ["C", "F"]},
                    "to_unit": {"type": "string", "enum": ["C", "F"]},
                },
                "required": ["value", "from_unit", "to_unit"],
                "additionalProperties": False,
            },
        },
    }
]


def convert_temperature(value, from_unit, to_unit):
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        raise ValueError("value must be a number")
    if from_unit not in {"C", "F"} or to_unit not in {"C", "F"}:
        raise ValueError("from_unit and to_unit must be C or F")

    if from_unit == to_unit:
        result = value
    elif from_unit == "C":
        result = value * 9 / 5 + 32
    else:
        result = (value - 32) * 5 / 9
    return {"value": round(result, 2), "unit": to_unit}


messages = [
    {"role": "user", "content": "Convert 451 degrees Fahrenheit to Celsius."}
]

response = requests.post(
    API_URL,
    headers=headers,
    json={"model": MODEL, "messages": messages, "tools": tools, "stream": False},
    timeout=120,
)
response.raise_for_status()
assistant_message = response.json()["choices"][0]["message"]
messages.append(assistant_message)

for tool_call in assistant_message.get("tool_calls", []):
    if tool_call["function"]["name"] != "convert_temperature":
        raise ValueError(f"Unexpected tool: {tool_call['function']['name']}")

    arguments = json.loads(tool_call["function"]["arguments"])
    result = convert_temperature(**arguments)
    messages.append(
        {
            "role": "tool",
            "tool_call_id": tool_call["id"],
            "name": tool_call["function"]["name"],
            "content": json.dumps(result),
        }
    )

if assistant_message.get("tool_calls"):
    final_response = requests.post(
        API_URL,
        headers=headers,
        json={"model": MODEL, "messages": messages, "tools": tools, "stream": False},
        timeout=120,
    )
    final_response.raise_for_status()
    print(final_response.json()["choices"][0]["message"]["content"])
else:
    print(assistant_message.get("content", "The model returned no content."))
```

Use `GET https://genai.rcac.purdue.edu/api/models` to find the current model IDs. Not every hosted model reliably produces tool calls; confirm that the selected model supports tool calling and validate the workflow with a small request before building an application around it.

When executing calls in your own application:

* Match tool names against an allowlist; never execute arbitrary names returned by a model.
* Parse and validate every argument against the function schema.
* Apply authorization in the tool implementation rather than trusting the prompt.
* Require confirmation before destructive or costly operations.
* Limit execution time, response size, and the number of tool-call rounds.
* Return errors as tool results when possible so the model can explain or recover from them.

For tools hosted by an MCP server, see [MCP Integration](mcp-integration.md#use-mcp-tools-through-the-api).

[Back to Purdue GenAI Studio](index.md)
