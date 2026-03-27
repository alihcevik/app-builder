---
name: tailwind-typescript-guidelines
description: Enforce Tailwind CSS and TypeScript in Next.js projects. Use when scaffolding new projects, generating or refactoring components, fixing type errors, or styling.
metadata:
  author: vercel
  version: "1.0.0"
---

# Tailwind CSS and TypeScript Guidelines

When generating or modifying Next.js applications, always use **Tailwind CSS** for styling and **TypeScript** for logic.

## 1. TypeScript Requirements
- Use strict typing for all React components. Define rigorous `interface` or `type` aliases for component props.
- Avoid using `any` types; use `unknown` if the type is truly dynamic and needs narrowing, or provide a properly defined generic.
- Leverage Next.js built-in types when dealing with Pages, Layouts, and API Routes (e.g., `Metadata`).

## 2. Tailwind CSS Requirements
- Do not write plain CSS, SCSS, or CSS Modules unless absolutely necessary for complex animations or legacy integration. Always default to Tailwind utility classes.
- Construct responsive layouts using Tailwind's responsive prefixes (`sm:`, `md:`, `lg:`).
- Utilize Flexbox (`flex`, `justify-between`, `items-center`) and Grid (`grid`, `grid-cols-3`, `gap-4`) utilities optimally.
- Limit the use of arbitrary values (like `w-[15px]`). Stick to the standard Tailwind design system whenever possible to ensure consistency.

## 3. Project Configuration
- Ensure that the project has a `tsconfig.json` correctly enforcing strict mode (`"strict": true`).
- Ensure `tailwind.config.ts` (or `.js`) is configured to scan all relevant `.tsx` and `.ts` files in the `app/` and `components/` directories.
