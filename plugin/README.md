# mcp-atlassian plugin

Claude Code plugin exposing 27 curated Jira and Confluence tools.

## Install

```
/install-plugin https://github.com/meramage/mcp-atlassian
```

## Configuration

After installing, add your credentials to `~/.claude/mcp.json` under the `atlassian` server entry:

```json
{
  "mcpServers": {
    "atlassian": {
      "env": {
        "JIRA_URL": "https://your-domain.atlassian.net",
        "JIRA_USERNAME": "you@example.com",
        "JIRA_API_TOKEN": "your-token",
        "CONFLUENCE_URL": "https://your-domain.atlassian.net/wiki",
        "CONFLUENCE_USERNAME": "you@example.com",
        "CONFLUENCE_API_TOKEN": "your-token"
      }
    }
  }
}
```

API tokens: https://id.atlassian.com/manage-profile/security/api-tokens

## Expanding toolsets

By default 27 tools across 6 toolsets are exposed. Add `TOOLSETS` to the env to expand:

| Value | Tools |
|---|---|
| *(unset)* | 27 tools — default |
| `default,jira_agile` | +7 (boards, sprints) |
| `default,jira_links` | +5 (issue linking) |
| `all` | 73 tools |

## Building from source

```bash
./build.sh
```

Copies `src/`, `pyproject.toml`, and `uv.lock` into the `plugin/` folder.
