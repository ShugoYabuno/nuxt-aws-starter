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
    quotes: ["error", "double"],
    "no-console": "off",
    semi: ["error", "never"],
    "no-undef": "off",
    "comma-dangle": ["error", "always-multiline"],
    "vue/max-attributes-per-line": "off",
    "no-unused-vars": "off",
    "vue/html-self-closing": "off",
  },
};
