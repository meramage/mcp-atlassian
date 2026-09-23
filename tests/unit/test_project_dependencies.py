"""Tests for project dependency declarations."""

import re
from pathlib import Path


def test_atlassian_python_api_is_pinned_before_cloud_breaking_release() -> None:
    """atlassian-python-api 5.0.0 rewrote Confluence's Cloud client and dropped
    methods mcp-atlassian calls directly (get_page_by_id,
    get_all_pages_from_space_raw, create_page, update_page, ...), breaking
    Confluence page/tree lookups. Keep the dependency below that release.
    """
    pyproject = Path("pyproject.toml").read_text()

    requirement = re.search(r'"atlassian-python-api(?P<specifiers>[^"]+)"', pyproject)
    assert requirement is not None
    assert "<5.0.0" in requirement.group("specifiers")
