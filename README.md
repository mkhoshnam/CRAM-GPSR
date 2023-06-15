# CRAM-Stuff-GPSR

First you should run the following commonds in terminal.
Open the first terminal and source it after that
  ```
  roslaunch suturo_demos suturo_bringup.launch upload_hsrb:=true use_rviz:=true
  ``` 

Open another terminal, source it and run
  ```
  roslaunch suturo_manipulation start_manipulation_easy.launch
  ``` 
In another terminal and after only source it to hsr run the following

  ```
  source rk_venv/bin/activate
  source SUTURO_WSS/perception_ws/devel/setup.bash 
  rosrun robokudo main.py _ae=demo_robocup _ros_pkg=suturo_rk_robocup
  ``` 
open another terminal open the emac
  ```
  roslisp_repl
  ```

on the emac first you have to load the packages that we use and open the rosnode

```
(swank:operate-on-system-for-emacs "suturo-demos" (quote load-op)) (in-package :su-demos) (swank:operate-on-system-for-emacs "suturo-real-hsr-pm" (quote load-op))

(roslisp-utilities:startup-ros)
```


