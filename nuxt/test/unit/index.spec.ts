import { describe, test, expect } from "vitest"
import { setup, $fetch } from "@nuxt/test-utils-edge"

describe("initial page", async () => {
  await setup({
    // rootDir: fileURLToPath(new URL("../../app.vue", import.meta.url)),
    server: true,
    // test context options
  })
  test("Display Hello World!", async () => {
    const html = await $fetch("/")
    expect(html).toContain("Hello World!")
  })
})
