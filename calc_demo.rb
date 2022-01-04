require 'socket'
require 'timeout'
require 'appium_lib'
require 'selenium-webdriver'
require 'rubygems'

# # check if winappdriver already running
def port_open?(ip, port, seconds = 1)
  Timeout::timeout(seconds) do
    begin
      TCPSocket.new(ip, port).close
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
      false
    end
    rescue Timeout::Error
      false
    end
end

opts = {
  caps: {
    platformName: "WINDOWS",
    platform: "WINDOWS",
    deviceName: "WindowsPC",
    app: 'Microsoft.WindowsCalculator_8wekyb3d8bbwe!App'
  },
  appium_lib: {
    wait_timeout: 30,
    wait_interval: 0.5
  }
}


def execute_task
  $CalculatorSession = Appium::Driver.new(opts, false).start_driver
  
  wait = Selenium::WebDriver::Wait.new :timeout => 30
  wait.until { $CalculatorSession.find_elements(:name, "Clear")[0] != nil }
  
  # Clear if already running
  $CalculatorSession.find_element(:name, "Clear").click()
  
  # (7 * 9 + 1) / 8 = 8
  $CalculatorSession.find_elements(:name, "Seven")[0].click;
  $CalculatorSession.find_elements(:name, "Multiply by")[0].click;
  $CalculatorSession.find_elements(:name, "Nine")[0].click;
  $CalculatorSession.find_elements(:name, "Plus")[0].click;
  $CalculatorSession.find_elements(:name, "One")[0].click;
  $CalculatorSession.find_elements(:name, "Equals")[0].click;
  $CalculatorSession.find_elements(:name, "Divide by")[0].click;
  $CalculatorSession.find_elements(:name, "Eight")[0].click;
  $CalculatorSession.find_elements(:name, "Equals")[0].click;
  
  # The display result should shows '8'
  
end



HOST = "localhost"
PORT = 4723

if port_open?(HOST, PORT)
  # start apps and execute task
  execute_task
else
  puts "Winappdriver not running"
end