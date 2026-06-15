# mcp-atlassian

Claude Code plugin that provides 27 Jira + Confluence MCP tools — a curated subset of the full 73-tool server. Saves ~63% tokens at session start (~4,200 tokens vs ~11,500).

Distributed via the **meramage-plugins** Claude Code marketplace.

> Server name: `mcp-atlassian` (shows as `plugin:mcp-atlassian:mcp-atlassian` in Claude Code)

---

## How it works

- `build.sh` at repo root assembles this plugin folder from source
- Claude Code runs the server via `uvx --from ${CLAUDE_PLUGIN_ROOT} mcp-atlassian`
- `${CLAUDE_PLUGIN_ROOT}` resolves to the meramage-plugins local marketplace directory
- The server loads credentials from `~/.claude/mcp-atlassian.env` at startup (via `load_dotenv` in `main()`)

---

## Configuration

Create `~/.claude/mcp-atlassian.env` with your Atlassian credentials:

```env
JIRA_URL=https://your-domain.atlassian.net
JIRA_USERNAME=you@example.com
JIRA_API_TOKEN=your-atlassian-api-token
CONFLUENCE_URL=https://your-domain.atlassian.net/wiki
CONFLUENCE_USERNAME=you@example.com
CONFLUENCE_API_TOKEN=your-atlassian-api-token
```

Generate API tokens at: https://id.atlassian.com/manage-profile/security/api-tokens

### Optional environment variables

| Variable | Effect |
|---|---|
| `TOOLSETS=all` | Enable all 73 tools instead of the default 27 |
| `TOOLSETS=jira_issues,confluence_pages` | Enable specific toolsets only |
| `TOOLSETS=default,jira_agile` | Defaults + additional toolsets |
| `READ_ONLY_MODE=true` | Disable all write tools |

---

## Available toolsets

### Default (enabled out of the box — 27 tools)

| Toolset | Description |
|---|---|
| `jira_issues` | CRUD, search, batch, changelogs |
| `jira_fields` | Field search and option retrieval |
| `jira_comments` | Issue comment operations |
| `jira_transitions` | Workflow transition operations |
| `confluence_pages` | Page CRUD, search, children, history |
| `confluence_comments` | Page comment operations |

### Additional (opt-in via `TOOLSETS`)

| Toolset | Description |
|---|---|
| `jira_projects` | Project, version, and component management |
| `jira_agile` | Boards, sprints, and related operations |
| `jira_links` | Issue links, epic links, and remote links |
| `jira_worklog` | Time tracking and worklog operations |
| `jira_attachments` | Attachment download and image retrieval |
| `jira_users` | User profile operations |
| `jira_watchers` | Issue watcher operations |
| `jira_service_desk` | JSM queues and service desks |
| `jira_forms` | ProForma form operations |
| `jira_metrics` | Issue dates and SLA metrics |
| `jira_development` | Development info (branches, PRs, commits) |
| `confluence_labels` | Page label operations |
| `confluence_users` | User search operations |
| `confluence_analytics` | Page view analytics |
| `confluence_attachments` | Attachment upload, download, and management |

---

## Updating

After changes to the main repo:

```bash
./build.sh
rsync -av --delete plugin/ /path/to/meramage-plugins/mcp-atlassian/ --exclude='.git'
```

Then run `/reload-plugins` in Claude Code to pick up the changes.
