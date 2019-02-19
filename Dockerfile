FROM homeassistant/home-assistant:latest
LABEL maintainer="Raman Gupta <raman325@gmail.com>"

# Versions
RUN curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE > ~/CHROME_DRIVER_VERSION

# Install dependencies.
RUN apt-get update && apt-get install -y unzip openjdk-8-jre-headless xvfb libxi6 libgconf-2-4

# Install Chrome.
# Had to add a '-' to the end of this line to make it run
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get -y update && apt-get -y install google-chrome-stable

# Install ChromeDriver.
RUN wget -N http://chromedriver.storage.googleapis.com/`cat ~/CHROME_DRIVER_VERSION`/chromedriver_linux64.zip -P ~/
RUN unzip ~/chromedriver_linux64.zip -d ~/
RUN rm ~/chromedriver_linux64.zip
RUN mv -f ~/chromedriver /usr/local/bin/chromedriver
RUN chown root:root /usr/local/bin/chromedriver
RUN chmod 0755 /usr/local/bin/chromedriver

CMD [ "python", "-m", "homeassistant", "--config", "/config" ]
