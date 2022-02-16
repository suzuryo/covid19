import os
import time
import re

from selenium import webdriver

if not os.path.exists("ogp"):
    os.mkdir("ogp")

PATHS = {
    "/cards/confirmed-cases-area/": (959, 520),
    "/cards/health-burden/": (959, 520),
    "/cards/health-burden-hospital/": (959, 520),
    "/cards/age-group/": (959, 520),
    "/cards/restaurant-map/": (959, 520),
    "/cards/stage/": (959, 520),
    "/cards/hospital-capacity/": (959, 520),
    "/cards/hotel-capacity/": (959, 520),
    "/cards/home-capacity/": (959, 520),
    "/cards/weekly-map/": (959, 520),
    "/cards/whats-new/": (959, 520),
    "/cards/self-disclosures/": (959, 520),
    "/cards/details-of-confirmed-cases/": (959, 520),
    "/cards/number-of-confirmed-cases/": (959, 500),
    "/cards/monitoring-number-of-confirmed-cases/": (959, 500),
    "/cards/monitoring-number-of-confirmed-cases-per-100k/": (959, 500),
    "/cards/effective-reproduction-number/": (959, 500),
    "/cards/untracked-rate/": (959, 500),
    "/cards/positive-rate/": (959, 500),
    "/cards/number-of-hospitalized/": (959, 500),
    "/cards/attributes-of-confirmed-cases/": (959, 480),
    "/cards/number-of-confirmed-cases-by-municipalities/": (959, 480),
    "/cards/number-of-tested/": (959, 520),
}

options = webdriver.ChromeOptions()
options.headless=True
options.add_argument("--hide-scrollbars")
options.add_argument("--incognito")

driver = webdriver.Chrome(options=options)

for lang in ("ja", "en"):
    if not os.path.exists("ogp/{}".format(lang)):
        os.mkdir("ogp/{}".format(lang))
    for path, size in PATHS.items():
        driver.set_window_size(*size)
        driver.get(
            "http://localhost:8000{}?ogp=true".format(
                path if lang == "ja" else "/{}{}".format(lang, path)
            )
        )
        path = re.sub(r"_$", "", path.replace("/cards/", "").replace("/", "_"))
        driver.save_screenshot(
            "ogp/{}.png".format(
                path if lang == "ja" else "{}/{}".format(lang, path)
            )
        )
