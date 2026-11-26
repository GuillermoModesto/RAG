"""RAG CLI entry point (Python Fire). Phase 0 smoke test — will be replaced."""

import fire


def hello(name: str = "world") -> str:
    """Smoke-test command: confirms the CLI and Fire are wired up."""
    return f"hello {name}"


if __name__ == "__main__":
    fire.Fire({"caca": hello})
