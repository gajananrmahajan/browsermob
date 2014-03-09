require 'selenium-webdriver'
require 'browsermob-proxy'

def start_browsermob
	@server = BrowserMob::Proxy::Server.new File.join(Dir.pwd, "./bin/browsermob-proxy-2.0-beta-9/bin/browsermob-proxy.bat").gsub('/', '\\')
	@server.start
end

def launch_browser_with_proxy
	@proxy = @server.create_proxy
	profile = Selenium::WebDriver::Firefox::Profile.new
	profile.proxy = @proxy.selenium_proxy
	@driver = Selenium::WebDriver.for :firefox, :profile => profile
end

def save_har_file
	@proxy.new_har "google"
	@driver.get "http://www.google.com"
	har = @proxy.har
	har.save_to "./harfiles/#{ Time.now.to_s.gsub(' ','_').gsub(':','_').gsub('+', '')}.har"
end

def close_proxy
	@proxy.close
end

def quit_browser
	@driver.quit
end

def run
	start_browsermob
	launch_browser_with_proxy
	save_har_file
	close_proxy
	quit_browser
end

run
