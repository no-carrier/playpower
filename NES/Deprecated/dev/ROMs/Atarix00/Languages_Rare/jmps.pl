#!/usr/bin/perl

while(<>)
{
if(/JMP/)
{
    s/^.*JMP/JMP/;
    print $_;
}
}
