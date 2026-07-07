import fs from 'node:fs'
import path from 'node:path'
import tailwindcss from '@tailwindcss/vite'
import { defineConfig, type Plugin } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'

const fixHtmlForFivem = (): Plugin => ({
  name: 'fix-html-for-fivem',
  closeBundle() {
    const htmlPath = path.resolve('build/index.html')

    const html = `<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>DD Characters</title>
    <style>
      html,
      body,
      #app {
        margin: 0;
        padding: 0;
        width: 100%;
        height: 100%;
        overflow: hidden;
        background: none !important;
        background-color: rgba(0, 0, 0, 0) !important;
      }

      #app {
        position: fixed;
        inset: 0;
        pointer-events: none;
      }
    </style>
    <link rel="stylesheet" href="./assets/index.css">
  </head>
  <body>
    <div id="app"></div>
    <script src="./assets/index.js"></script>
  </body>
</html>
`

    fs.writeFileSync(htmlPath, html)
  },
})

export default defineConfig({
  plugins: [svelte(), tailwindcss(), fixHtmlForFivem()],
  base: './',
  resolve: {
    alias: {
      $lib: path.resolve('./src/lib'),
    },
  },
  build: {
    outDir: 'build',
    emptyOutDir: true,
    target: 'chrome103',
    cssTarget: 'chrome103',
    cssCodeSplit: false,
    rollupOptions: {
      output: {
        format: 'iife',
        inlineDynamicImports: true,
        entryFileNames: 'assets/index.js',
        assetFileNames: (assetInfo) => {
          if (assetInfo.names?.some((name) => name.endsWith('.css'))) {
            return 'assets/index.css'
          }

          return 'assets/[name][extname]'
        },
      },
    },
  },
})
