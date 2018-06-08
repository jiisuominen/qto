package IssueTracker::Controller::ListCloud ; 
use strict ; use warnings ; 
use Mojo::Base 'Mojolicious::Controller';

use Data::Printer ; 
use Data::Dumper; 
use Carp ; 

use IssueTracker::App::Db::In::RdrDbsFactory;
use IssueTracker::App::Utils::Logger;
use IssueTracker::App::Cnvr::CnrHsr2ToArray ; 
use IssueTracker::App::UI::WtrUIFactory ; 
use IssueTracker::App::IO::In::RdrUrlParams ; 

our $module_trace   = 0 ; 
our $appConfig      = {};
our $objLogger      = {} ;
our $objModel       = {} ; 
our $rdbms_type     = 'postgres' ; 


sub new {

   my $invocant 			= shift ;    
   $appConfig           = ${ shift @_ } || { 'foo' => 'bar' ,} ; 
   $objModel            = ${ shift @_ } || croak 'missing objModel !!!' ; 
   my $class            = ref ( $invocant ) || $invocant ; 
   my $self             = {};       
   bless( $self, $class );    
   return $self;
}  


sub doBuildListControl {

	my $self          		= shift ; 
	my $msg           		= shift ; 
   my $objModel      		= ${ shift @_ } ; 

   my $ret           		= 1 ; 
   my $control       		= '' ; 
   my $mhsr2 					= {} ;
   my $hsr2 					= {} ;
   my $objRdrDb 				= {} ; 
   my $objRdrDbsFactory 	= {} ; 
   my $table 					= {} ; 
	my $objCnrHsr2ToArray	= {} ; 
   my $objWtrUIFactory		= {} ; 
   my $objUIBuilder 			= {} ; 
   my $objRdrUrlParams     = {} ; 
  


   $table = $objModel->get('table_name'); 
   $objModel->doReplaceTokenInKeys('list' , 'select' ); 

   $objRdrDbsFactory = 'IssueTracker::App::Db::In::RdrDbsFactory'->new(\$appConfig, \$objModel );
   $objRdrDb = $objRdrDbsFactory->doInstantiate("$rdbms_type");
   ($ret, $msg) = $objRdrDb->doSelectTableIntoHashRef(\$objModel, $table);

	$objCnrHsr2ToArray = 'IssueTracker::App::Cnvr::CnrHsr2ToArray'->new ( \$appConfig , \$objModel ) ;
	( $ret , $msg , $hsr2) = $objCnrHsr2ToArray->doConvert ($objModel->get('hsr2'));

   $objWtrUIFactory = 'IssueTracker::App::UI::WtrUIFactory'->new(\$appConfig, \$objModel );
   $objUIBuilder = $objWtrUIFactory->doInstantiate('control/list-cloud');

   ( $ret , $msg , $control ) = $objUIBuilder->doBuild() ; 
   return ( $ret , $msg , $control ) ; 
}


1;

__END__
