#!/bin/bash

# App Builder Environment Setup Script
# This script ensures all necessary global tools are installed for the App Builder Agent.

set -e

echo "🚀 Starting environment setup..."

# 1. Check for Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi
echo "✅ Node.js $(node -v) found."

# 2. Check for npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed."
    exit 1
fi
echo "✅ npm $(npm -v) found."

# 3. Check for git (essential for Next.js scaffolding and Vercel)
if ! command -v git &> /dev/null; then
    echo "⚠️ git is not installed. Installing git is highly recommended."
    # On many cloud environments, you might want to auto-install:
    # sudo apt-get update && sudo apt-get install -y git
else
    echo "✅ git $(git --version) found."
fi

# 4. Install Global CLI Tools
echo "📦 Attempting to install global CLI tools (vercel, create-next-app)..."
# Using -g ensures they are "plug and play" without npx download delays
npm install -g vercel create-next-app --silent || {
    echo "⚠️ Global installation failed (likely due to permissions or restricted env). Falling back to using npx for these tools."
}

# 5. Verify CLI Tools
if command -v vercel &> /dev/null; then
    echo "✅ Vercel CLI $(vercel --version) installed globally."
else
    echo "💡 Vercel CLI will be used via 'npx vercel' when needed."
fi

if command -v create-next-app &> /dev/null; then
    echo "✅ create-next-app installed globally."
else
    echo "💡 create-next-app will be used via 'npx create-next-app' when needed."
fi

echo "✨ Environment is ready for App Building!"
