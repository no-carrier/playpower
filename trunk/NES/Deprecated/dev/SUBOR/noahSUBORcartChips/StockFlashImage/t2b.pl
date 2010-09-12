#!/usr/bin/perl

open(BOUT,">flash.bin");

while(<>)
{
    @sp=split(/\s+/,$_);
    if($#sp==15){
	print $_;

	for($i=0;$i<16;$i++)
	{
	    printf BOUT "%c",hex($sp[$i]);
	}
	
    }

}

close(BOUT);
