import os
import getpass
from ChromeDriver import ChromeDriver

# the following if statement
if getpass.getuser()=="nadialucas":
    file_folder = r"/Users/nadialucas/Documents/EPIC/2018/orientation_sessions/txt"
    # copy the path after typing "which chromedriver" into your command-line
    chromedriver_path = r"/Users/nadialucas/anaconda/bin/chromedriver"
elif getpass.getuser()=="mayanorman":
    file_folder = r"/Users/mayanorman/Dropbox/epic_task_nadia/maya/RawData"
    chromedriver_path = r"/anaconda2/bin/chromedriver"
files = ["demographics.txt","house_age.txt","house_chars1.txt","house_chars2.txt","house_type.txt", "sample82.txt"]
data_url = "http://www.jasmiths.com/data_project"
driverObj = ChromeDriver(file_folder, chromedriver_path, files, data_url)
driverObj.get_data()
