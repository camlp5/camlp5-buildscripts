#!/usr/bin/env perl

use strict ;
use IPC::System::Simple qw(systemx runx capturex $EXITVAL);
use String::ShellQuote ;
use File::Basename;

our $verbose = 0 ;
our $ocamlpath_pathsep ;
our $path_pathsep ;

while(@ARGV) {
  if ($ARGV[0] eq '-v') {
    shift @ARGV ;
    $verbose = 1 ;
  }
  elsif ($ARGV[0] eq '-vv') {
    shift @ARGV ;
    $verbose = 2 ;
  }
  elsif ($ARGV[0] eq '-OCAMLPATH-pathsep') {
    shift @ARGV ;
    $ocamlpath_pathsep = shift @ARGV ;
  }
  elsif ($ARGV[0] eq '-PATH-pathsep') {
    shift @ARGV ;
    $path_pathsep = shift @ARGV ;
  }
  else { last ; }
}

{
  my $wd = dirname(dirname($0)) ;

  my $top = $ENV{'TOP'} || die "environment variable TOP MUST be set" ;

  print STDERR "OS: <<$^O>>\n" if $main::verbose > 1;

  unless (defined $ocamlpath_pathsep) {
    if ($^O eq 'MSWin32' || $^O eq 'cygwin') {
      $ocamlpath_pathsep = ";";
    }
    else {
      $ocamlpath_pathsep = ":";
    }
  }
  unless (defined $path_pathsep) {
    $path_pathsep = ":" ;
  }

  my $newbindir = "${top}/local-install/bin";
  my $newlibdir = "${top}/local-install/lib";
  if (-d $newbindir) {
    $ENV{'PATH'} = "${newbindir}${path_pathsep}$ENV{'PATH'}" ;
    print STDERR ("LAUNCH: PATH=".shell_quote($ENV{'PATH'})."\n") if $main::verbose > 1;
  }
  if (-d $newlibdir) {
    $ENV{'OCAMLPATH'} = "$top/local-install/lib${ocamlpath_pathsep}" ;
    print STDERR ("LAUNCH: OCAMLPATH=".shell_quote($ENV{'OCAMLPATH'})."\n") if $main::verbose > 1;
  }

  v_systemx([0], [@ARGV]) ;
}

sub v_systemx {
  croak( "v_systemx: must specify exit codes") unless (ref($_[0]) eq 'ARRAY') ;
  my $codes = shift ;
  my @cmd = @{ shift @_ } ;
  my %args = @_ ;


  print STDERR join(' ', "LAUNCH:", map { shell_quote($_) } @cmd)."\n" if $main::verbose > 0;

  return runx($codes, @cmd) ;
}

