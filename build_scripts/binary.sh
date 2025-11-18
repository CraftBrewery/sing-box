#!/bin/bash

set -xeuo pipefail

# Build tags from .github/workflows/build.yml
TAGS="with_gvisor,with_quic,with_dhcp,with_wireguard,with_utls,with_acme,with_clash_api,with_tailscale,with_ccm,badlinkname,tfogo_checklinkname0"

# Get version
VERSION=$(git describe --tags --always 2>/dev/null || echo "dev")

mkdir -p dist

echo "Building for macOS arm64..."
# CI uses CGO_ENABLED=1 for macOS
CGO_ENABLED=1 GOOS=darwin GOARCH=arm64 go build -v -trimpath \
    -o dist/sing-box-darwin-arm64 \
    -tags "$TAGS" \
    -ldflags "-s -buildid= -X github.com/sagernet/sing-box/constant.Version=$VERSION -checklinkname=0" \
    ./cmd/sing-box

echo "Building for Linux arm64..."
# CI uses CGO_ENABLED=0 for Linux
CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v -trimpath \
    -o dist/sing-box-linux-arm64 \
    -tags "$TAGS" \
    -ldflags "-s -buildid= -X github.com/sagernet/sing-box/constant.Version=$VERSION -checklinkname=0" \
    ./cmd/sing-box

echo "Build complete. Artifacts in dist/:"
ls -lh dist/sing-box-darwin-arm64 dist/sing-box-linux-arm64

