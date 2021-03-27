const sveltePreprocess = require("svelte-preprocess");
const pkg = require("./package.json");

/** @type {import('@sveltejs/kit').Config} */
module.exports = {
  preprocess: sveltePreprocess(),
  kit: {
    adapter: require("@sveltejs/adapter-netlify")(),
    target: "#svelte",
    vite: {
      ssr: {
        noExternal: Object.keys(pkg.dependencies || {}),
      },
    },
  },
};
