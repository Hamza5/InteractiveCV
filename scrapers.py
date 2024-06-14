import json
import os
import sys
from abc import ABC, abstractmethod
from base64 import b64encode
from urllib.request import urlopen
from logging import getLogger, basicConfig

import requests
from bs4 import BeautifulSoup
from selenium.webdriver import Firefox
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.service import Service as FirefoxService
from selenium.webdriver.remote.webelement import WebElement
from webdriver_manager.firefox import GeckoDriverManager
from github import Github

# Show the date/time, logger name, level, and message of the log
basicConfig(format='%(asctime)s %(name)s: [%(levelname)s] %(message)s', level=os.environ.get('LOG_LEVEL', 'INFO'))


class Scraper(ABC):

    headers = {
        'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:126.0) Gecko/20100101 Firefox/126.0',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.5',
        'Accept-Encoding': 'gzip, deflate, br, zstd',
        'DNT': '1',
        'Sec-GPC': '1',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
        'Sec-Fetch-Dest': 'document',
        'Sec-Fetch-Mode': 'navigate',
        'Sec-Fetch-Site': 'none',
        'Sec-Fetch-User': '?1',
        'Priority': 'u=1',
    }

    def __init__(self):
        self.logger = getLogger(self.__class__.__qualname__)
        self.repository = Github(os.environ['GITHUB_PROFILE_TOKEN']).get_repo(os.environ['GITHUB_REPOSITORY'])

    def save_to_github(self, variable_name: str):
        """Save profile data as JSON to a GitHub variable"""
        profile_var = self.repository.get_variable(variable_name)
        profile_var.edit(json.dumps(self.to_json(), ensure_ascii=False))
        self.logger.info(f"Saved profile data to GitHub variable \"{profile_var.name}\"")

    @abstractmethod
    def to_json(self):
        """Convert profile data to a JSON object"""
        raise NotImplementedError

    @abstractmethod
    def scrap_profile(self, url: str):
        """Scrap profile data from profile page at `url`"""
        raise NotImplementedError


class LinkedInProfileScraper(Scraper):
    """
    A LinkedIn profile scraper that uses Selenium and Firefox to scrape profile data from LinkedIn profile pages.
    """

    def __init__(self):
        super().__init__()
        self.driver = Firefox(service=FirefoxService(GeckoDriverManager().install()))
        self.name = None
        self.profile_picture_url = None
        self.connection_count = None
        self.about = None
        self.affiliations = None

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
        """Load cookies from a GitHub environment variable loaded from GitHub secrets"""
        linkedin_cookies = json.loads(os.environ['LINKEDIN_COOKIES'])
        self.set_cookies(linkedin_cookies)
        self.logger.info(f"Loaded {len(linkedin_cookies)} cookies")

    def save_cookies(self):
        """Save cookies to GitHub secrets"""
        cookies = self.get_cookies()
        self.repository.create_secret('LINKEDIN_COOKIES', json.dumps(cookies))
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
        with urlopen(self.profile_picture_url) as f:
            profile_picture_base64 = b64encode(f.read()).decode()
        for affiliation in self.affiliations:
            with urlopen(affiliation['logo_url']) as f:
                affiliation['logo_base64'] = b64encode(f.read()).decode()
        return {
            "name": self.name,
            "profile_picture_url": self.profile_picture_url,
            "profile_picture_base64": profile_picture_base64,
            "about": self.about,
            "connection_count": self.connection_count,
            "affiliations": self.affiliations
        }

    def close(self):
        self.driver.quit()

    def __repr__(self):
        return f'<{__class__.__name__} name="{self.name}" about="{self.about}" connection_count={self.connection_count}>'

    def __str__(self):
        return f"{self.name} ({self.connection_count})\n{self.profile_picture_url}\n{self.about}"


class HsoubAcademyScraper(Scraper):
    """
    A HsoubAcademy profile scraper that scraps profile data from HsoubAcademy profile.
    """

    def __init__(self):
        super().__init__()
        self.name = None
        self.profile_picture_url = None
        self.level = None
        self.postCount = None
        self.reputation = None
        self.bestAnswerCount = None
        self.about = None

    def scrap_profile(self, url: str):
        """Scrap profile data from HsoubAcademy profile page at `url`"""
        self.logger.info(f"Getting profile for {url}")
        response = requests.get(url, headers=self.headers)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')
        self.name = soup.find("h1").text.strip()
        self.profile_picture_url = soup.find("div", id="elProfilePhoto").find("img")['src']
        self.postCount = int(soup.find("div", id="elProfileStats").find("h4").nextSibling.text.strip())
        achievements_section = soup.find("div", class_="cProfileAchievements")
        self.level = achievements_section.find("img").attrs['alt']
        self.reputation = int(achievements_section.find("p", class_="cProfileRepScore").text)
        self.bestAnswerCount = int(achievements_section.find("p", class_="cProfileSolutions").text)
        personal_info_section = soup.find('div', id='elFollowers').find_next_sibling('div')
        self.about = personal_info_section.find('li').find('div').text.strip()
        self.logger.info(f"Got profile data for \"{self.name}\"")
        self.logger.info(f"Level: {self.level}")
        self.logger.info(f"Post count: {self.postCount}")
        self.logger.info(f"Reputation: {self.reputation}")
        self.logger.info(f"Best answer count: {self.bestAnswerCount}")
        self.logger.info(f"About: {self.about}")

    def to_json(self):
        response = requests.get(self.profile_picture_url, headers=self.headers)
        profile_picture_base64 = b64encode(response.content).decode()
        return {
            "name": self.name,
            "profile_picture_url": self.profile_picture_url,
            "profile_picture_base64": profile_picture_base64,
            "level": self.level,
            "postCount": self.postCount,
            "reputation": self.reputation,
            "bestAnswerCount": self.bestAnswerCount,
            "about": self.about
        }


class MostaqlReviewsScraper(Scraper):
    """
    A Mostaql reviews scraper that scraps reviews data from profile reviews page.
    """

    def __init__(self):
        super().__init__()
        self.average_proficiency = None
        self.average_contact = None
        self.average_quality = None
        self.average_experience = None
        self.average_timing = None
        self.average_repeat = None
        self.reviews = []

    def scrap_profile(self, url: str):
        """Scrap reviews data from Mostaql profile reviews page at `url`"""
        self.logger.info(f"Getting reviews for {url}")
        response = requests.get(url, headers=self.headers)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')
        average_rating_section = soup.find("div", class_="review--factors_container")
        review_factors = average_rating_section.find_all("div", class_="pdn--bs")

        def get_review_factor_value(factor):
            if text_value := factor.find(class_="pull-left").text.strip():
                return float(text_value)
            return len(factor.find(class_="pull-left").find_all("i", class_="fa fa-star clr-amber rating-star"))

        self.average_proficiency = get_review_factor_value(review_factors[0])
        self.average_contact = get_review_factor_value(review_factors[1])
        self.average_quality = get_review_factor_value(review_factors[2])
        self.average_experience = get_review_factor_value(review_factors[3])
        self.average_timing = get_review_factor_value(review_factors[4])
        self.average_repeat = get_review_factor_value(review_factors[5])

        for review_section in soup.find_all("div", class_="review"):
            title = review_section.find(class_="project__title").text.strip()
            review_factors = review_section.find_all("div", class_="pdn--bs")
            proficiency = get_review_factor_value(review_factors[0])
            contact = get_review_factor_value(review_factors[1])
            quality = get_review_factor_value(review_factors[2])
            experience = get_review_factor_value(review_factors[3])
            timing = get_review_factor_value(review_factors[4])
            repeat = get_review_factor_value(review_factors[5])
            review_author = review_section.find(class_="profile__name").text.strip()
            review_text = '\n'.join(review_section.find("div", class_="review__details").stripped_strings)
            self.reviews.append({
                "title": title,
                "proficiency": proficiency,
                "contact": contact,
                "quality": quality,
                "experience": experience,
                "timing": timing,
                "repeat": repeat,
                "author": review_author,
                "text": review_text
            })
            self.logger.info(f"Got review for \"{title}\" by \"{review_author}\"")

    def to_json(self):
        return {
            "average_proficiency": self.average_proficiency,
            "average_contact": self.average_contact,
            "average_quality": self.average_quality,
            "average_experience": self.average_experience,
            "average_timing": self.average_timing,
            "average_repeat": self.average_repeat,
            "reviews": self.reviews
        }


class KhamsatReviewsScraper(Scraper):
    """
    A Khamsat reviews scraper that scraps reviews data from profile reviews page.
    """

    def __init__(self):
        super().__init__()
        self.average_contact = None
        self.average_quality = None
        self.average_timing = None
        self.reviews = []

    def scrap_profile(self, url: str):
        """Scrap reviews data from Khamsat profile reviews page at `url`"""
        self.logger.info(f"Getting reviews for {url}")
        response = requests.get(url, headers=self.headers)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')
        average_rating_section = soup.find("div", id="reviews-section").find("div", class_="card-body")
        review_factors = average_rating_section.find_all("div", class_="text-end")

        def get_review_factor_value(factor):
            if numeric_value := factor.find(class_="numeric_rate"):
                return float(numeric_value.text.strip())
            return len(factor.find_all("i", class_="fa fa-star"))

        self.average_contact = get_review_factor_value(review_factors[0])
        self.average_quality = get_review_factor_value(review_factors[1])
        self.average_timing = get_review_factor_value(review_factors[2])

        for review_section in soup.find_all("div", class_="review_section"):
            title = review_section.find(class_="details-head").find('a').text.strip()
            review_factors = review_section.find_all("div", class_="text-end")
            contact = get_review_factor_value(review_factors[0])
            quality = get_review_factor_value(review_factors[1])
            timing = get_review_factor_value(review_factors[2])
            review_author = review_section.find(class_="meta--user").text.strip()
            review_text = review_section.find("p").text.strip()
            self.reviews.append({
                "title": title,
                "contact": contact,
                "quality": quality,
                "timing": timing,
                "author": review_author,
                "text": review_text
            })
            self.logger.info(f"Got review for \"{title}\" by \"{review_author}\"")

    def to_json(self):
        return {
            "average_contact": self.average_contact,
            "average_quality": self.average_quality,
            "average_timing": self.average_timing,
            "reviews": self.reviews
        }


def run_hsoub_academy_scraper():
    profile_scraper = HsoubAcademyScraper()
    profile_scraper.scrap_profile(os.environ['HSOUB_ACADEMY_PROFILE_URL'])
    profile_scraper.save_to_github('HSOUB_ACADEMY_PROFILE')


def run_mostaql_reviews_scraper():
    reviews_scraper = MostaqlReviewsScraper()
    reviews_scraper.scrap_profile(os.environ['MOSTAQL_REVIEWS_URL'])
    reviews_scraper.save_to_github('MOSTAQL_REVIEWS')


def run_khamsat_reviews_scraper():
    reviews_scraper = KhamsatReviewsScraper()
    reviews_scraper.scrap_profile(os.environ['KHAMSAT_REVIEWS_URL'])
    reviews_scraper.save_to_github('KHAMSAT_REVIEWS')


def run_linkedin_scraper():
    profile_scraper = LinkedInProfileScraper()
    profile_scraper.scrap_profile(os.environ['LINKEDIN_PROFILE_URL'])
    profile_scraper.close()
    profile_scraper.save_to_github('LINKEDIN_PROFILE')


if __name__ == '__main__':
    if len(sys.argv) == 2:
        match sys.argv[1]:
            case 'linkedin':
                run_linkedin_scraper()
            case 'hsoub_academy':
                run_hsoub_academy_scraper()
            case 'mostaql_reviews':
                run_mostaql_reviews_scraper()
            case 'khamsat_reviews':
                run_khamsat_reviews_scraper()
    else:
        run_hsoub_academy_scraper()
        run_mostaql_reviews_scraper()
        run_khamsat_reviews_scraper()
        run_linkedin_scraper()
