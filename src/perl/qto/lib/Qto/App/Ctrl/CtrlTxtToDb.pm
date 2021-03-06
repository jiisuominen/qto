package Qto::App::Ctrl::CtrlTxtToDb ; 

	use strict; use warnings; use utf8 ; 

	my $VERSION = '1.0.0';    

	require Exporter;
	our @ISA = qw(Exporter  Qto::App::Utils::OO::SetGetable);
	our $AUTOLOAD =();
	use AutoLoader;
   use utf8 ;
   use Carp ;
   use Data::Printer ; 

   use parent 'Qto::App::Utils::OO::SetGetable' ;
   use Qto::App::Utils::Logger ; 
   use Qto::App::Db::Out::WtrDbsFcry ; 
   use Qto::App::IO::In::RdrTextFactory ; 
	
	our $module_trace                = 0 ; 
	our $config						   = {} ; 
	our $RunDir 						   = '' ; 
	our $ProductBaseDir 				   = '' ; 
	our $ProductDir 					   = '' ; 
	our $ProductInstanceDir 			= ''; 
	our $ProductInstanceEnv  = '' ; 
	our $ProductName 					   = '' ; 
	our $EnvType 					   = '' ; 
	our $ProductVersion 				   = ''; 
	our $ProductOwner 				   = '' ; 
	our $HostName 						   = '' ; 
	our $ConfFile 						   = '' ; 
	our $objLogger						   = {} ; 
	our $objModel						   = {} ; 
   our $rdbms_type                  = 'postgre' ; 


=head1 SYNOPSIS
      my $objCtrlTxtToDb = 
         'Qto::App::Ctrl::CtrlTxtToDb'->new ( \$config ) ; 
      ( $ret , $msg ) = $objCtrlTxtToDb->doLoadIssuesFileToDb ( $issues_file ) ; 
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
   sub doLoad {

      my $self                   = shift ; 
      my $ret                    = 1 ; 
      my $msg                    = '' ; 
      my $period                 = $ENV{ 'period' } || 'daily' ;  
      
      
      my @tables              = ();
      my $tables              = $objModel->get( 'ctrl.tables' );  
	   push ( @tables , split(',',$tables ) ) ; 
   

      foreach my $table ( @tables ) {
         my $objRdrTextFactory    = 'Qto::App::IO::In::RdrTextFactory'->new( \$config , $self ) ; 
         my $objRdrText 			   = $objRdrTextFactory->doInit ( $table ); 
         my ( $ret , $msg , $str_issues_file ) 
                                    = $objRdrText->doReadIssueFile ( $table ) ; 
         return ( $ret , $msg ) if $ret != 0 ;  


         my $hsr = {} ;          # a hash ref of hash refs 	
         ( $ret , $msg , $hsr ) 
                                    = $objRdrText->doConvertStrToHashRef ( $str_issues_file , $table ) ; 
         return ( $ret , $msg ) if $ret != 0 ;  


         p($hsr) if $module_trace == 1 ; 
         my $objWtrDbsFcry    = 'Qto::App::Db::Out::WtrDbsFcry'->new( \$config , $self ) ; 
         my $objWtrDb 			   = $objWtrDbsFcry->doSpawn ( "$rdbms_type" );
         
         ( $ret , $msg )            = $objWtrDb->doInsertSqlHashData ( $hsr , $table ) ; 

         return ( $ret , $msg ) unless $ret == 0 ; 

      }

      $ret = 0 ; 
      $msg = "all tables loaded" ; 
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

		my $class      = shift;    # Class name is in the first parameter
		$config     = ${ shift @_ } || { 'foo' => 'bar' ,} ; 
		$objModel      = ${ shift @_ } || croak 'objModel not passed !!!' ; 

		my $self = {};        # Anonymous hash reference holds instance attributes
		bless( $self, $class );    # Say: $self is a $class
      $self = $self->doInitialize() ; 
		return $self;
	}  
	#eof const
	
   #
	# --------------------------------------------------------
	# intializes this object 
	# --------------------------------------------------------
   sub doInitialize {
      my $self = shift ; 

      %$self = (
           config => $config
      );

	   $objLogger 			= 'Qto::App::Utils::Logger'->new( \$config ) ;


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

		#debug rint "%$self RunBeforeExit ! \n";
	}
	#eof sub RunBeforeExit


	# -----------------------------------------------------------------------------
	# called automatically by perl's garbage collector use to know when
	# -----------------------------------------------------------------------------
	sub DESTROY {
		my $self = shift;

		#debug rint "the DESTRUCTOR is called  \n" ;
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

