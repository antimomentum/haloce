## nohup

Nohup allows us to run the halo server console in the background without closing halo. We can also use a file named "input.txt" for example


to send commands to a halo console or even multiple halo consoles at once! Or just getting back control of the terminal from halo.


This can be especially useful for running multiple halo servers using wine without the use of screen, tmux, docker, and so on.



Example nohup setup for halo:


    cd
    touch input.txt
    echo "nohup tail -F ~/input.txt 2> /dev/null | nohup wineconsole haloceded.exe -path . & echo \$!" > halopull/start-nohup.sh
    chmod +x halopull/start-nohup.sh


Then to start the halo server:

    cd halopull
    ./start-nohup.sh


The halo server will be sent to the background giving back control of stdin to our shell. Also, the "echo $!" will tell us the PID of the halo server. 


The halo console output can be viewed by doing:

    cat nohup.out


You can follow it by doing:


    tail -f nohup.out


Commands can be send to the halo server(s) like so:


    echo "no_lead 1" >> ~/input.txt


One nuance is halo commands that require quotes, for example:


    sv_say "this is a test"


must be done like this:


    echo "sv_say \"this is a test\"" >> ~/input.txt


Using bash aliases we can make this easier to do halo commands



## Bash aliases!


Instead of having to do this:


echo "no_lead 1" >> ~/input.txt


we can make this easier to do halo commands :)


Example bashrc setup:


    cd
    nano .bashrc

then copy and paste this into the bottom of the file and close + save:


    halo() {
    echo -e "$*\r\n" >> ~/input.txt
    sleep 0.1
    }


finally:

    source .bashrc


then halo commands can be run like so:


    halo sv_players


## Side Notes:

Each halo console can have its own input file as well, or any combination of sharing input files :)


Another use is being able to grep for strings in the halo console. So by enabling chat echo in the halo console:


    halo chat_console_echo 1


You can tail nohup.out for cheat complaints for example:


    tail -f halopull/nohup.out | grep wall



This could be used to send alerts but there are issues with messages repeating after a while. 


nohup.out will continue to grow for as long as the halo console is running. 


Eventually this would require some sort of management if the halo server is left running long-term. Unfortunately, deleting nohup.out will cause the halo console output to be gone. 


On ther hand one could send the output to /dev/null if they are used to this enviroment. 


## Bash halo scripts :)

Just put the same function we used for the alias in your script and run your halo commands

    halo() {
        echo -e "$*\r\n" >> ~/input.txt
        sleep 0.1
    }

    halo antispam 2
    halo sv_log_enabled 1
    halo no_lead 1
    halo sv_maxplayers 16
    halo chat_console_echo 1
    halo afk_kick 300
    halo sapp_console 1
