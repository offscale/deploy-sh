#!/usr/bin/env pwsh

powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
# winget install --id=astral-sh.uv  -e

winget install jqlang.jq