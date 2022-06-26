module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
  },
  parserOptions: {
    ecmaVersion: 12,
    sourceType: "module",
  },
  extends: ["@nuxtjs", "@nuxtjs/eslint-config-typescript"],
  rules: {
    "no-console": "off",
    semi: [2, "never"],
    "no-undef": "off",
    "comma-dangle": ["error", "always-multiline"],
    "vue/max-attributes-per-line": "off",
    "no-unused-vars": "off",
    "vue/html-self-closing": "off",
  },
};
