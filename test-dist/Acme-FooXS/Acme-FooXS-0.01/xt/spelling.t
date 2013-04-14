use strict;
use Test::More;
use File::Spec;
eval q{ use Test::Spelling };
plan skip_all => "Test::Spelling is not installed." if $@;
eval q{ use Pod::Wordlist::hanekomu };
plan skip_all => "Pod::Wordlist::hanekomu is not installed." if $@;

plan skip_all => "no ENV[HOME]" unless $ENV{HOME};
my $spelltest_switchfile = ".minil.spell";
plan skip_all => "no ~/$spelltest_switchfile" unless -e File::Spec->catfile($ENV{HOME}, $spelltest_switchfile);

add_stopwords('Acme-FooXS');
add_stopwords(qw());

$ENV{LANG} = 'C';
my $has_aspell;
foreach my $path (split(/:/, $ENV{PATH})) {
    -x "$path/aspell" and $has_aspell++, last;
}
plan skip_all => "no aspell" unless $has_aspell;
plan skip_all => "no english dict for aspell" unless `aspell dump dicts` =~ /en/;

set_spell_cmd('aspell list -l en');
all_pod_files_spelling_ok('lib');
