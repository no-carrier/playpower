#!/usr/bin/perl

while(<>)
{
if(/JSR/)
{
    s/^.*JSR/JSR/;
    print $_;
}
}
