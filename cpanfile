#!perl
on 'test' => sub {
    requires 'Test::More', 0.98;
    requires 'File::Temp';
    requires 'File::pushd';
    requires 'File::Copy::Recursive';
};

on 'configure' => sub {
    requires 'Module::Build', '>= 0.38';
};

on 'develop' => sub {
    requires 'Minilla', '>= 0.3.2';
};

