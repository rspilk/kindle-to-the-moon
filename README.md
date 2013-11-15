kindle-to-the-moon
==================

Kindle 4NT Bitcoin Dashboard

Distributed under the GNU General Public License version 3 (GPLv3) - see LICENSE for details.

![photo of my Kindle 4NT running this hack](https://github.com/saironiq/kindle-to-the-moon/preview/photo.jpg)
![the raw png](https://github.com/saironiq/kindle-to-the-moon/preview/raw.png)


Setup
=====


On the server
-------------

  * requirements: python2 with some libs, imagemagick suite, running webserver
  * copy ```template.svg```, ```gox.py``` and ```generate.sh``` into your server
  * modify the above files to suit your needs, especially the ```WWWROOT``` variable in ```generate.sh```
  * set up a cron job to run every once in a while (eg. 5 minutes) ```crontab -e```
    * add a new line that reads (modify the path as needed):

      ```
      */5 * * * * /home/user/kindle-to-the-moon/generate.sh
      ```

      (the above sets up a cron job to generate a new image every 5 minutes)


On Kindle (tested on K4 NT)
---------------------------

  * jailbreak your kindle, get SSH working (plenty of tutorials available, just google it ;)
  * SSH into you Kindle and enter the following commands (for Kindle 4NT - other Kindles might be different!):

    ```
    mntroot rw
    mkdir /mnt/us/screensaver
    mount /dev/mmcblk0p1 /mnt/base-mmc
    mv /mnt/base-mmc/opt/amazon/screen_saver/600x800 /mnt/base-mmc/opt/amazon/screen_saver/600x800.old
    ln -sfn /mnt/us/screensaver /mnt/base-mmc/opt/amazon/screen_saver/600x800
    echo '*/5 * * * * /mnt/us/screensaver/screensaver.sh' >> /etc/crontab/root
    sync
    mntroot ro
    reboot
    ```

    * again, you can modify the crontab interval (5 minutes here)
    * also, remember that cron will only run the scheduled jobs when the device is awake, so it won't drain your battery (I keep mine connected to a charger so it doesn't sleep and updates the graphs every minute)
    * however, when your Kindle is awake (you're reading a book etc...) the cron job WILL run at the preset interval (and drain your battery if you set it to run too often)

  * now you have a new empty folder named ```screensaver``` on the user partition of your Kindle (the one that can be accessed over USB from your PC)
  * modify the image URL in ```screensaver.sh``` to point to your server
  * put the ```screensaver.sh``` script into the screensaver folder on Kindle (over a standard USB mass storage conenction); the script works as follows:
    * first it checks if you have WiFi connected (if not, exits immediately)
    * then it downloads the screensaver image
    * after that if you have your screen locked, it refreshes the screen saver image and writes the current date/time on the top of screen (if not, it simply replaces it and you will see it the next time you lock your Kindle)

* now it you've done everything correctly, you should get something like the photo/image above instead of the boring old screensavers ;)
