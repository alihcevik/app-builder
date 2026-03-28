#!/bin/bash

# Manual Next.js Scaffolding Script
# This script manually creates a Next.js project structure as an alternative
# to 'create-next-app' which may fail in certain restricted environments.

set -e

APP_NAME=${1:-"."}

echo "🏗️ Manually scaffolding Next.js project in '$APP_NAME'..."

if [ "$APP_NAME" != "." ]; then
    mkdir -p "$APP_NAME"
    cd "$APP_NAME"
fi

# 1. Initialize package.json with pinned versions to save resolution time
echo "📝 Creating package.json..."
cat <<'EOF' > package.json
{
  "name": "nextjs-app",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "eslint"
  },
  "dependencies": {
    "next": "16.2.1",
    "react": "19.2.4",
    "react-dom": "19.2.4"
  },
  "devDependencies": {
    "@tailwindcss/postcss": "^4.0.0",
    "@types/node": "^20.0.0",
    "@types/react": "^19.0.0",
    "@types/react-dom": "^19.0.0",
    "eslint": "^9.0.0",
    "eslint-config-next": "16.2.1",
    "tailwindcss": "^4.0.0",
    "typescript": "^5.0.0",
    "postcss": "^8.0.0"
  }
}
EOF

# 2. Install all dependencies in one go with efficiency flags
echo "📦 Installing dependencies (optimized)..."
npm install --no-audit --no-fund --loglevel error --silent || {
    echo "⚠️ npm install failed. Attempting with --no-package-lock..."
    npm install --no-audit --no-fund --no-package-lock --loglevel error --silent
}

# 3. Create Next.js configuration (Next.js 16+ uses next.config.ts)
echo "⚙️ Configuring Next.js (Standalone mode for Cloud Run)..."
cat <<EOF > next.config.ts
import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  output: 'standalone',
  /* config options here */
};

export default nextConfig;
EOF

# 5. Create Tailwind and PostCSS configurations
echo "🎨 Configuring Tailwind CSS..."
# In Tailwind 4, we might just need postcss.config.mjs or it might be different.
# According to hello-world-app, it uses @tailwindcss/postcss ^4.
cat <<EOF > postcss.config.mjs
export default {
  plugins: {
    '@tailwindcss/postcss': {},
  },
};
EOF

# 6. Create tsconfig.json
echo "📘 Configuring TypeScript..."
cat <<EOF > tsconfig.json
{
  "compilerOptions": {
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

# 7. Create directory structure
echo "📂 Creating directory structure..."
mkdir -p app public

# 8. Create Root Layout
echo "📄 Creating app/layout.tsx..."
cat <<'EOF' > app/layout.tsx
import './globals.css';
import type { Metadata } from 'next';
import { Geist, Geist_Mono } from 'next/font/google';

const geistSans = Geist({
  variable: '--font-geist-sans',
  subsets: ['latin'],
});

const geistMono = Geist_Mono({
  variable: '--font-geist-mono',
  subsets: ['latin'],
});

export const metadata: Metadata = {
  title: 'Next.js App',
  description: 'Built with Next.js Manual Scaffold',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={`${geistSans.variable} ${geistMono.variable} antialiased font-sans`}>
      <body>{children}</body>
    </html>
  );
}
EOF

# 9. Create Home Page
echo "📄 Creating app/page.tsx..."
cat <<EOF > app/page.tsx
export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <h1 className="text-4xl font-bold">Hello, Next.js!</h1>
      <p className="mt-4 text-xl">Scaffolded manually for your environment.</p>
    </main>
  );
}
EOF

# 10. Create Global CSS with Tailwind 4 directives
echo "📄 Creating app/globals.css..."
cat <<EOF > app/globals.css
@import "tailwindcss";

:root {
  --background: #ffffff;
  --foreground: #171717;
}

body {
  color: var(--foreground);
  background: var(--background);
  font-family: Arial, Helvetica, sans-serif;
}
EOF

# 11. Finalizing
echo "✨ Manual Next.js scaffolding complete!"
