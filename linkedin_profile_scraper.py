import json
import os
from logging import getLogger, basicConfig

from selenium.webdriver import Firefox
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.service import Service as FirefoxService
from selenium.webdriver.remote.webelement import WebElement
from webdriver_manager.firefox import GeckoDriverManager
from github import Github

# Show the date/time, logger name, level, and message of the log
basicConfig(format='%(asctime)s %(name)s: [%(levelname)s] %(message)s', level=os.environ.get('LOG_LEVEL', 'INFO'))


class LinkedInProfileScraper:
    """
    A LinkedIn profile scraper that uses Selenium and Firefox to scrape profile data from LinkedIn profile pages.
    """

    def __init__(self):
        self.driver = Firefox(service=FirefoxService(GeckoDriverManager().install()))
        self.name = None
        self.profile_picture_url = None
        self.connection_count = None
        self.about = None
        self.affiliations = None
        self.logger = getLogger(__class__.__qualname__)
        self.repository = Github(os.environ['GITHUB_PROFILE_TOKEN']).get_repo(os.environ['GITHUB_REPOSITORY'])

    @staticmethod
    def get_element(root: WebElement, selector: str):
        return root.find_element(By.CSS_SELECTOR, selector)

    @staticmethod
    def get_elements(root: WebElement, selector: str):
        return root.find_elements(By.CSS_SELECTOR, selector)

    def set_cookies(self, cookies: list[dict]):
        self.driver.get("https://www.linkedin.com/")
        self.driver.delete_all_cookies()
        for cookie in cookies:
            cookie['sameSite'] = cookie['sameSite'].capitalize()
            if cookie['sameSite'] not in ["Strict", "Lax"]:
                cookie['sameSite'] = 'None'
            if 'www.linkedin.com' in cookie['domain']:
                self.driver.add_cookie(cookie)

    def get_cookies(self):
        return self.driver.get_cookies()

    def load_cookies(self):
        """Load cookies from GitHub variables"""
        linkedin_cookies_var = self.repository.get_variable('LINKEDIN_COOKIES')
        linkedin_cookies = json.loads(linkedin_cookies_var.value)
        self.set_cookies(linkedin_cookies)
        self.logger.info(f"Loaded {len(linkedin_cookies)} cookies")

    def save_cookies(self):
        """Save cookies to GitHub variables"""
        cookies = self.get_cookies()
        linkedin_cookies_var = self.repository.get_variable('LINKEDIN_COOKIES')
        linkedin_cookies_var.edit(json.dumps(cookies))
        self.logger.info(f"Saved {len(cookies)} cookies")

    def scrap_profile(self, url: str):
        """Scrap profile data from LinkedIn profile page at `url`"""
        self.logger.info(f"Getting profile for {url}")
        self.load_cookies()
        self.driver.get(url)
        self.logger.info(f"Loaded profile page at {url}")
        main_section = self.get_element(self.driver, "main section")
        self.name = self.get_element(main_section, "h1").text.strip()
        self.profile_picture_url = self.get_element(main_section, ".profile-photo-edit img").get_attribute("src")
        self.about = self.get_element(main_section, ".text-body-medium").text.strip()
        self.connection_count = int(self.get_element(main_section, "a[href*='connections'] .t-bold").text.strip())
        self.affiliations = [
            {
                "name": affiliation.text.strip(),
                "logo_url": self.get_element(affiliation, "img").get_attribute("src")
            }
            for affiliation in self.get_elements(main_section, ".mt2 ul li")
        ]
        self.logger.info(f"Got profile data for \"{self.name}\"")
        self.logger.info(f"About: {self.about}")
        self.logger.info(f"Connection count: {self.connection_count}")
        self.logger.info("Affiliations: " + " | ".join([affiliation['name'] for affiliation in self.affiliations]))
        self.save_cookies()

    def to_json(self):
        """Convert profile data to a JSON object"""
        return {
            "name": self.name,
            "profile_picture_url": self.profile_picture_url,
            "about": self.about,
            "connection_count": self.connection_count,
            "affiliations": self.affiliations
        }

    def save_to_github(self):
        """Save profile data as JSON to a GitHub variable"""
        profile_var = self.repository.get_variable('LINKEDIN_PROFILE')
        profile_var.edit(json.dumps(self.to_json()))
        self.logger.info(f"Saved profile data to GitHub variable \"{profile_var.name}\"")

    def close(self):
        self.driver.quit()

    def __repr__(self):
        return f'<{__class__.__name__} name="{self.name}" about="{self.about}" connection_count={self.connection_count}>'

    def __str__(self):
        return f"{self.name} ({self.connection_count})\n{self.profile_picture_url}\n{self.about}"


if __name__ == '__main__':
    profile_scraper = LinkedInProfileScraper()
    profile_scraper.scrap_profile(os.environ['LINKEDIN_PROFILE_URL'])
    profile_scraper.close()
    profile_scraper.save_to_github()
