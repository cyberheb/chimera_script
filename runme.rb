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
  url: "http://localhost:4723/wd/hub",
  caps: {
    platformName: "WINDOWS",
    platform: "WINDOWS",
    deviceName: "WindowsPC",
    app: 'C:\Program Files (x86)\gnucash\bin\gnucash.exe'
  },
  appium_lib: {
    wait_timeout: 30,
    wait_interval: 0.5
  }
}

def caps
{
  platformName: "WINDOWS",
  platform: "WINDOWS",
  deviceName: "WindowsPC",
  app: 'C:\Program Files (x86)\gnucash\bin\gnucash.exe'
}
end

def execute_task
  $GnuCashSession = Selenium::WebDriver.for(:remote, :url => "http://localhost:4723/wd/hub", 
                  :desired_capabilities => caps )
  wait = Selenium::WebDriver::Wait.new :timeout => 60
  wait.until { $GnuCashSession.find_elements(:xpath, "(//*)[1]") != nil }

  ## Move to Main window
  $GnuCashSession.switch_to.window($GnuCashSession.window_handles.first)
  # Maximize the window
  # xpath [3] & [4]: system
  # xpath [5]: close
  # xpath [6]: maximize
  $GnuCashSession.find_element(:xpath, "(//*)[6]").click

  ## Move to Expense window. Open Expense window.
  mainWindow = $GnuCashSession.find_element(:xpath, "(//*)[1]")
  $GnuCashSession.action.move_to(mainWindow, 49, 207).double_click.perform


  ## Filling the date entry. Move to Num
  #$GnuCashSession.action.send_keys("15/11/2021")
  $GnuCashSession.action.send_keys(:tab).perform
  ## Num: Fill in the numbers, move to Descriptions
  $GnuCashSession.action.send_keys("1").perform
  $GnuCashSession.action.send_keys(:tab).perform
  ## Description: Fill in the description value; Move to Transfer
  $GnuCashSession.action.send_keys("Programming Ruby: The Pragmatic Programmers\' Guide, Second Edition").perform
  $GnuCashSession.action.send_keys(:tab).perform
  ## In Transfer column; Move to Expense column
  ## Description: Fill in the description value; Move to Transfer
  $GnuCashSession.action.send_keys("Expense").perform
  $GnuCashSession.action.send_keys(:tab).perform
  ## In Expense colum, fill in the price details; Press 'enter'
  $GnuCashSession.action.send_keys("45.5").perform
  $GnuCashSession.action.send_keys(:return).perform

  # File -> Save
  $GnuCashSession.action.move_to(mainWindow, 16, 34).click.perform
  $GnuCashSession.action.move_to(mainWindow, 42, 124).click.perform

  # Take screenshot
  $GnuCashSession.save_screenshot("C:\\Users\\Shastic\\Desktop\\gnucash_add-expense.png")

  # Close Expense window
  $GnuCashSession.action.move_to(mainWindow, 227, 118).click.perform

  # Un-maximize
  $GnuCashSession.find_element(:xpath, "(//*)[6]").click
  
  #$GnuCashSession.quit

end
  

HOST = "localhost"
PORT = 4723

if port_open?(HOST, PORT)
  # start apps and execute task
  execute_task
else
  puts "Winappdriver not running"
end