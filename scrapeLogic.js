const puppeteer = require("puppeteer-core");
require("dotenv").config();

const scrapeLogic = async (res) => {
  const browser = await puppeteer.launch({
    args: [
      "--disable-setuid-sandbox",
      "--no-sandbox",
      "--single-process",
      "--no-zygote",
    ],
    executablePath: process.env.PUPPETEER_EXECUTABLE_PATH || "/usr/bin/chromium",
    headless: "true",
  });

  try {
    const page = await browser.newPage();
    await page.goto("https://developer.chrome.com/", { waitUntil: "domcontentloaded" });
    await page.setViewport({ width: 1080, height: 1024 });

    await page.type(".devsite-search-field", "automate beyond recorder");
    
    const searchResultSelector = ".devsite-result-item-link";
    await page.waitForSelector(searchResultSelector, { visible: true });

    await Promise.all([
      page.waitForNavigation({ waitUntil: "networkidle2" }),
      page.click(searchResultSelector),
    ]);

    const textSelector = await page.waitForSelector("text/Customize and automate", { visible: true });
    const fullTitle = await textSelector?.evaluate((el) => el.textContent?.trim());

    const logStatement = `The title of this blog post is ${fullTitle}`;
    console.log(logStatement);
    res.send(logStatement);
  } catch (e) {
    console.error(e);
    res.send(`Something went wrong while running Puppeteer: ${e}`);
  } finally {
    await browser.close();
  }
};

module.exports = { scrapeLogic };
