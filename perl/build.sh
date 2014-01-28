#!/bin/bash
sh Configure -de -Dprefix=$PREFIX -Duserelocatableinc
make
make test
make install

# Create cpan directory
mkdir -p $PREFIX/.cpan

# Create CPAN config
echo '$CPAN::Config = {' > $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "scan_cache" => "atstart",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "prefer_installer" => "MB",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "show_zero_versions" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "perl5lib_verbosity" => "none",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "show_unparsable_versions" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "use_sqlite" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "build_requires_install_policy" => "yes",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "make_install_arg" => "",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "prerequisites_policy" => "ignore",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "make_arg" => "",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "colorize_output" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "mbuildpl_arg" => "",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "auto_commit" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "keep_source_where" => "'$PREFIX'/.cpan/sources",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "makepl_arg" => "",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "trust_test_report_history" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "pager" => "less",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "term_ornaments" => "1",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "build_dir_reuse" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "cache_metadata" => "1",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "show_upload_date" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "ftp_passive" => "1",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "test_report" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "histfile" => "'$PREFIX'/.cpan/histfile",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "inhibit_startup_message" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "build_dir" => "'$PREFIX'/.cpan/build",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "connect_to_internet_ok" => "1",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "halt_on_failure" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "no_proxy" => "",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "getcwd" => "cwd",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "yaml_load_code" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "prefs_dir" => "'$PREFIX'/.cpan/prefs",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "version_timeout" => "15",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "gpg" => "",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "mbuild_install_build_command" => "./Build",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "check_sigs" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "build_cache" => "100",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "load_module_verbosity" => "none",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "mbuild_arg" => "",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "yaml_module" => "YAML",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "tar_verbosity" => "none",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "histsize" => "100",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "cpan_home" => "'$PREFIX'/.cpan",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "prefer_external_tar" => "1",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "applypatch" => "",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "index_expire" => "1",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "mbuild_install_arg" => "",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "inactivity_timeout" => "0",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "ftp_proxy" => "",' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                  "commandnumber_in_prompt" => "1"' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '                };' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '1;' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
echo '__END__' >> $PREFIX/lib/perl5/5.18.2/CPAN/Config.pm
