#! /usr/bin/env bash


main(){
   do_set_vars "$@"
   do_check_install_prereqs
   do_setup_vim
   do_copy_git_hooks
   do_check_setup_bash
   do_provision_postgres
   do_setup_tmux
   do_create_multi_env_dir
   do_set_chmods
   do_finilize
}

do_copy_git_hooks(){
	cp -v $unit_run_dir/../../../cnf/git/hooks/* $unit_run_dir/../../../.git/hooks/
}

do_set_chmods(){
   find $PRODUCT_INSTANCE_DIR -type f -name '*.sh' -exec chmod 770 {} \;
}

do_setup_vim(){
	cp -v $unit_run_dir/../../../.vimrc ~/.vimrc
}

do_check_setup_bash(){
   test "$(grep -c 'PS1' ~/.bash_opts)" -eq 0 && { 
      echo 'export PS1="`date "+%F %T"` \u@\h  \w \n\n  "' >> ~/.bash_opts
   }
   echo bash ok
}

do_set_vars(){
   set -eu -o pipefail 
   RUN_UNIT='qto'
   run_unit_owner=$USER || exit 1
   unit_run_dir=$(perl -e 'use File::Basename; use Cwd "abs_path"; print dirname(abs_path(@ARGV[0]));' -- "$0")
   product_base_dir=$(cd $unit_run_dir/../../../..; echo `pwd`)
   product_dir="$product_base_dir/$RUN_UNIT" 
   source "$unit_run_dir/../../../.env"
   PRODUCT_INSTANCE_DIR="$product_dir/$RUN_UNIT.$VERSION.$ENV_TYPE.$run_unit_owner"
   product_instance_dir=$unit_run_dir/../../.. # OBS different than this one ^^^
}

usage(){

cat << EOF_DOC
   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
      $RUN_UNIT PURPOSE: 
      bootstrap the qto app on a clean ubuntu bionic 18.04 host
   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
     
   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
      $RUN_UNIT USAGE:
   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

      $0 

      example call
      clear ; bash $0 

      Note: when run for first time the required modules for the testing
      will be installed for the current OS user - and that WILL take 
		at least 10 minutes

   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


EOF_DOC
}

do_check_install_prereqs(){
   do_check_install_ubuntu_packages
   do_check_install_postgres
   do_check_install_chromium_headless
   do_check_install_phantom_js
   do_check_install_perl_modules
}

do_check_install_ubuntu_packages(){
   
   eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`
   packages=$(cat << EOF_PACKAGES
      build-essential
      git
      vim
      perl
      zip
      jq
      unzip
      exuberant-ctags
      mutt
      curl
      wget
      libdbd-pgsql
      tar
      gzip
      graphviz
      python-selenium chromium-chromedriver
      python-selenium
      python-setuptools 
      python-dev 
      gpgsm
      nodejs
      lsof
      libssl-dev
      libtest-www-selenium-perl
      libxml-atom-perl
      libxml-atom-perl
      libwww-curl-perl
EOF_PACKAGES
)

   sudo apt-get update      
	# sudo apt-get upgrade # probably not a good idea, but if yes ... this is the place ...
   while read -r package ; do 
      test "$(sudo dpkg -s $package | grep Status)" == "Status: install ok installed" || {
         sudo apt-get install -y $package 
      }
   done < <(echo "$packages");
      

}

# qto-190911215406 - minio , mc
do_check_install_postgres(){
	which psql 2>/dev/null || {
		sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
		wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
		sudo apt-get update
		sudo apt-get install -y postgresql postgresql-contrib libpq-dev pgadmin3
	}

	which psql 2>/dev/null || {
		echo "FATAL failed to install postgres !!!" ; exit 1
	}
	echo "check the postgres version:"
	sudo -u postgres psql postgres -c "SELECT version();" | grep PostgreSQL

   ## ensure the postresql starts on boot 
   sudo update-rc.d postgresql enable

}

do_check_install_phantom_js(){
   which phantomjs 2>/dev/null || { 
      sudo apt-get install -y build-essential chrpath libssl-dev libxft-dev
      sudo apt-get install -y libfreetype6 libfreetype6-dev
      sudo apt-get install -y libfontconfig1 libfontconfig1-dev
      export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"
      wget -O /tmp/$PHANTOM_JS.tar.bz2 https://github.com/Medium/phantomjs/releases/download/v2.1.1/$PHANTOM_JS.tar.bz2
      cd /tmp/
      sudo tar xvjf $PHANTOM_JS.tar.bz2
      sudo mv $PHANTOM_JS /usr/local/share
      sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin
      phantomjs --version
   }
}

do_check_install_chromium_headless(){
   which chromium-browser 2>/dev/null || {
      sudo apt-get update
      sudo apt-get install -y software-properties-common
      sudo apt-get install -y chromium-browser 
      sudo apt-get update
   }
}

do_check_install_perl_modules(){

   #eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`
   modules=$(cat << EOF_MODULES
      JSON  
      Data::Printer
      Email::Valid
      Test::Most 
      Data::Printer 
      FindBin
      JSON::Parse 
      IPC::System::Simple 
      Mojolicious 
      IO::Socket::SSL  
      Mojo::Phantom 
      URL::Encode
      ExtUtils::Installed
      Carp::Always
      Data::Printer
      File::Copy
      File::Find
      File::Path
      Excel::Writer::XLSX
      Spreadsheet::ParseExcel
      Spreadsheet::XLSX
      Spreadsheet::ParseExcel::FmtJapan
      Text::CSV_XS
      Module::Build::Tiny
      Carp::Always
      URL::Encode
      Carp::Always
      Data::Printer
      File::Copy::Recursive
      Spreadsheet::ParseExcel
      Spreadsheet::XLSX
      JSON
      Text::CSV_XS
      Test::Trap
      Test::More
      Test::Most
      DBD::Pg
      Tie::Hash::DBD
      Scalar::Util::Numeric
      IPC::System::Simple
      Time::HiRes
      Mojolicious::Plugin::BasicAuthPlus
      Mojolicious::Plugin::StaticCache
      Mojolicious::Plugin::RenderFile
      Mojolicious::Plugin::Authentication
      Mojo::JWT
      Mojo::Pg
      Test::Mojo
      Authen::Passphrase::BlowfishCrypt
      Selenium::Remote::Driver
      Selenium::Chrome
      Term::ReadKey
      Term::Prompt
      DBIx::ProcedureCall
      JSON::Parse
      Net::Google::DataAPI::Auth::OAuth2
      Net::Google::Spreadsheets::V4
      Net::Google::Spreadsheets
EOF_MODULES
)
      
   while read -r module ; do 
      use_modules="${use_modules:-} use $module ; " 
   done < <(echo "$modules");
   
   perl -e "$use_modules" || {
      echo "deploying modules. This WILL take couple of min, but ONLY ONCE !!!"
      curl -L http://cpanmin.us | perl - --self-upgrade -l ~/perl5 App::cpanminus local::lib
      eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`
      test "$(grep -c 'Mlocal::lib' ~/.bash_opts)" -eq 0 && \
      echo 'eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`' >> ~/.bash_opts
      echo 'source ~/.bash_opts' >> ~/.bashrc
      cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
      export PERL_MM_USE_DEFAULT=1
      perl -MCPAN -e 'CPAN::Shell->force(qw( install Net::Google::DataAPI));'
      PATH="~/perl5/bin${PATH:+:${PATH}}"; export PATH;
      export PERL5LIB="~/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
      export PERL_LOCAL_LIB_ROOT="~/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
      export PERL_MB_OPT="--install_base \"~/perl5\"" 
      export PERL_MM_OPT="INSTALL_BASE=~/perl5"
      while read -r module ; do cpanm_modules="${cpanm_modules:-} $module " ; done < <(echo "$modules")
      cmd="cpanm $modules" 
      # quite often the perl modules passes trough on the second run ...
      $cmd || bash "$unit_run_dir/$RUN_UNIT"'.sh'
      sudo curl -L cpanmin.us | perl - Mojolicious

      # nasty workaround for the "Moo complainings" in the Net::Google::DataAPI::Oauth2 module
      find ~ -type f -name OAuth2.pm -exec perl -pi -e \
         "s/use Any::Moose;/no warnings 'deprecated'; use Any::Moose; use warnings 'deprecated';/g" {} \;
   }
}


# ------------------------------------------------------------------------------
# clean and exit with passed status and message
# call by:
# do_exit 0 "ok msg"
# do_exit 1 "NOK msg"
# ------------------------------------------------------------------------------
do_exit(){
   exit_code=$1 ; shift
   exit_msg="$*"

   if (( ${exit_code:-} != 0 )); then
      exit_msg=" ERROR --- exit_code $exit_code --- exit_msg : $exit_msg"
      >&2 echo "$exit_msg"
      do_log "FATAL STOP FOR $RUN_UNIT RUN with: "
      do_log "FATAL exit_code: $exit_code exit_msg: $exit_msg"
   else
      do_log "INFO  STOP FOR $RUN_UNIT RUN with: "
      do_log "INFO  STOP FOR $RUN_UNIT RUN: $exit_code $exit_msg"
   fi

   test $exit_code -eq 0 && exit 0
}

#------------------------------------------------------------------------------
# echo pass params and print them to a log file and terminal
# usage:
# do_log "INFO some info message"
# do_log "DEBUG some debug message"
#------------------------------------------------------------------------------
do_log(){
   type_of_msg=$(echo $*|cut -d" " -f1)
   msg="$(echo $*|cut -d" " -f2-)"
   test -t 1 && echo " [$type_of_msg] `date "+%Y.%m.%d-%H:%M:%S %Z"` [$RUN_UNIT][@$host_name] [$$] $msg "
}

do_provision_postgres(){

   source $product_instance_dir/lib/bash/funcs/export-json-section-vars.sh
   doExportJsonSectionVars $product_instance_dir/cnf/env/$ENV_TYPE.env.json '.env.db'

   sudo mkdir -p /etc/postgresql/11/main/
   sudo mkdir -p /var/lib/postgresql/11/main

   # echo "postgres:postgres" | chpasswd  # probably not needed ...
   echo 'export PS1="`date "+%F %T"` \u@\h  \w \\n\\n  "' | sudo tee -a /var/lib/postgresql/.bash_opts
   
   sudo /etc/init.d/postgresql restart
   sudo -u postgres psql -c \
      "CREATE USER "$postgres_db_useradmin" WITH SUPERUSER CREATEROLE CREATEDB REPLICATION BYPASSRLS 
      PASSWORD '"$postgres_db_useradmin_pw"';"
   sudo -u postgres psql -c "grant all privileges on database postgres to "$postgres_db_useradmin" ;"
   sudo -u postgres psql template1 -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'
   sudo -u postgres psql template1 -c 'CREATE EXTENSION IF NOT EXISTS "pgcrypto";'
   sudo -u postgres psql template1 -c 'CREATE EXTENSION IF NOT EXISTS "dblink";' 

   psql_cnf_dir='/etc/postgresql/11/main'
   test -f $psql_cnf_dir/pg_hba.conf && \
      sudo cp -v $psql_cnf_dir/pg_hba.conf $psql_cnf_dir/pg_hba.conf.orig.bak && \
      sudo cp -v $product_instance_dir/cnf/postgres/$psql_cnf_dir/pg_hba.conf $psql_cnf_dir/pg_hba.conf && \
      sudo chown postgres:postgres $psql_cnf_dir

   test -f $psql_cnf_dir/postgresql.conf && \
      sudo cp -v $psql_cnf_dir/postgresql.conf $psql_cnf_dir/postgresql.conf.orig && \
      sudo cp -v $product_instance_dir/cnf/postgres/$psql_cnf_dir/postgresql.conf $psql_cnf_dir/postgresql.conf

   sudo chown -R postgres:postgres "/etc/postgresql" && \
      sudo chown -R postgres:postgres "/var/lib/postgresql" && \
      sudo chown -R postgres:postgres "/etc/postgresql/11/main/pg_hba.conf" && \
      sudo chown -R postgres:postgres "/etc/postgresql/11/main/postgresql.conf"

   sudo /etc/init.d/postgresql restart
}

do_create_multi_env_dir(){
   test -d "$PRODUCT_INSTANCE_DIR" && \
      mv -v "$PRODUCT_INSTANCE_DIR" "$PRODUCT_INSTANCE_DIR"."$(date '+%Y%m%d_%H%M%S')"

   mv -v "$product_dir" "$product_dir"'_'
   mkdir -p "$product_dir" ;  mv -v "$product_dir"'_' "$PRODUCT_INSTANCE_DIR"; 
}


# well 
do_setup_tmux(){
   test -f ~/.tmux.conf && cp -v  ~/.tmux.conf ~/.tmux.conf.orig
   cp -v $product_dir/cnf/hosts/host-name/home/ysg/.tmux.conf ~/
   mkdir -p ~/.tmux/plugins
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tmux-copycat
}

do_create_multi_env_dir(){
   test -d "$PRODUCT_INSTANCE_DIR" && \
      mv -v "$PRODUCT_INSTANCE_DIR" "$PRODUCT_INSTANCE_DIR"."$(date '+%Y%m%d_%H%M%S')"

   mv -v "$product_dir" "$product_dir"'_'
   mkdir -p "$product_dir" ;  mv -v "$product_dir"'_' "$PRODUCT_INSTANCE_DIR"; 
}

do_finilize(){
   source ~/.bash_opts 
   printf "\033[2J";printf "\033[0;0H"
   echo -e "\n\n"
   echo ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
   echo "DONE"
   echo "# next you MUST reload the new environment variables by:"
   echo " source ~/.bash_opts ; "
   echo "# and go to your PRODUCT_INSTANCE_DIR by: "
   echo " cd $PRODUCT_INSTANCE_DIR"
   echo "# you could than check the consistency of the Application Layer by:"
   echo "bash src/bash/qto/qto.sh -a check-perl-syntax"
   echo ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
}

main "$@"


# eof file src/bash/qto/bootstrap-qto-host-on-ubuntu.sh
