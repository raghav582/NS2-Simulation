set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red
set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam &
    exit0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$n0 shape box
$n0 color green

$n4 color red
$n2 color red

$n1 color blue
$n3 color blue
$ns duplex-link $n0 $n1 1Mb 10ms DropTail

$ns duplex-link $n2 $n0 1Mb 10ms DropTail
$ns duplex-link $n3 $n0 1Mb 10ms DropTail
$ns duplex-link $n4 $n0 1Mb 10ms DropTail
$ns duplex-link $n5 $n0 1Mb 10ms DropTail

$ns duplex-link-op $n0 $n1 orient left-up
$ns duplex-link-op $n2 $n0 orient left-down
$ns duplex-link-op $n0 $n3 orient up
$ns duplex-link-op $n0 $n4 orient left-down
$ns duplex-link-op $n0 $n5 orient right-down

set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0
$ns connect $tcp0 $sink0
set tcp1 [new Agent/TCP]
$ns attach-agent $n4 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n2 $sink1

$ns connect $tcp1 $sink1

$tcp0 set fid_ 1
$tcp1 set fid_ 2

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp1


set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $tcp0


$ns at 0.5 "$cbr0 start"
$ns at 0.5 "$ftp0 start"

$ns at 3.5 "$ftp0 stop"
$ns at 4.5 "$cbr0 stop"



$ns at 5.0 "finish"


$ns run
