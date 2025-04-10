s~%global\s+goipath\s+(.*)/(.*)~%global goihead \2\n%global goipath \1/%{goihead}~g;

my $text = << 'EOF';
shopt -s globstar

for i in **/* */*
do
  if test -f ${i}
  then
    sed -i "s~github.com/sagernet/sing~github.com/mahdi-zarei/sing~g;" "${i}"
  fi
done

EOF

s~(%goprep.*)~\1\n$text~g;

s~(Version:)\s*([^0-9\.]*)([0-9\.]*)([^\s]*)\s*~\1  \3\n%define oldver \2\3\4\n~g;
s~(^%gometa.*)~%{?!tag:%{?!commit:%global tag v%{oldver}}}\n\1\n~g;

s~%gocheck~~g;
s~Source:.*~%define scommit %{?commit}%{?!commit:v%{version}}\n%define stag %{?tag}%{?!tag:%scommit}\nSource: https://%{goipath}/archive/%{stag}/%{goihead}-%{stag}.tar.gz~g;
