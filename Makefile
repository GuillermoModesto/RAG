# ---- Configuration --------------------------------------------------------
PKG        = src
# Flags required by the subject for the `lint` rule.
MYPY_FLAGS = --warn-return-any \
             --warn-unused-ignores \
             --ignore-missing-imports \
             --disallow-untyped-defs \
             --check-untyped-defs

.DEFAULT_GOAL := run
.PHONY: install run debug lint lint-strict clean fclean

# ---- Environment ----------------------------------------------------------
# The reviewer and the moulinette only run `uv sync`.
install:
	uv sync

# ---- Execution ------------------------------------------------------------
# The CLI uses Python Fire, so the command comes from ARGS, e.g.:
#   make run ARGS="index --max_chunk_size 2000"
#   make run ARGS='search "how to configure the server" -k 5'
run:
	uv run python -m $(PKG) $(ARGS)

# Run under the pdb debugger.
debug:
	uv run python -m pdb -m $(PKG) $(ARGS)

# ---- Quality --------------------------------------------------------------
# Exclusions come from .flake8 and from [tool.mypy] in pyproject.toml.
lint:
	@fail=0; \
	uv run flake8 src || fail=1; \
	uv run mypy . $(MYPY_FLAGS) || fail=1; \
	exit $$fail

lint-strict:
	@fail=0; \
	uv run flake8 src || fail=1; \
	uv run mypy . --strict || fail=1; \
	exit $$fail

# ---- Cleanup --------------------------------------------------------------
# NOTE: do NOT delete uv.lock here — it is committed.
clean:
	find . -type d -name "__pycache__"   -not -path "./.venv/*" -exec rm -rf {} +
	find . -type d -name ".mypy_cache"   -not -path "./.venv/*" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -not -path "./.venv/*" -exec rm -rf {} +
	find . -type f -name "*.py[co]"      -not -path "./.venv/*" -delete
	rm -rf build/ dist/ .coverage htmlcov/

fclean: clean
	rm -rf .venv
