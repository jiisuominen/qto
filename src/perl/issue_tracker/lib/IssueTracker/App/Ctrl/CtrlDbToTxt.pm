package IssueTracker::App::Ctrl::CtrlDbToTxt ; 

	use strict; use warnings;

	my $VERSION = '1.0.0';    

	require Exporter;
	our @ISA = qw(Exporter  IssueTracker::App::Utils::OO::SetGetable);
	our $AUTOLOAD =();
	use AutoLoader;
   use utf8 ;
   use Carp ;
   use Data::Printer ; 

   use parent 'IssueTracker::App::Utils::OO::SetGetable' ;
   use IssueTracker::App::Utils::Logger ; 
   use IssueTracker::App::Db::In::RdrDbsFactory ; 
   use IssueTracker::App::IO::Out::WtrTextFactory ; 
   use IssueTracker::App::RAM::CnrHsr2ToTxt ; 
   use IssueTracker::App::RAM::CnrHsr2ToTxt ; 


	our $module_trace                = 0 ; 
	our $appConfig						   = {} ; 
	our $objLogger						   = {} ; 
	our $objFileHandler			      = {} ; 
   our $rdbms_type                  = 'postgre' ; 

=head1 SYNOPSIS
      my $objCtrlDbToTxt = 
         'IssueTracker::App::Ctrl::CtrlDbToTxt'->new ( \$appConfig ) ; 
      ( $ret , $msg ) = $objCtrlDbToTxt->doLoadIssuesFileToDb ( $issues_file ) ; 
=cut 

=head1 EXPORT

	A list of functions that can be exported.  You can delete this section
	if you don't export anything, such as for a purely object-oriented module.
=cut 

=head1 SUBROUTINES/METHODS

	# -----------------------------------------------------------------------------
	START SUBS 
=cut



   # 
	# -----------------------------------------------------------------------------
   # read the passed issue file , convert it to hash ref of hash refs 
   # and insert the hsr into a db
	# -----------------------------------------------------------------------------
   sub doReadAndWrite {

      my $self                = shift ; 

      my $ret                 = 1 ; 
      my $msg                 = 'unknown error while loading db issues to xls file' ; 
      my $str_issues          = q{} ; 
      my $hsr                 = {} ;   # this is the data hash ref of hash reffs 
      my $mhsr                = {} ;   # this is the meta hash describing the data hash ^^
      my @tables              = () ;   # which tables to read from
      
      my $tables              = $appConfig->{ 'tables' } || 'daily_issues' ; 
	   push ( @tables , split(',',$tables ) ) ; 

      my $filter_by_attributes = $ENV{'filter_by_attributes'} || undef ; 


      for my $table ( @tables ) { 
         my $issues_file = ();  
         my $objRdrDbsFactory = 'IssueTracker::App::Db::In::RdrDbsFactory'->new( \$appConfig , $self ) ; 
         my $objRdrDb 			= $objRdrDbsFactory->doInstantiate ( "$rdbms_type" );

         ( $ret , $msg , $hsr , $mhsr )  = $objRdrDb->doSelectTableIntoHashRef( $table , $filter_by_attributes ) ; 

         p($hsr) if $module_trace == 1 ;
         $objLogger->doLogDebugMsg ( "STOP print" ) if $module_trace == 1 ; 
         return ( $ret , $msg ) unless $ret == 0 ; 
         
         my $objWtrTextFactory = 'IssueTracker::App::IO::Out::WtrTextFactory'->new( \$appConfig , $self ) ; 
         my $objWtrText 			= $objWtrTextFactory->doInstantiate ( $table );
         
         my $objCnrHsr2ToTxt = 
            'IssueTracker::App::RAM::CnrHsr2ToTxt'->new ( \$appConfig ) ; 
         ( $ret , $msg , $hsr )  = $objCnrHsr2ToTxt->doPrepareHashForPrinting( $hsr) ; 


         ( $ret , $msg , $issues_file , $str_issues ) = $objWtrText->doConvertHashRefToStr( $hsr ) ; 
         $objFileHandler->PrintToFile ( $issues_file , $str_issues , 'utf8' ) ; 

         return ( $ret , $msg ) if $ret != 0 ;  
      }
         return ( $ret , $msg ) ; 
   } 
	

=head1 WIP

	
=cut

=head1 SUBROUTINES/METHODS

	STOP  SUBS 
	# -----------------------------------------------------------------------------
=cut


=head2 new
	# -----------------------------------------------------------------------------
	# the constructor
=cut 

	# -----------------------------------------------------------------------------
	# the constructor 
	# -----------------------------------------------------------------------------
	sub new {

		my $class = shift;    # Class name is in the first parameter
		$appConfig = ${ shift @_ } || { 'foo' => 'bar' ,} ; 
		my $self = {};        # Anonymous hash reference holds instance attributes
		bless( $self, $class );    # Say: $self is a $class
      $self = $self->doInitialize( ) ; 
		return $self;
	}  
	#eof const


   #
	# --------------------------------------------------------
	# intializes this object 
	# --------------------------------------------------------
   sub doInitialize {
      my $self          = shift ; 

      %$self = (
           appConfig => $appConfig
       );

	   $objLogger 			= 'IssueTracker::App::Utils::Logger'->new( \$appConfig ) ;
	   $objFileHandler   = 'IssueTracker::App::Utils::IO::FileHandler'->new ( \$appConfig ) ; 

      return $self ; 
	}	
	#eof sub doInitialize


=head2
	# -----------------------------------------------------------------------------
	# overrided autoloader prints - a run-time error - perldoc AutoLoader
	# -----------------------------------------------------------------------------
=cut
	sub AUTOLOAD {

		my $self = shift;
		no strict 'refs';
		my $name = our $AUTOLOAD;
		*$AUTOLOAD = sub {
			my $msg =
			  "BOOM! BOOM! BOOM! \n RunTime Error !!! \n Undefined Function $name(@_) \n ";
			croak "$self , $msg $!";
		};
		goto &$AUTOLOAD;    # Restart the new routine.
	}   
	# eof sub AUTOLOAD


	# -----------------------------------------------------------------------------
	# wrap any logic here on clean up for this class
	# -----------------------------------------------------------------------------
	sub RunBeforeExit {

		my $self = shift;

		#debug print "%$self RunBeforeExit ! \n";
	}
	#eof sub RunBeforeExit


	# -----------------------------------------------------------------------------
	# called automatically by perl's garbage collector use to know when
	# -----------------------------------------------------------------------------
	sub DESTROY {
		my $self = shift;

		#debug print "the DESTRUCTOR is called  \n" ;
		$self->RunBeforeExit();
		return;
	}   
	#eof sub DESTROY


	# STOP functions
	# =============================================================================

	


1;

__END__

=head1 NAME

UrlSniper 

=head1 SYNOPSIS

use UrlSniper  ; 


=head1 DESCRIPTION
the main purpose is to initiate minimum needed environment for the operation 
of the whole application - man app cnfig hash 

=head2 EXPORT


=head1 SEE ALSO

perldoc perlvars

No mailing list for this module


=head1 AUTHOR

yordan.georgiev@gmail.com

=head1 



=cut 

