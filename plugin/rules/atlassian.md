---
description: Atlassian MCP usage guidance — Jira and Confluence tool selection
alwaysApply: false
---

# Atlassian MCP

27 tools across 6 toolsets are enabled by default. Expand with `TOOLSETS` env var if needed.

## Default toolsets

| Toolset | Tools |
|---|---|
| `jira_issues` | get, search, create, update, delete, batch_create, project_issues |
| `jira_fields` | search_fields, get_field_options |
| `jira_comments` | add_comment, edit_comment |
| `jira_transitions` | get_transitions, transition_issue |
| `confluence_pages` | search, get, create, update, delete, move, children, page_tree, history, diff |
| `confluence_comments` | get_comments, add_comment, reply_to_comment |

## Expanding toolsets

Set `TOOLSETS` in `~/.claude/mcp.json` for the `atlassian` server entry:

- `TOOLSETS=default,jira_agile` — adds boards, sprints
- `TOOLSETS=default,jira_links` — adds issue linking
- `TOOLSETS=all` — all 73 tools
