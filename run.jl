const jobs = Channel{Int}(4)
const results = Channel{Int}(4);

const playerDirPath = "D:\\Changzhi\\dnplayer-tw"
const gamepackage = "com.fourdesire.spacewalk"

function doshake(jobid::Int)
    shake = () -> run(`ld -s $jobid setprop call.shake null`)

    run(`ld -s $jobid setprop call.keyboard home`)
    sleep(2)

    # run 5 mins *12
    for i in 1:5*60 *12
        #= 5 mins
        0.5: 50
        0.25: 310
        0.33: 120
        0.2: 620
        0.1: 2100
        0.07: 3200
        =#

        for i in 1:14
            shake()
            sleep(0.07)
        end
    end

    dofetch(jobid)

    println("$jobid finished")
    put!(results, jobid)
end

function dofetch(jobid::Int)
    rungame = () -> run(`dnconsole runapp --index $jobid --packagename $gamepackage`)

    # fire Ad
    # run(`ld -s $jobid setprop call.keyboard home`)
    # sleep(1)
    # rungame()
    
    # wait for Ad
    # sleep(90)

    #=
    for i in 1:4
        run(`ld -s $jobid setprop call.keyboard back`)
        sleep(1)
    end
    =#

    # restart
    rungame()
end

function dispjob()
    for jobid in jobs
        doshake(jobid)
    end
end

# setup player instance id
put!(jobs, 4)
put!(jobs, 9)
put!(jobs, 10)
put!(jobs, 11)

# switch player dir(includes ld.exe, dnconsole.exe)
cd(playerDirPath)

n = length(jobs.data)

# start 4 tasks to process requests in parallel
for i in 1:4
    schedule(Task(dispjob))
end

# wait job dispatched
while length(jobs.data)>0
    sleep(2)
end

# wait job finished
for i in 1:n
    take!(results)
end